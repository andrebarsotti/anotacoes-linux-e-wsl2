# Instalação WSL 2

1. Em um powershell com permissão adminstrativa:
  
  ```PowerShell
  Enable-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online -NoRestart
  Enable-WindowsOptionalFeature -FeatureName VirtualMachinePlatform -Online -NoRestart
  Restart-Computer
  ```

2. Depois de reiniciar em um terminal adminstrativo:
  
  ```PowerShell
  wsl --set-default-version 2
  ```

3. Pode ser necessário atualizar o kernel do WSL. No powershell faça:
  
  ```PowerShell
  Invoke-WebRequest -Uri https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -OutFile ./wsl_update_x64.msi
  ./wsl_update_x64.msi
  ```

Para baixar a distribuição que desejar basta procurar na Microsoft Store ou executar o comando:

  ```PowerShell
  wsl --install Ubuntu
  ```

O comando abaixo lista na linha de comando as distros disponíveis:

```PowerShell
wsl --list --online
```
