#!/bin/bash

: '
    Copyright (C) 2019 IBM Corporation
    Licensed under the Apache License, Version 2.0 (the “License”);
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an “AS IS” BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

    Alisha Prabhu <alisha.prabhu@ibm.com> - Initial implementation.
'

# Trap ctrl-c and call ctrl_c().
trap ctrl_c INT

ctrl_c() {
        echo " Bye!"
        exit
}

# Executes the cleanup in the boot node.
cleanup_boot_node() {
/usr/bin/ssh $user@$ipBootNode "bash -s" << EOF
    echo "hostname of the machine is : "
    /bin/hostname
    echo "Executing command to uninstall ICP : "
    if [ $ifEE == "yes" ]; then
       /usr/bin/sudo docker run --net=host -t -e LICENSE=accept -v \
       "$(pwd)":/installer/cluster ibmcom/icp-inception-$(uname -m | sed 's/x86_64/amd64/g'):$version uninstall
    else
       /usr/bin/sudo docker run --net=host -t -e LICENSE=accept -v \
       "$(pwd)":/installer/cluster ibmcom/icp-inception:$version uninstall
    fi
    echo "Executing command for removing leftover docker containers and images"
    /usr/bin/docker system prune -a -f
    echo "Removing /var/lib/docker  and restarting docker service"
    /usr/sbin/service docker stop
    /bin/rm -rf /var/lib/docker
    /usr/sbin/service docker start
EOF
}

# Executes the cleanup in all the boot node.
cleanup_all_other_nodes() {
echo "ssh to each cluster node for cleanup ..."
for node_ip in $( grep -E "^[^#[]" "$installationDirPath"/cluster/hosts | sort -u | sed 's/|/\n/g' ); do
   /usr/bin/ssh $user@"$node_ip" "bash -s" << EOF
   echo "hostname of the machine is : "
   /bin/hostname
   echo "Executing command for removing leftover docker containers and images"
   /usr/bin/docker system prune -a -f
   echo "Removing /var/lib/docker  and restarting docker service"
   /usr/sbin/service docker stop
   /bin/rm -rf /var/lib/docker
   /usr/sbin/service docker start
   echo "Executing command to delete the contents of /var/lib/registry /etc/cfc \
   /opt/ibm/cfc /var/lib/etcd /var/lib/etcd-wal/wal /var/lib/kubelet /var/lib/mysql /var/lib/icp"
   /bin/rm -rf /var/lib/registry /etc/cfc /opt/ibm/cfc /var/lib/etcd /var/lib/etcd-wal/wal \
   /var/lib/kubelet /var/lib/mysql /var/lib/icp
   if [ $ipBootNode != $node_ip ]; then
      echo "Rebooting the host..."
      reboot
   fi
EOF
done
}

# Ensure the user running this script is an admin or have great powers.
if [[ $EUID -ne 0 ]]; then
            echo "This script must be run as root/sudo"
            exit
fi

# Asks for the confirmation on whether or not the user is running in the node from where
# it did the very first ICP setup for the cluster it is going to clean
echo "WARNING: this script must be executed from the node used to install ICP (i.e boot node)"
read -p "Are you running this script from the node from where you install ICP? " -n 1 -r
echo
if [[ ! $ANSWER =~ ^[Yy]$ ]]; then

    echo "Enter the IP of the boot node (public/private), the same ip used in /cluster/hosts file: "
    read ipBootNode

    echo "Enter the ssh user (the user that can access all other nodes in the cluster): "
    read user

    echo "Enter the ICP version you want to uninstall e.g. 3.1.1-ee"
    read version

    echo "Is it Enterprise Edition (yes/no) ?"
    read ifEE

    echo "Enter installation directory path e.g. /opt/ibm-cloud-private-ppc64le-3.1.1 : "
    read installationDirPath

    cd $installationDirPath/cluster || exit

    cleanup_boot_node
    cleanup_all_other_nodes

    echo "Rebooting the boot node"
    reboot
else
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi
