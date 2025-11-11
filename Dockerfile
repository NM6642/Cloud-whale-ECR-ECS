# Use official Python image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy dependencies first
COPY requirements.txt .

# Install Python dependencies inside container
RUN python -m pip install --no-cache-dir -r requirements.txt

# Copy the app code
COPY . .

# Expose the container port
EXPOSE 5000

# Run the Flask app
CMD ["python", "app.py"]
