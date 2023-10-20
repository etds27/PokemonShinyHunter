set HOST="127.0.0.1"
set PORT=57373
set GAME="C:\Emulators\GBC\Pokemon Crystal.gbc"
start /b python3 "Python\server.py" %HOST% %PORT%
timeout 1
start "" "C:\Emulators\Bizhawk\EmuHawk.exe" --socket_ip=%HOST% --socket_port=%PORT% %GAME%
