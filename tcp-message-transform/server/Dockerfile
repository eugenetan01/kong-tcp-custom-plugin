# Use the official Python image from the Docker Hub
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the Python script into the container
COPY server.py .

# Expose the port that the server will run on
EXPOSE 65432

# Command to run the Python script
CMD ["python", "./server.py"]
