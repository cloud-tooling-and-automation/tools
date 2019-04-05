<#
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
    
    Prajyot Parab <Prajyot.Parab@ibm.com> - Initial implementation, bug fixes and minor adjustment.
#>

# assign cluster ip or hostname
param(
    [Parameter(Mandatory = $True, Position = 1)]
    [string]$CLUSTER_URL
)

# assign destination directory
$global:Dest_Dir = "C:\Windows\System32"

# assign tool name variable
$global:Tool_Name = ""

# assign temporary directory
$global:Temp_Dir = "C:\ICP-TOOLS"

# creates a temporary dir to store download stuff
function Pre-Install {
    New-Item -Path C:\ICP-TOOLS -ItemType Directory
    Set-Location -Path $Temp_Dir
}

# function to install kubectl tool
function Install-Kubectl {
    $Tool_Name = "Kubectl"
    $testInstall = Test-Path $Dest_Dir\kubectl.exe -PathType Leaf
    If ($testInstall) {

        Write-Output "Kubectl is already installed";
        If (Overwrite_Check) {
            Start-Process cmd -Argument "/c curl --progress-bar -kLo kubectl.exe https://$($CLUSTER_URL):8443/api/cli/kubectl-win-amd64.exe -w %{http_code}" -Wait -RedirectStandardOutput stdout.txt
        }
        Else {
            return
        }
    }
    Else {

        Start-Process cmd -Argument "/c curl --progress-bar -kLo kubectl.exe https://$($CLUSTER_URL):8443/api/cli/kubectl-win-amd64.exe -w %{http_code}" -Wait -RedirectStandardOutput stdout.txt
    }

    $Status_Code = Get-Content .\stdout.txt -Raw

    If ($Status_Code -eq 200) {

        Write-Output "Kubectl Download Complete ..."
    }
    Else {
    
        Write-Output "Kubectl Download Failed ..."
        Clean_Up
        exit 1
    }
}

# function to install cloudctl tool
function Install-Cloudctl {
    $Tool_Name = "Cloudctl"
    $testInstall = Test-Path $Dest_Dir\cloudctl.exe -PathType Leaf
    If ($testInstall) {

        Write-Output "Cloudctl is already installed";
        If (Overwrite_Check) {
            Start-Process cmd -Argument "/c curl --progress-bar -kLo cloudctl.exe https://$($CLUSTER_URL):8443/api/cli/cloudctl-win-amd64.exe -w %{http_code}" -Wait -RedirectStandardOutput stdout.txt
        }
        Else {
            return
        }
    }
    Else {

        Start-Process cmd -Argument "/c curl --progress-bar -kLo cloudctl.exe https://$($CLUSTER_URL):8443/api/cli/cloudctl-win-amd64.exe -w %{http_code}" -Wait -RedirectStandardOutput stdout.txt
    }
    $Status_Code = Get-Content .\stdout.txt -Raw

    If ($Status_Code -eq 200) {

        Write-Output "Cloudctl Download Complete ..."
    }
    Else {

        Write-Output "cloudctl Download Failed ..."
        Clean_Up
        exit 1
    }
}

# function to install istioctl tool
function Install-Istioctl {
    $Tool_Name = "Istioctl"
    $testInstall = Test-Path $Dest_Dir\istioctl.exe -PathType Leaf
    If ($testInstall) {

        Write-Output "Istioctl is already installed";
        If (Overwrite_Check) {
            Start-Process cmd -Argument "/c curl --progress-bar -kLo istioctl.exe https://$($CLUSTER_URL):8443/api/cli/istioctl-win-amd64.exe -w %{http_code}" -Wait -RedirectStandardOutput stdout.txt
        }
        Else {
            return
        }
    }
    Else {

        Start-Process cmd -Argument "/c curl --progress-bar -kLo istioctl.exe https://$($CLUSTER_URL):8443/api/cli/istioctl-win-amd64.exe -w %{http_code}" -Wait -RedirectStandardOutput stdout.txt
    }
    $Status_Code = Get-Content .\stdout.txt -Raw

    If ($Status_Code -eq 200) {

        Write-Output "Istioctl Download Complete ..."
    }
    Else {

        Write-Output "Istioctl Download Failed ..."
        Clean_Up
        exit 1
    }
}

# function to install calicoctl tool
function Install-Calicoctl {
    $Tool_Name = "Calicoctl"
    $testInstall = Test-Path $Dest_Dir\calicoctl.exe -PathType Leaf
    If ($testInstall) {

        Write-Output "Calicoctl is already installed";
        If (Overwrite_Check) {
            Start-Process cmd -Argument "/c curl --progress-bar -kLo calicoctl.exe https://$($CLUSTER_URL):8443/api/cli/calicoctl-win-amd64.exe -w %{http_code}" -Wait -RedirectStandardOutput stdout.txt
        }
        Else {
            return
        }
    }
    Else {

        Start-Process cmd -Argument "/c curl --progress-bar -kLo calicoctl.exe https://$($CLUSTER_URL):8443/api/cli/calicoctl-win-amd64.exe -w %{http_code}" -Wait -RedirectStandardOutput stdout.txt
    }
    $Status_Code = Get-Content .\stdout.txt -Raw

    If ($Status_Code -eq 200) {

        Write-Output "Calicoctl Download Complete ..."
    }
    Else {

        Write-Output "Calicoctl Download Failed ..."
        Clean_Up
        exit 1
    }
}

# function to install helm tool
function Install-Helm {
    $Tool_Name = "Helm"
    $testInstall = Test-Path $Dest_Dir\helm.exe -PathType Leaf
    If ($testInstall) {

        Write-Output "Helm is already installed";
        If (Overwrite_Check) {
            Start-Process cmd -Argument "/c curl --progress-bar -kLo helm-win-amd64.tar.gz https://$($CLUSTER_URL):8443/api/cli/helm-win-amd64.tar.gz -w %{http_code}" -Wait -RedirectStandardOutput stdout.txt
        }
        Else {
            return
        }
    }
    Else {

        Start-Process cmd -Argument "/c curl --progress-bar -kLo helm-win-amd64.tar.gz https://$($CLUSTER_URL):8443/api/cli/helm-win-amd64.tar.gz -w %{http_code}" -Wait -RedirectStandardOutput stdout.txt
    }
    $Status_Code = Get-Content .\stdout.txt -Raw

    If ($Status_Code -eq 200) {

        Write-Output "Helm Download Complete ..."
    }
    Else {

        Write-Output "Helm Download Failed ..."
        Clean_Up
        exit 1
    }

    Install_Module
    Expand-7Zip -FullName $Temp_Dir\helm-win-amd64.tar.gz
    Expand-7Zip -FullName $Temp_Dir\helm-win-amd64.tar
    Move-Item $Temp_Dir\windows-amd64\helm.exe $Temp_Dir
    Remove-Item -Recurse -Force $Temp_Dir\windows-amd64\
    Remove-Item -Recurse -Force $Temp_Dir\helm-win-amd64.tar
    Remove-Item -Recurse -Force $Temp_Dir\helm-win-amd64.tar.gz
}

# function to install all tools at once
function Install-All {

    Install-Kubectl
    Install-Cloudctl
    Install-Istioctl
    Install-Calicoctl
    Install-Helm
}

# function to copy all downloaded files to default environment path
function Post-Install {

    Copy-Item $Temp_Dir\* $Dest_Dir\
    Clean_Up
}

# function to clean up temporary directory
function Clean_Up {

    Set-Location -Path C:\
    $testInstall = Test-Path -Path $Temp_Dir\ 
    If ($testInstall) {
        Remove-Item -Recurse -Force $Temp_Dir
    }
    Else {
        return
    }
}

# function to check the accessibilty of address or hostname of cluster specified
function Check_Access {
    $testConnection = Test-Connection $CLUSTER_URL -Count 1
    If ($null -ne $testconnection) {
        Write-Output "$CLUSTER_URL is accessible"
    }
    Else {
        Write-Output "$CLUSTER_URL is not accessible";
        exit 1
    }
}

# function to warn about possible overwrite
function Overwrite_Check {
    $SubTitle = "Overwrite $Tool_Name"
    $SubInfo = "Do you want to overwrite exsisting $Tool_Name tool"
    $SubOptions = [System.Management.Automation.Host.ChoiceDescription[]] @("&Yes", "&No")
    [int]$SubDefaultChoice = 1
    $SubOpt = $host.UI.PromptForChoice($SubTitle, $SubInfo, $SubOptions, $SubDefaultChoice)
    $Tool_Name = ""
    switch ($SubOpt) {
        0 { return 1 }
        1 { return 0 }
    }
}

# function to install PS7Zip Module
function Install_Module {
    if (Get-Module -ListAvailable -Name PS7Zip) {
        Write-Output "PS7Zip Module exists"
    } 
    else {
        Install-Module -Name PS7Zip -RequiredVersion 2.2.0 -Force -AllowClobber 
    }
}

# perform clean up to remove older temporary directories
Clean_Up

# perform access check to cluster ip or hostname
Check_Access

# script to provide a custom prompt for the user to select a value
$Title = "Install ICP Tools"
$Info = "Select the tool you want to install"

$options = [System.Management.Automation.Host.ChoiceDescription[]] @("&1-Kubectl", "&2-Cloudctl", "&3-Istioctl", "&4-Calicoctl", "&5-Helm", "&All", "&Quit")
do {

    [int]$defaultchoice = 6
    $opt = $host.UI.PromptForChoice($Title, $Info, $Options, $defaultchoice)

    switch ($opt) {
        0 { Write-Output "Install Kubectl"; Pre-Install; Install-Kubectl; Post-Install}
        1 { Write-Output "Install Cloudctl"; Pre-Install; Install-Cloudctl; Post-Install}
        2 { Write-Output "Install Istioctl"; Pre-Install; Install-Istioctl; Post-Install}
        3 { Write-Output "Install Calicoctl"; Pre-Install; Install-Calicoctl; Post-Install}
        4 { Write-Output "Install Helm"; Pre-Install; Install-Helm; Post-Install}
        5 { Write-Output "Install All"; Pre-Install; Install-All; Post-Install; exit 1}
        6 { Write-Output "Quit" ; exit 1}
    }

} while ($opt -ne 6)
