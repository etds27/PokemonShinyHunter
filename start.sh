HOST=127.0.0.1
PORT=57374

python3 Python/server.py $HOST $PORT &
sleep 1
C:\Emulators\Bizhawk\EmuHawk.exe --socket_ip=127.0.0.1 --socket_port=57373 "C:\Emulators\GBC\Pokemon Crystal.gbc"
