from fastapi import FastAPI, Header, HTTPException
from pymongo import MongoClient
from pydantic import BaseModel
import os

app = FastAPI()

# MongoDB client setup
MONGO_URL = os.getenv("MONGO_URL")
client = MongoClient(MONGO_URL)
db = client.packet_db
collection = db.packet_counts

class PacketCount(BaseModel):
    packet_count: int

@app.post("/packets")
async def receive_packet_count(packet_count: PacketCount, x_packet_count: int = Header(None)):
    if x_packet_count is None:
        raise HTTPException(status_code=400, detail="X-Packet-Count header missing")
    packet_data = {"packet_count": x_packet_count}
    return {"message": "Packet count received", "packet_count": x_packet_count}
