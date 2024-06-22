# Use the official Python image from the Docker Hub
FROM python:3.9-slim

# Install ping
RUN apt-get update && apt-get install -y iputils-ping

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the requirements file into the container
COPY requirements.txt .

# Install the Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the FastAPI application into the container
COPY client.py .

# Expose the port that FastAPI will run on
EXPOSE 2020

# Command to run the FastAPI application
CMD ["uvicorn", "client:app", "--host", "0.0.0.0", "--port", "2020"]
