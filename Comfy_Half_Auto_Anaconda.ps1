# 다운로드 (파일이 없을 때만)
if (-not (Test-Path "Anaconda3-2021.05-Windows-x86_64.exe")) {
    curl.exe -L -o "Anaconda3-2021.05-Windows-x86_64.exe" "https://repo.anaconda.com/archive/Anaconda3-2021.05-Windows-x86_64.exe"
}
if (-not (Test-Path "Git-2.52.0-64-bit.exe")) {
    curl.exe -L -o "Git-2.52.0-64-bit.exe" "https://github.com/git-for-windows/git/releases/download/v2.52.0.windows.1/Git-2.52.0-64-bit.exe"
}
if (-not (Test-Path "cuda_12.8.0_571.96_windows.exe")) {
    curl.exe -L -o "cuda_12.8.0_571.96_windows.exe" "https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda_12.8.0_571.96_windows.exe"
}
if (-not (Test-Path "cudnn_9.18.0_windows_x86_64.exe")) {
    curl.exe -L -o "cudnn_9.18.0_windows_x86_64.exe" "https://developer.download.nvidia.com/compute/cudnn/9.18.0/local_installers/cudnn_9.18.0_windows_x86_64.exe"
}

# Anaconda 설치
Clear-Host
Write-Host "Anaconda를 설치해주세요..."
Start-Process -FilePath ".\Anaconda3-2021.05-Windows-x86_64.exe" -Wait

# Git 설치
Clear-Host
Write-Host "Git을 설치해주세요..."
Start-Process -FilePath ".\Git-2.52.0-64-bit.exe" -Wait

# CUDA 설치
Clear-Host
Write-Host "CUDA를 설치해주세요..."
Start-Process -FilePath ".\cuda_12.8.0_571.96_windows.exe" -Wait

# cuDNN 설치
Clear-Host
Write-Host "cuDNN을 설치해주세요..."
Start-Process -FilePath ".\cudnn_9.18.0_windows_x86_64.exe" -Wait

# 설치용 BAT 파일 생성
$batContent = @"
@echo off
cd /d "%userprofile%\Desktop"
call conda init
call conda create -n comfy python=3.12 -y
call conda activate comfy
git clone https://github.com/Comfy-Org/ComfyUI
pip install -r "%userprofile%\Desktop\ComfyUI\requirements.txt"
pip install comfy-cli
comfy install
pip uninstall torch torchvision torchaudio -y
pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128
pip install triton-windows
pause
"@
Set-Content -Path "$env:USERPROFILE\Desktop\install_comfy.bat" -Value $batContent -Encoding ASCII

# 실행용 BAT 파일 생성
$runBatContent = @"
@echo off
call conda init
call conda activate comfy
cd /d "%userprofile%\Desktop\ComfyUI"
python main.py
pause
"@
Set-Content -Path "$env:USERPROFILE\Desktop\run_comfy.bat" -Value $runBatContent -Encoding ASCII

# 안내
Clear-Host
Write-Host "================================================"
Write-Host "설치가 완료되었습니다."
Write-Host "바탕화면에 생성된 install_comfy.bat 파일을 실행해주세요."
Write-Host "================================================"
pause