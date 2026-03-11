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
echo 3. Wallpaper (auto_copy)
echo 4. Shortcut Office di Desktop
echo 5. Nonaktifkan BitLocker (Service)
echo 6. Copy SN BIOS
echo 7. Web QC
echo 8. Massgrave script 
echo 9. Note akun OHS (auto_note_ohs)
echo 0. Keluar
echo ================================================
echo Note : Data Encryption jangan lupa dimatikan.
echo ================================================

set /p choice=Masukkan pilihan (0-9): 

if "%choice%"=="1" goto wifi_add
if "%choice%"=="2" goto this_pc
if "%choice%"=="3" goto wallpaper
if "%choice%"=="4" goto office_shortcuts
if "%choice%"=="5" goto disable_bitlocker
if "%choice%"=="6" goto autocopysn
if "%choice%"=="7" goto open_web_qc
if "%choice%"=="8" goto massgrave
if "%choice%"=="9" goto note_ohs
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
echo Menjalankan: Buat Shortcut This PC di Desktop...
@echo off

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f >nul

ie4uinit.exe -show

echo Shortcut This PC berhasil ditampilkan di Desktop.
pause
goto main_menu
:: ===============================
:: 3. Wallpaper
:: ===============================
:wallpaper
echo Menjalankan: Wallpaper auto copy...
@echo off
setlocal enabledelayedexpansion

REM folder gambar (di tempat yang sama dengan BAT)
set "SOURCE=%~dp0WALPAPER"

REM folder tujuan
set "DEST=%USERPROFILE%\Pictures"

echo ===== DEBUG INFO =====
echo SOURCE = %SOURCE%
echo DEST   = %DEST%
echo ======================

REM cek folder sumber
if not exist "%SOURCE%" (
    echo Folder WALPAPER tidak ditemukan!
    pause
    exit
)

REM buat folder tujuan jika belum ada
if not exist "%DEST%" mkdir "%DEST%"

echo.
echo Menyalin semua gambar ke Pictures...

for %%i in ("%SOURCE%\*.jpg" "%SOURCE%\*.jpeg" "%SOURCE%\*.png" "%SOURCE%\*.bmp") do (
    if exist "%%i" (
        copy "%%i" "%DEST%\" /Y >nul
        echo Disalin: %%~nxi
    )
)

echo.
echo Memilih wallpaper secara random...

REM hitung jumlah gambar
set count=0
for %%i in ("%DEST%\*.jpg") do (
    set /a count+=1
    set img[!count!]=%%i
)

REM pilih random
set /a rand=(%random% %% count) + 1
set "WP=!img[%rand%]!"

echo Wallpaper terpilih:
echo !WP!

REM set wallpaper menggunakan PowerShell
powershell -command "(Add-Type '[DllImport(\"user32.dll\")]public static extern int SystemParametersInfo(int uAction,int uParam,string lpvParam,int fuWinIni);' -Name a -Pas)::SystemParametersInfo(20,0,'!WP!',3)"

echo.
echo Wallpaper berhasil dipasang.
pause
goto main_menu

:: ===============================
:: 4. Buat Shortcut Office di Desktop
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
:: 5. Nonaktifkan BitLocker (BDESVC)
:: ===============================
:disable_bitlocker
echo Menonaktifkan layanan yang berkaitan dengan BitLocker...
sc stop "BDESVC" >nul 2>&1
sc config "BDESVC" start= disabled >nul 2>&1
echo Jika layanan BitLocker ada, maka telah dinonaktifkan.
pause
goto main_menu

:: ===============================
:: 6. AutoCopySN (Copy BIOS Serial ke clipboard)
:: ===============================
:autocopysn
echo Menyalin Serial Number BIOS ke clipboard...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-CimInstance win32_bios | Select-Object -ExpandProperty SerialNumber | clip"
echo Serial Number telah disalin ke clipboard.
pause
goto main_menu

:: ===============================
:: 7. auto_open_web_qc (Buka beberapa halaman di Edge inprivate)
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
:: 8. auto_open_massgrave (PowerShell dari web)  <-- PERINGATAN
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
:: 9. auto_note_ohs (Buat file akun OHS di Desktop)
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
