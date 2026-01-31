@echo off
setlocal enabledelayedexpansion

set "PS1_FILE=%~dp0comfy_setup.ps1"

(
echo # Download only if file does not exist
echo if ^(-not ^(Test-Path "Anaconda3-2021.05-Windows-x86_64.exe"^)^) {
echo     curl.exe -L -o "Anaconda3-2021.05-Windows-x86_64.exe" "https://repo.anaconda.com/archive/Anaconda3-2021.05-Windows-x86_64.exe"
echo }
echo if ^(-not ^(Test-Path "Git-2.52.0-64-bit.exe"^)^) {
echo     curl.exe -L -o "Git-2.52.0-64-bit.exe" "https://github.com/git-for-windows/git/releases/download/v2.52.0.windows.1/Git-2.52.0-64-bit.exe"
echo }
echo if ^(-not ^(Test-Path "cuda_12.8.0_571.96_windows.exe"^)^) {
echo     curl.exe -L -o "cuda_12.8.0_571.96_windows.exe" "https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda_12.8.0_571.96_windows.exe"
echo }
echo if ^(-not ^(Test-Path "cudnn_9.18.0_windows_x86_64.exe"^)^) {
echo     curl.exe -L -o "cudnn_9.18.0_windows_x86_64.exe" "https://developer.download.nvidia.com/compute/cudnn/9.18.0/local_installers/cudnn_9.18.0_windows_x86_64.exe"
echo }
echo.
echo # Anaconda Install
echo Clear-Host
echo Write-Host "Installing Anaconda..."
echo Start-Process -FilePath ".\Anaconda3-2021.05-Windows-x86_64.exe" -Verb RunAs -Wait
echo.
echo # Git Install
echo Clear-Host
echo Write-Host "Installing Git..."
echo Start-Process -FilePath ".\Git-2.52.0-64-bit.exe" -Verb RunAs -Wait
echo.
echo # CUDA Install
echo Clear-Host
echo Write-Host "Installing CUDA..."
echo Start-Process -FilePath ".\cuda_12.8.0_571.96_windows.exe" -Verb RunAs -Wait
echo.
echo # cuDNN Install
echo Clear-Host
echo Write-Host "Installing cuDNN..."
echo Start-Process -FilePath ".\cudnn_9.18.0_windows_x86_64.exe" -Verb RunAs -Wait
echo.
echo # Create install batch file
echo $batContent = @"
echo @echo off
echo cd /d "%%userprofile%%\Desktop"
echo call conda init
echo call conda create -n comfy python=3.12 -y
echo call conda activate comfy
echo git clone https://github.com/Comfy-Org/ComfyUI
echo pip install -r "%%userprofile%%\Desktop\ComfyUI\requirements.txt"
echo pip install comfy-cli
echo comfy install
echo pip uninstall torch torchvision torchaudio -y
echo pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128
echo pip install triton-windows
echo pip install insightface onnxruntime segment_anything ultralytics capabilities
echo pause
echo "@
echo Set-Content -Path "$env:USERPROFILE\Desktop\install_comfy.bat" -Value $batContent -Encoding ASCII
echo.
echo # Create run batch file
echo $runBatContent = @"
echo @echo off
echo call conda init
echo call conda activate comfy
echo cd /d "%%%%userprofile%%%%\Desktop\ComfyUI"
echo python main.py
echo pause
echo "@
echo Set-Content -Path "$env:USERPROFILE\Desktop\run_comfy.bat" -Value $runBatContent -Encoding ASCII
echo.
echo # Complete
echo Clear-Host
echo Write-Host "================================================"
echo Write-Host "Installation completed."
echo Write-Host "Please run install_comfy.bat on your Desktop."
echo Write-Host "================================================"
echo pause
) > "%PS1_FILE%"

powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%PS1_FILE%"

del "%PS1_FILE%"

pause