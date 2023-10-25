import argparse
import subprocess
import time

bot_id_save_states = {
    "CHRIS51032": "BotStates\\CHRIS51032\\StartUp.State",
    "ETHAN25996": "BotStates\\ETHAN25996\\StartUp.State"
}

parser = argparse.ArgumentParser()
parser.add_argument("-p", "--port", nargs=1, default=57375, type=int)
parser.add_argument("--host", nargs=1, default="127.0.0.1", type=str)
parser.add_argument("-g", "--game", nargs=1, default="C:\Emulators\GBC\Pokemon Crystal.gbc", type=str)
parser.add_argument("-e", "--emulator", nargs=1, default="C:\Emulators\Bizhawk\EmuHawk.exe", type=str)
parser.add_argument("--bot-ids", nargs="+")
args = parser.parse_args()

server_start_command = ["python3", "Python\\server.py", args.host, str(args.port)]
print(server_start_command)
server_p = subprocess.Popen(server_start_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
time.sleep(1)

if args.bot_ids:
    for bot_id in args.bot_ids:
        emulator_start_command = [args.emulator, 
                                  f"--socket_ip={args.host}", 
                                  f"--socket_port={args.port}", 
                                  f"--lua=Main.lua", 
                                  f"--load-state={bot_id_save_states[bot_id]}",
                                  args.game]
        emulator_p = subprocess.Popen(emulator_start_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

else:
    emulator_start_command = [args.emulator, 
                        f"--socket_ip={args.host}", 
                        f"--socket_port={args.port}", 
                        args.game]
    emulator_p = subprocess.Popen(emulator_start_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

for line in iter(server_p.stdout.readline, ''):
    print(line)
server_p.stdout.close()