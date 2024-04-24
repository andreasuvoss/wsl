# PowerShell script created to iterate faster on the image,
# setting up everything required for WSL2

Set-PSDebug -Trace 2

$DistroName = Read-Host -Prompt 'Input distribution name here'

podman build . --no-cache -t custom-fedora:latest
$ContainerId = podman run -d custom-fedora:latest /bin/zsh
$Command = echo "podman export -o $DistroName.tar $ContainerId"
echo $Command
Invoke-Expression "podman export -o $DistroName.tar $ContainerId"

podman stop $ContainerId
podman rm $ContainerId

mkdir C:\wsl\$DistroName
wsl --import $DistroName C:\wsl\$DistroName .\$DistroName.tar

rm .\$DistroName.tar

wsl -d $DistroName

# wsl --unregister $DistroName
# rm C:\wsl\$DistroName