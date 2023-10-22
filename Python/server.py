import pprint
import event_handler
import json
import re
import socket
import signal
import argparse

HOST = "127.0.0.1"  # Standard loopback interface address (localhost)
PORT = 57373  # Port to listen on (non-privileged ports are > 1023)


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
            stripped_data = re.sub("^[\d]+ ", "" , data.decode("utf-8"))
            event_json = json.loads(stripped_data)
            event_handler.handle_event(event_json)

            if not data:
                break
