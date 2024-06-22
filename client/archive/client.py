from fastapi import FastAPI, HTTPException
import socket
import logging

app = FastAPI()

logging.basicConfig(level=logging.DEBUG)

def send_tcp_request(host='localhost', port=65432, message='Hello\nWorld\n!'):
    logging.debug(f"Attempting to connect to {host}:{port}")
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.connect((host, port))
            print(f"Connected to {host}:{port}")
            s.sendall(message.encode())
            print(f"Sent message: {message}")
            data = s.recv(1024)
            print(f"Received response: {data.decode()}")
            return data.decode()
    except Exception as e:
        print("Exception occurred while sending TCP request")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/send-tcp")
def send_tcp(message: str = 'Hello\nWorld\n!'):
    response = send_tcp_request(message=message)
    return {"response": response}
