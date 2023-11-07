import argparse
import os
import shutil
import subprocess
import time

bot_id_save_states = {
    "CHRIS51032": "BotStates\\CHRIS51032\\StartUp.State",
    "ETHAN25996": "BotStates\\ETHAN25996\\StartUp.State"
}

os.environ["LUA_PATH"] = ""
# os.environ["PSH_ROOT"] = "C:\\Users\\etds2\\Programming\\PokemonLua"
# Sets the root environment to be the directory of this script
# Therefore this script should always be at the top level of the project
os.environ["PSH_RO OT"] = os.path.dirname(os.path.abspath(__file__))
ROOT_DIR = os.environ["PSH_ROOT"]
SRC_DIR = os.path.join(ROOT_DIR, "src")
TEST_DIR = os.path.join(ROOT_DIR, "Tests")
SHORTCUTS_DIR = os.path.join(ROOT_DIR, "Shortcuts")


parser = argparse.ArgumentParser()
parser.add_argument("--emu-only", action="store_true")
parser.add_argument("-p", "--port", nargs=1, default=57375, type=int)
parser.add_argument("--host", nargs=1, default="127.0.0.1", type=str)
parser.add_argument("-g", "--game", nargs=1, default="C:\Emulators\GBC\Pokemon Crystal.gbc", type=str)
parser.add_argument("-e", "--emulator", nargs=1, default="C:\Emulators\Bizhawk\EmuHawk.exe", type=str)
parser.add_argument("--bot-ids", nargs="+")
args = parser.parse_args()

def create_luases(lua_files, path):
    print(f"Creating .luases for {path}")
    with open(path, "w") as f:
        [f.write(f"0 {lua_file}\n") for lua_file in lua_files]

def update_lua_path(lua_files):     
    for lua_file in lua_files:
        os.environ["LUA_PATH"] = f"{os.environ['LUA_PATH']};{os.path.dirname(lua_file)}\\?.lua"

print(args)
if not args.emu_only:
    server_start_command = ["python3", os.path.join(os.environ["PSH_ROOT"], "\\src\\PythonServer\\server.py"), args.host, str(args.port)]
    print(server_start_command)
    server_p = subprocess.Popen(server_start_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    time.sleep(1)

if args.emu_only:
    port_arg = ""
    ip_arg = ""
else:
    port_arg = "--socket_port={args.port}"
    ip_arg = "--socket_ip={args.host}"

lua_files = []
test_lua_files = []

for dirpaths, _, filenames in os.walk(SRC_DIR):
    for filename in filter(lambda x: x.endswith(".lua"), filenames):
        path = os.path.join(dirpaths, filename)
        dest = os.path.join(SHORTCUTS_DIR, filename)
        #Temporarily copy all files into the Shortcuts directory to make it easy to load a lua session
        # shutil.copy(path, dest)
        try:
            os.symlink(path, dest)
        except:
            pass

        lua_files.append(path)
        test_lua_files.append(path)
        # lua_args.append(f"--lua={path}")

for dirpaths, _, filenames in os.walk(TEST_DIR):
    for filename in filter(lambda x: x.endswith(".lua"), filenames):
        path = os.path.join(dirpaths, filename)
        test_lua_files.append(path)

update_lua_path(lua_files)
create_luases(lua_files, os.path.join(SHORTCUTS_DIR, "session.luases"))
create_luases(test_lua_files, os.path.join(SHORTCUTS_DIR, "test_session.luases"))

# lua_args = ["--lua=C:\\Users\\etds2\\Programming\\PokemonLua\\src\\Positioning\\Positioning.lua,C:\\Users\\etds2\\Programming\\PokemonLua\\src\\Memory\\Memory.lua"]       
if args.bot_ids:
    for bot_id in args.bot_ids:
        emulator_start_command = [
                                  args.emulator, 
                                  ip_arg, 
                                  port_arg,
                                  f"--load-state={bot_id_save_states[bot_id]}",
                                  args.game]
        print(emulator_start_command)
        emulator_p = subprocess.Popen(emulator_start_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

else:
    emulator_start_command = [
                                args.emulator, 
                                ip_arg, 
                                port_arg,
                                args.game]
    print(emulator_start_command)
    emulator_p = subprocess.Popen(emulator_start_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

if not args.emu_only:
    for line in iter(server_p.stdout.readline, ''):
        print(line)
    server_p.stdout.close()