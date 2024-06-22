# Use the official Python image from the Docker Hub
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the requirements file into the container
COPY requirements.txt .

# Install the Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the FastAPI application into the container
COPY logapp.py .

# Expose the port that FastAPI will run on
EXPOSE 2011

# Command to run the FastAPI application
CMD ["uvicorn", "logapp:app", "--host", "0.0.0.0", "--port", "2011"]
