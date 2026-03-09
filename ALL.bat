@echo off

:: ===============================
:: CEK & MINTA AKSES ADMIN
:: ===============================
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Meminta izin Administrator...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

color 0A

set TEMP=%temp%


title Menu Skrip Gabungan (Admin)
color 0A

:main_menu
cls
echo ================================================
echo           MENU SKRIP GABUNGAN (Administrator)
echo ================================================
echo 1. Login SSID WiFi
echo 2. Icon This PC
echo 3. Shortcut Office di Desktop
echo 4. Nonaktifkan BitLocker (Service)
echo 5. Copy SN BIOS
echo 6. Web QC
echo 7. Massgrave script 
echo 8. Note akun OHS (auto_note_ohs)
echo 0. Keluar
echo ================================================
echo Note : Data Encryption jangan lupa dimatikan.
echo ================================================
echo Coming Soon 
echo 1. Wallpaper (auto_copy_wallpaper)
echo ================================================
set /p choice=Masukkan pilihan (0-8): 

if "%choice%"=="1" goto wifi_add
if "%choice%"=="2" goto this_pc
if "%choice%"=="3" goto office_shortcuts
if "%choice%"=="4" goto disable_bitlocker
if "%choice%"=="5" goto autocopysn
if "%choice%"=="6" goto open_web_qc
if "%choice%"=="7" goto massgrave
if "%choice%"=="8" goto note_ohs
if "%choice%"=="0" goto :end

echo Pilihan tidak valid. Tekan sembarang tombol...
pause >nul
goto main_menu

:: ===============================
:: 1. WIFI ADD (TSC KILLER & TSC KILLER_5G)
:: ===============================
:wifi_add
echo Menjalankan: Tambah SSID WiFi (TSC KILLER & TSC KILLER_5G)...
set TEMP=%temp%

(
echo ^<?xml version="1.0"?^>
echo ^<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1"^>
echo   ^<name^>TSC_KILLER^</name^>
echo   ^<SSIDConfig^>
echo     ^<SSID^>
echo       ^<name^>TSC KILLER^</name^>
echo     ^</SSID^>
echo   ^</SSIDConfig^>
echo   ^<connectionType^>ESS^</connectionType^>
echo   ^<connectionMode^>auto^</connectionMode^>
echo   ^<MSM^>
echo     ^<security^>
echo       ^<authEncryption^>
echo         ^<authentication^>WPA2PSK^</authentication^>
echo         ^<encryption^>AES^</encryption^>
echo         ^<useOneX^>false^</useOneX^>
echo       ^</authEncryption^>
echo       ^<sharedKey^>
echo         ^<keyType^>passPhrase^</keyType^>
echo         ^<protected^>false^</protected^>
echo         ^<keyMaterial^>admin123^</keyMaterial^>
echo       ^</sharedKey^>
echo     ^</security^>
echo   ^</MSM^>
echo ^</WLANProfile^>
) > "%TEMP%\TSC KILLER.xml"

netsh wlan add profile filename="%TEMP%\TSC KILLER.xml" user=all

(
echo ^<?xml version="1.0"?^>
echo ^<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1"^>
echo   ^<name^>TSC KILLER_5G^</name^>
echo   ^<SSIDConfig^>
echo     ^<SSID^>
echo       ^<name^>TSC KILLER_5G^</name^>
echo     ^</SSID^>
echo   ^</SSIDConfig^>
echo   ^<connectionType^>ESS^</connectionType^>
echo   ^<connectionMode^>auto^</connectionMode^>
echo   ^<MSM^>
echo     ^<security^>
echo       ^<authEncryption^>
echo         ^<authentication^>WPA2PSK^</authentication^>
echo         ^<encryption^>AES^</encryption^>
echo         ^<useOneX^>false^</useOneX^>
echo       ^</authEncryption^>
echo       ^<sharedKey^>
echo         ^<keyType^>passPhrase^</keyType^>
echo         ^<protected^>false^</protected^>
echo         ^<keyMaterial^>admin123^</keyMaterial^>
echo       ^</sharedKey^>
echo     ^</security^>
echo   ^</MSM^>
echo ^</WLANProfile^>
) > "%TEMP%\TSC KILLER_5G.xml"

netsh wlan add profile filename="%TEMP%\TSC KILLER_5G.xml" user=all

del "%TEMP%\TSC KILLER.xml" >nul 2>&1
del "%TEMP%\TSC KILLER_5G.xml" >nul 2>&1

