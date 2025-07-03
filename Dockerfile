# Use an official, stable Python runtime as a parent image.
# python:3.11-slim is a good choice for a balance of size and compatibility.
FROM python:3.11-slim-bullseye

# Set the working directory in the container to /app
WORKDIR /app

# Copy the dependencies file to the working directory.
# This is done as a separate step to leverage Docker's layer caching.
# If requirements.txt doesn't change, this layer won't need to be rebuilt on subsequent builds.
COPY requirements.txt .

# Install any needed packages specified in requirements.txt.
# --no-cache-dir reduces image size.
# --upgrade pip ensures we have the latest version of the package installer.
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application's code into the container at /app
COPY . .

# Make port 8000 available to the world outside this container
EXPOSE 8000

# Define the command to run the application.
# We use "0.0.0.0" to make the application accessible from outside the container.
# The --reload flag is removed as it's not recommended for production.
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
