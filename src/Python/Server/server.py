import pprint
import event_handler
import json
import logging
import re
import select
import socket
import signal
import argparse

BUF_SIZE = 1024

parser = argparse.ArgumentParser()

parser.add_argument("host", type=str, help="Enter host IP (usually 127.0.0.1)")
parser.add_argument("port", type=int, help='Port number for server')

args = parser.parse_args()
HOST = args.host  # Standard loopback interface address (localhost)
PORT = args.port  # Port to listen on (non-privileged ports are > 1023)

print(HOST, PORT)

def close_script(s):
    logging.info("No more connections are established, terminating server")
    s.close()
    exit()

event_handler = event_handler.EventHandler()

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as server:
    server.setblocking(0)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server.bind((HOST, PORT))
    server.listen()
    inputs = [server]

    logging.basicConfig(level=logging.DEBUG)
    while inputs:
        readable, _, _ = select.select(inputs, [], [])

        for s in readable:
            if s == server: # Accept a new connection coming in
                conn, addr = s.accept()
                logging.info(f"Accepted new connection from: {addr}")
                conn.setblocking(0)
                inputs.append(conn)
            else: # Read data from one of the connected sockets
                try:
                    chunks = []
                    while True:
                        chunk = s.recv(BUF_SIZE)
                        chunks.append(chunk)
                        if len(chunk) < BUF_SIZE:
                            break
                    data = b''.join(chunks)
                except ConnectionResetError as e:
                    logging.error("Lost connection to client")
                    logging.error(e)
                    inputs.remove(s)
                    if len(inputs) == 1:
                        close_script(server)
                    continue
     
                if data:
                    data_str = data.decode("utf-8")
                    try:
                        messages = data_str.split("|||")
                        for message in messages:
                            if not message:
                                continue
                            # Clean up the received data and send over to the event handler
                            stripped_data = re.sub("^[\d]+ ", "" , message)
                            event_json = json.loads(stripped_data)
                    except json.JSONDecodeError:
                        logging.error(f"Unable to parse data: {data_str}")
                    
                    event_handler.handle_event(event_json)
                else:
                    logging.info(f"Removing socket {s.fileno()}")
                    inputs.remove(s)
                    if len(inputs) == 1:
                        close_script(server)

