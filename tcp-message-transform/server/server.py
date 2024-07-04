import socket
import logging

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s', handlers=[logging.StreamHandler()])

def start_server(host='0.0.0.0', port=65432):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind((host, port))
        s.listen()
        logging.info(f'Server started. Listening on {host}:{port}')
        while True:
            conn, addr = s.accept()
            handle_client(conn, addr)

def handle_client(conn, addr):
    logging.info(f'Connected by {addr}')
    with conn:
        while True:
            data = conn.recv(1024)
            if not data:
                break
            logging.info(f'Received message: {data.decode()}')
            conn.sendall(data)  # Echo back the received data

if __name__ == "__main__":
    start_server()
