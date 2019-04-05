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

    Prajyot Parab <Prajyot.Parab@ibm.com> - Initial implementation.
    Rafael Sene <rpsene@br.ibm.com> - Bug fixes and minor adjustments.
'

# assign cluster ip or hostname
CLUSTER_URL=$1

# assign destination directory path
DESTINATION_DIR=/usr/local/bin

# assign architecture on which script is ran
ARCH=$(uname -m)
if [ "$ARCH" == "x86_64" ]; then
	ARCH="amd64"
fi

# assign temporary directory path
TMP_DIR=downloads
SUCCESS="Installation successfully completed !!!"
FAIL="Installation failed !!!"

# Trap ctrl-c and call ctrl_c()
trap ctrl_c INT
function ctrl_c() {
	echo "Bye!"
	exit 0
}

# creates a temporary dir to store download stuff
function temporary_dir() {
	if [ ! -d $TMP_DIR ]; then
		mkdir -p ./$TMP_DIR
		cd ./$TMP_DIR || exit
	else
		cd ./$TMP_DIR || exit
	fi
}

# function to install cloudctl tool
function install_cloudctl() {
	if [ ! -f $DESTINATION_DIR/cloudctl ]; then
		echo
		echo "Installing cloudctl..."
		RESPONSE=$(
			curl --progress-bar -kLo cloudctl \
			https://"$CLUSTER_URL":8443/api/cli/cloudctl-linux-$ARCH -w "%{http_code}"
		)
		if [ "$RESPONSE" == 200 ]; then
			chmod +x cloudctl
			mv cloudctl $DESTINATION_DIR
			echo "$SUCCESS"
		else
			echo "$FAIL"
		fi
	else
		echo "cloudctl is already installed."
	fi
}

# function to install kubectl tool
function install_kubectl() {
	if [ ! -f $DESTINATION_DIR/kubectl ]; then
		echo
		echo "Installing kubectl..."
		RESPONSE=$(
			curl --progress-bar -kLo kubectl \
			https://"$CLUSTER_URL":8443/api/cli/kubectl-linux-$ARCH -w "%{http_code}"
		)
		if [ "$RESPONSE" == 200 ]; then
			chmod +x kubectl
			mv kubectl $DESTINATION_DIR
			echo "$SUCCESS"
		else
			echo "$FAIL"
		fi
	else
		echo "kubectl is already installed."
	fi
}

# function to install istioctl tool
function install_istioctl() {
	if [ ! -f $DESTINATION_DIR/istioctl ]; then
		echo
		echo "Installing istioctl..."
		RESPONSE=$(
			curl --progress-bar -kLo istioctl \
			https://"$CLUSTER_URL":8443/api/cli/istioctl-linux-$ARCH -w "%{http_code}"
		)
		if [ "$RESPONSE" == 200 ]; then
			chmod +x istioctl
			mv istioctl $DESTINATION_DIR
			echo "$SUCCESS"
		else
			echo "$FAIL"
		fi
	else
		echo "istioctl is already installed."
	fi
}

# function to install helm tool
function install_helm() {
	if [ ! -f $DESTINATION_DIR/helm ]; then
		echo
		echo "Installing helm..."
		RESPONSE=$(
			curl --progress-bar -kLo helm-linux-$ARCH.tar.gz \
			https://"$CLUSTER_URL":8443/api/cli/helm-linux-$ARCH.tar.gz -w "%{http_code}"
		)
		if [ "$RESPONSE" == 200 ]; then
			tar -xzf helm-linux-$ARCH.tar.gz
			mv linux-$ARCH/helm $DESTINATION_DIR
			echo "$SUCCESS"
		else
			echo "$FAIL"
		fi
	else
		echo "helm is already installed."
	fi
}

# function to install calicoctl tool
function install_calicoctl() {
	if [ ! -f $DESTINATION_DIR/calicoctl ]; then
		echo
		echo "Installing calico..."
		RESPONSE=$(
			curl --progress-bar -kLo calicoctl \
			https://"$CLUSTER_URL":8443/api/cli/calicoctl-linux-$ARCH -w "%{http_code}"
		)
		if [ "$RESPONSE" == 200 ]; then
			chmod +x calicoctl
			mv calicoctl $DESTINATION_DIR
			echo "$SUCCESS"
		else
			echo "$FAIL"
		fi
	else
		echo "calicoctl is already installed."
	fi
}

# function to install all tools at once
function install_all_tools() {
	install_cloudctl
	install_kubectl
	install_istioctl
	install_helm
	install_calicoctl
}

# script should be called with address or hostname of cluster as argument (interactive mode)
if [ "$#" -lt 1 ]; then
	echo
	echo "Please, set the address or hostname of your cluster."
	echo "./install-tool.sh 1.1.1.1"
	exit 1
fi

# script to check the accessibilty of address or hostname of cluster specified
if ping -c 1 "$1" &>/dev/null; then
	echo
	echo "SUCCESS: $1 is accessible..."
else
	echo
	echo "FAIL: $1 is not accessible..."
	exit 1
fi

# script to print architecture on which script is running
echo "You are running on $ARCH."
echo

# script should be called with address or hostname of cluster as argument followed with tool names as arguments (non-interactive mode)
if [ "$#" -gt 1 ]; then
	shift
	for x in "$@"; do
		case $x in
		"cloudctl")
			temporary_dir
			install_cloudctl
			continue
			;;
		"kubectl")
			temporary_dir
			install_kubectl
			continue
			;;
		"istioctl")
			temporary_dir
			install_istioctl
			continue
			;;
		"helm")
			temporary_dir
			install_helm
			continue
			;;
		"calicoctl")
			temporary_dir
			install_calicoctl
			continue
			;;
		"all")
			temporary_dir
			install_all_tools
			continue
			;;
		*) printf '%s\n' 'invalid option' ;;
		esac
	done
	exit 1
fi

# adding selected tool to queue of tools to be installed
choice() {
	local choice=$1
	if [[ -n ${opts[choice]} ]]; then # toggle
		opts[choice]=
	else
		opts[choice]=+
	fi
}
sleep 3

# interactive menu to allow selection of multiple tools at once
PS3='Please select the tools you want to install: '
while :; do
	clear
	options=("cloudctl ${opts[1]}" "kubectl ${opts[2]}" "istioctl ${opts[3]}" "helm ${opts[4]}" "calicoctl ${opts[5]}" "all ${opts[6]}" "Done")
	select opt in "${options[@]}"; do
		case $opt in
		"cloudctl ${opts[1]}")
			choice 1
			break
			;;
		"kubectl ${opts[2]}")
			choice 2
			break
			;;
		"istioctl ${opts[3]}")
			choice 3
			break
			;;
		"helm ${opts[4]}")
			choice 4
			break
			;;
		"calicoctl ${opts[5]}")
			choice 5
			break
			;;
		"all ${opts[6]}")
			choice 6
			break
			;;
		"Done")
			break 2
			;;
		*) printf '%s\n' 'invalid option' ;;
		esac
	done
done

printf '%s\n' 'Options chosen:'

# installation of selected tools
for opt in "${!opts[@]}"; do
	case $opt in
	"1")
		temporary_dir
		install_cloudctl
		continue
		;;
	"2")
		temporary_dir
		install_kubectl
		continue
		;;
	"3")
		temporary_dir
		install_istioctl
		continue
		;;
	"4")
		temporary_dir
		install_helm
		continue
		;;
	"5")
		temporary_dir
		install_calicoctl
		continue
		;;
	"6")
		temporary_dir
		install_all_tools
		continue
		;;
	esac
done
