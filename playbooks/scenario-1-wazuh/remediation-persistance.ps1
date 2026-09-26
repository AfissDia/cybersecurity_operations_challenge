# Script de remediation - Suppression des persistances
# Incident n2 - TechnoVision SOC
# Usage : executer en PowerShell administrateur

Write-Host "Suppression des cles de registre Run malveillantes..." -ForegroundColor Yellow
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v UpdateService /f 2>$null
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v UpdateService2 /f 2>$null
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v UpdateService3 /f 2>$null

Write-Host "Suppression des taches planifiees malveillantes..." -ForegroundColor Yellow
schtasks /delete /tn "WindowsUpdateCheck" /f 2>$null
schtasks /delete /tn "WindowsUpdateCheck2" /f 2>$null

Write-Host "Remediation terminee." -ForegroundColor Green
