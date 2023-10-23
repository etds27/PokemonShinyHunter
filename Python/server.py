import pprint
import event_handler
import json
import logging
import re
import select
import socket
import signal
import argparse

parser = argparse.ArgumentParser()

parser.add_argument("host", type=str, help="Enter host IP (usually 127.0.0.1)")
parser.add_argument("port", type=int, help='Port number for server')

args = parser.parse_args()
HOST = args.host  # Standard loopback interface address (localhost)
PORT = args.port  # Port to listen on (non-privileged ports are > 1023)


def close_script(s):
    print("Terminating server")
    s.close()
    exit()

event_handler = event_handler.EventHandler()

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind((HOST, PORT))
    s.listen()
    print(f"Waiting for client")
    conn, addr = s.accept()
    print(f"Client accepted: {conn}:{addr}")

    with conn:
        print(f"Connected by {addr}")
        while True:
            data = conn.recv(1024)

            data_str = data.decode("utf-8")
            try:
                stripped_data = re.sub("^[\d]+ ", "" , data.decode("utf-8"))
                event_json = json.loads(stripped_data)
                event_handler.handle_event(event_json)
            except:
                logging.error(f"Unable to parse data: {data_str}")

            if not data:
                break