echo.
echo ======================================
echo   SSID WiFi BERHASIL DITAMBAHKAN
echo   - TSC KILLER
echo   - TSC KILLER_5G
echo ======================================
echo Jika WiFi aktif, Windows akan auto-connect.
pause
goto main_menu

:: ===============================
:: 2. Buat Shortcut This_PC di Desktop
:: ===============================
:this_pc
echo Menjalankan: Buat Shortcut This_PC di Desktop...
@echo off
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f
taskkill /f /im explorer.exe >nul
start explorer.exe

echo Shortcut This_PC berhasil dibuat di Desktop.
pause
goto main_menu

:: ===============================
:: 3. Buat Shortcut Office di Desktop
:: ===============================
:office_shortcuts
echo Menjalankan: Buat Shortcut Office di Desktop...
set "DESKTOP=%USERPROFILE%\Desktop"
set "OFFICE=C:\Program Files\Microsoft Office\root\Office16"

powershell -NoProfile -Command "$s=(New-Object -COM WScript.Shell).CreateShortcut('%DESKTOP%\Microsoft Excel.lnk');$s.TargetPath='%OFFICE%\EXCEL.EXE';$s.Save()" 2>nul
powershell -NoProfile -Command "$s=(New-Object -COM WScript.Shell).CreateShortcut('%DESKTOP%\Microsoft Word.lnk');$s.TargetPath='%OFFICE%\WINWORD.EXE';$s.Save()" 2>nul
powershell -NoProfile -Command "$s=(New-Object -COM WScript.Shell).CreateShortcut('%DESKTOP%\Microsoft PowerPoint.lnk');$s.TargetPath='%OFFICE%\POWERPNT.EXE';$s.Save()" 2>nul

echo Shortcut Office berhasil dibuat di Desktop.
pause
goto main_menu

:: ===============================
:: 4. Nonaktifkan BitLocker (BDESVC)
:: ===============================
:disable_bitlocker
echo Menonaktifkan layanan yang berkaitan dengan BitLocker...
sc stop "BDESVC" >nul 2>&1
sc config "BDESVC" start= disabled >nul 2>&1
echo Jika layanan BitLocker ada, maka telah dinonaktifkan.
pause
goto main_menu

:: ===============================
:: 5. AutoCopySN (Copy BIOS Serial ke clipboard)
:: ===============================
:autocopysn
echo Menyalin Serial Number BIOS ke clipboard...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-CimInstance win32_bios | Select-Object -ExpandProperty SerialNumber | clip"
echo Serial Number telah disalin ke clipboard.
pause
goto main_menu

:: ===============================
:: 6. auto_open_web_qc (Buka beberapa halaman di Edge inprivate)
:: ===============================
:open_web_qc
echo Membuka halaman pengecekan di Microsoft Edge (inprivate)...
start "" msedge -inprivate "https://webcammictest.com/"
start "" msedge -inprivate "https://lcdtech.info/en/tests/dead.pixel.htm"
start "" msedge -inprivate "https://www.youtube.com/watch?v=6TWJaFD6R2s"
start "" msedge -inprivate "https://en.key-test.ru/"
echo Semua tab telah dibuka di Edge inprivate (jika Edge tersedia).
pause
goto main_menu

:: ===============================
:: 7. auto_open_massgrave (PowerShell dari web)  <-- PERINGATAN
:: ===============================
:massgrave
echo PERINGATAN: Tindakan ini akan mengeksekusi skrip yang diunduh dari internet.
echo Pastikan Anda mempercayai sumber sebelum melanjutkan.
set /p confirm=Ketik Y untuk melanjutkan atau N untuk batal:
if /i "%confirm%"=="Y" (
echo Menjalankan skrip dari https://get.activated.win ...
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://get.activated.win | iex"
) else (
echo Dibatalkan.
)
pause
goto main_menu

:: ===============================
:: 8. auto_note_ohs (Buat file akun OHS di Desktop)
:: ===============================
:note_ohs
echo Membuat file akun OHS di Desktop...
set /p nama_barang= Masukkan Nama Merk Laptop: 
set /p angka_stbjb= Masukkan Angka STBJB: 
(
    echo email: %nama_barang%.s.tbjb.%angka_stbjb%@outlook.com
    echo pass: Office123
) > "%USERPROFILE%\Desktop\AKUN OHS JANGAN DI HAPUS.txt"
echo File dibuat di Desktop: AKUN OHS JANGAN DI HAPUS.txt
pause
goto main_menu

:end
echo Keluar...
endlocal
exit /b 0
