# Instalação WSL 2

Em um powershell com permissão adminstrativa:


1. Enable-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online -NoRestart
1. Enable-WindowsOptionalFeature -FeatureName VirtualMachinePlatform -Online -NoRestart
1. Restart-Computer

Depois de reiniciar em um terminal adminstrativo:
1. wsl --set-default-version 2

Pode ser necessário atualizar o kernel do WSL. No powershell faça
1.  Invoke-WebRequest -Uri https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -OutFile ./wsl_update_x64.msi
2.  ./wsl_update_x64.msi

Para baixar a distribuição que desejar basta procurar na Microsoft Store