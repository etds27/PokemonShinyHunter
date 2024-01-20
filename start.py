import argparse
import logging
import os
import subprocess
import sys
import time
import threading

logging.basicConfig(level=logging.DEBUG)

bot_id_save_states = {
    "CHRIS51032": "BotStates\\CHRIS51032\\StartUp.State",
    "ETHAN25996": "BotStates\\ETHAN25996\\StartUp.State"
}

os.environ["LUA_PATH"] = ""
# os.environ["PSH_ROOT"] = "C:\\Users\\etds2\\Programming\\PokemonLua"
# Sets the root environment to be the directory of this script
# Therefore this script should always be at the top level of the project
os.environ["PSH_ROOT"] = os.path.dirname(os.path.abspath(__file__))
os.environ["PSH_GAME_DATA_ROOT"] = os.path.join(os.environ["PSH_ROOT"], "GameData")

ROOT_DIR = os.environ["PSH_ROOT"]
SRC_DIR = os.path.join(ROOT_DIR, "src")
TEST_DIR = os.path.join(ROOT_DIR, "Tests")
SHORTCUTS_DIR = os.path.join(ROOT_DIR, "Shortcuts")
DASHBOARD_DIR = os.path.join(SRC_DIR, "Dashboard")

os.environ["PSH_DASHBOARD_DIR"] = DASHBOARD_DIR
os.environ["PSH_SHORTCUTS_DIR"] = SHORTCUTS_DIR

parser = argparse.ArgumentParser()
parser.add_argument("--emu-only", action="store_true", help="Start only the emu while connecting it to an already running server")
parser.add_argument("-n", "--no-server", action="store_true", help="Start only the emu without the intention of connecting to a server")
parser.add_argument("-s", "--server-only", action="store_true")
parser.add_argument("--env-only", action="store_true")
parser.add_argument("-p", "--port", nargs=1, default=8000, type=int)
parser.add_argument("--host", nargs=1, default="127.0.0.1", type=str)
parser.add_argument("-g", "--game", default="C:\Emulators\GBC\Pokemon Crystal.gbc", type=str)
parser.add_argument("-e", "--emulator", nargs=1, default="C:\Emulators\Bizhawk\EmuHawk.exe", type=str)
parser.add_argument("--bot-ids", nargs="+")
args = parser.parse_args()

logging.debug(f"start.py args {args}")
def create_luases(lua_files, path, auto_start: [str] = []):
    print(f"Creating .luases for {path}")
    with open(path, "w") as f:
        [f.write(f"{1 if os.path.basename(lua_file) in auto_start else 0} {lua_file}\n")
                        for lua_file in lua_files]

def update_lua_path(lua_files):     
    for lua_file in lua_files:
        os.environ["LUA_PATH"] = f"{os.environ['LUA_PATH']};{os.path.dirname(lua_file)}\\?.lua"

# Omit the emu url argument if we are running in no server modde 
if args.no_server:    
    logging.info("Not connecting emu to server")
    url_post_arg = ""
else:
    url = f"http://{args.host}:{args.port}"
    logging.info(f"Setting emu url to {url}")
    url_post_arg = f"--url_post={url}"

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

update_lua_path([SRC_DIR] + lua_files)

if args.env_only:
    for key, value in os.environ.items():
        print(f"{key}: {value}")
    exit()

create_luases(lua_files, os.path.join(ROOT_DIR, "session.luases"))
create_luases(test_lua_files, os.path.join(ROOT_DIR, "test_session.luases"))
create_luases(lua_files, os.path.join(ROOT_DIR, "main_session.luases"), auto_start=["Main.lua"])

def run_server(event: threading.Event):
    # Start up the server if we are not running in emu only mode or in no server mode
    if not args.emu_only and not args.no_server:
        server_start_command = [sys.executable, os.path.join(os.environ["PSH_ROOT"], "src", "Python", "Server", "server.py"), args.host, str(args.port)]
        logging.info(f"Server start command: {server_start_command}")
        server_p = subprocess.Popen(server_start_command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, bufsize=1, universal_newlines=True)
        time.sleep(1)

    # Notify that the HTTP server has started
    event.set()
    if not args.emu_only and not args.no_server:
        for line in iter(server_p.stdout.readline, ""):
            sys.stdout.write(line)
            sys.stdout.flush()

def run_emulator(event: threading.Event, timeout: int = 10):
    logging.debug("Waiting for HTTP server to start")
    if not event.wait(timeout):
        logging.error("Timed out waiting for HTTP server to start")
        exit(1)

    if args.bot_ids and not args.server_only:
        for bot_id in args.bot_ids:
            emulator_start_command = [
                                    args.emulator, 
                                    url_post_arg,
                                    f"--load-state={bot_id_save_states[bot_id]}",
                                    args.game]
            print(emulator_start_command)
            emulator_p = subprocess.Popen(emulator_start_command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, bufsize=1, universal_newlines=True)

    elif not args.server_only:
        emulator_start_command = [
                                    args.emulator, 
                                    url_post_arg,
                                    args.game]
        print(emulator_start_command)
        emulator_p = subprocess.Popen(emulator_start_command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, bufsize=1, universal_newlines=True)

    if not args.server_only:
        for line in iter(emulator_p.stdout.readline, ""):
            sys.stdout.write(line)
            sys.stdout.flush()


# The python HTTP server initially starts
# The emulator thread is then immediately started
# The emulator thread is then immediately held until the event is fulfilled
# The event is then set, notifying the emulator thread to start
# The emulator is started
# Wait for both threads to finish
python_server_start_event = threading.Event()
server_thread = threading.Thread(target=run_server, args=[python_server_start_event])
emulator_thread = threading.Thread(target=run_emulator, args=[python_server_start_event])

server_thread.start()
emulator_thread.start()

server_thread.join()
logging.info("Server thread ended")
emulator_thread.join()
logging.info("Emulator thread ended")
logging.info("Script finished")