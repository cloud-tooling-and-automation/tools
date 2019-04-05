# Project Description
The command line interface (CLI) tools provides the ability to manage applications, containers, infrastructures, services and other resources. The ICP Tools Configuration Scripts aims to easy the setup and configuration process in a more user interactive way.

## Contributing to the project
We welcome contributions to the ICP Tools Configuration Scripts Project in many forms. There's always plenty to do! Full details of how to contribute to this project are documented in the
[CONTRIBUTING.md](CONTRIBUTING.md) file.

## Maintainers
The project's [maintainers](MAINTAINERS.txt): are responsible for reviewing and merging all pull requests and they guide the over-all technical direction of the project.

## Communication <a name="communication"></a>
We use [Gitter](https://gitter.im/cloud-tooling-and-automation/community) for communication.

## Supported Architecture and Operating Systems

x86_64:   Ubuntu (16.04, 18.04), CentOS7, RHEL, SLES, Fedora, Windows (7, 8.1, 10).

ppc64le:  Ubuntu (16.04, 18.04), CentOS7, RHEL, SLES, Fedora.

s390x:    Ubuntu (16.04, 18.04), CentOS7, RHEL, SLES, Fedora.

## Usage

### Linux (x86_64, ppc64le, s390x)

#### Prerequisite on Linux
1.  curl
2.  tar

#### Steps to execute script on Linux (as Administrator)
1.  Download the script
2.  Make script executable
3.  Run script
*   Interactive mode      - **./icp-tool.sh 1.1.1.1** (specify cluster_url as argument)
*   Non-Interactive mode  - **./icp-tool.sh 1.1.1.1 tool1 tool2** (specify cluster_url as argument followed by name of tools to be installed as arguments)

### Mac (x86_64)

#### Prerequisite on Mac
1.  curl
2.  tar

#### Steps to execute script on Mac (as Administrator)
1.  Download the script
2.  Make script executable
3.  Run script
*   Interactive mode      - **./icp-tool.sh 1.1.1.1** (specify cluster_url as argument)
*   Non-Interactive mode  - **./icp-tool.sh 1.1.1.1 tool1 tool2** (specify cluster_url as argument followed by name of tools to be installed as arguments)

### Windows 10(x86_64)

#### Prerequisite on Win 10
1.  curl
2.  tar
3.  Powershell 3.0 and above

#### Steps to execute script on Win 10 (as Administrator)
1.  Download the script
2.  Open Powershell (**Run as Administrator**)
3.  Run command **Set-ExecutionPolicy -ExecutionPolicy RemoteSigned**

`The RemoteSigned execution policy allows you to run scripts that you have written on the local computer. Any script downloaded from the Internet must be signed by a trusted publisher or must be unblocked.`

4.  Run command **Get-ExecutionPolicy**

`This command gets the current execution policy for the computer. (Expected output: RemoteSigned)`

3.  Run script (eg. **&./icp-tool.ps1** OR **&./icp-tool.ps1 1.1.1.1**)

### Windows 7/8.1 (x86_64)

#### Prerequisite on Win 7/8.1
1.  curl - [Download Link](https://curl.haxx.se/windows/)

`Note : Add curl path to system environment`

2.  Powershell 5.0 and above

#### Steps to execute script on Win 7/8.1 (as Administrator)
1.  Download the script
2.  Open Powershell (**Run as Administrator**)
3.  Run command **Set-ExecutionPolicy -ExecutionPolicy RemoteSigned**

`The RemoteSigned execution policy allows you to run scripts that you have written on the local computer. Any script downloaded from the Internet must be signed by a trusted publisher or must be unblocked.`

4.  Run command **Get-ExecutionPolicy**

`This command gets the current execution policy for the computer. (Expected output: RemoteSigned)`

3.  Run script (eg. **&./icp-tool.ps1** OR **&./icp-tool.ps1 1.1.1.1**)

## Still Have Questions ?
For general purpose questions, please use [StackOverflow](https://stackoverflow.com/questions/tagged/ibm-cloud-private).

## License <a name="license"></a>
The ICP Tools Configuration Scripts Project uses the [Apache License Version 2.0](LICENSE) software license.

## Related information
[ICP CLI Tools Guide](https://www.ibm.com/support/knowledgecenter/SSBS6K_3.1.2/manage_cluster/cli_guide.html)
