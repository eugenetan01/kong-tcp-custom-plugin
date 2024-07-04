import socket
import logging


logging.basicConfig(level=logging.DEBUG)

def send_tcp_request(host='localhost', port=65432, message='Hello\nWorld\n'):
    logging.debug(f"Attempting to connect to {host}:{port}")
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.connect((host, port))
            logging.debug(f"Connected to {host}:{port}")
            s.sendall(message.encode())
            logging.debug(f"Sent message: {message}")
            data = s.recv(1024)
            logging.debug(f"Received response: {data.decode()}")
            return data.decode()
    except Exception as e:
        logging.exception("Exception occurred while sending TCP request")
        raise Exception(f"Error sending TCP request: {e}")

if __name__ == "__main__":
    host = "localhost"
    port = 9000
    message = "hello, world! -agentzh\r\n"
    try:
        response = send_tcp_request(host=host, port=port, message=message)
        print(f"Response: {response}")
    except Exception as e:
        print(f"Failed to send TCP request: {e}")
