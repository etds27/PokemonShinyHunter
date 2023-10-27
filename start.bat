set HOST="127.0.0.1"
set PORT=57375
set GAME="C:\Emulators\GBC\Pokemon Crystal.gbc"
set PSH_ROOT="C:\Users\etds2\Programming\PokemonLua"
start /b python3 "%PSH_ROOT%\src\PythonServer\server.py" %HOST% %PORT%
timeout 1
start "" "C:\Emulators\Bizhawk\EmuHawk.exe" --socket_ip=%HOST% --socket_port=%PORT% %GAME% 
