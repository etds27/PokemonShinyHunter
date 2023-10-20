import socket
import signal

HOST = "127.0.0.1"  # Standard loopback interface address (localhost)
PORT = 57373  # Port to listen on (non-privileged ports are > 1023)


def close_script(s):
    print("Terminating server")
    s.close()
    exit()


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
            print(f"Received data {data}")
            if not data:
                break
            message = f"{len(data)} {data}"
            print(message)
            conn.send(message.encode())

            print(data)
