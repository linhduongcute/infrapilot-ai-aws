# Use an official Python runtime as a parent image
FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /app

# Install poetry
RUN pip install poetry

# Copy only the dependency files to leverage Docker cache
COPY poetry.lock pyproject.toml /app/

# Install project dependencies (ĐÃ SỬA)
# Bỏ "--without dev" vì project của bạn không có group dev
RUN poetry config virtualenvs.create false && poetry install --no-root

# Copy the rest of the application's source code from your host to your image filesystem.
COPY ./ai_infra_agent /app/ai_infra_agent
COPY ./config.yaml /app/config.yaml
COPY ./settings /app/settings

# Inform Docker that the container is listening on port 80
EXPOSE 80

# Define the command to run your app using uvicorn
CMD ["uvicorn", "ai_infra_agent.main:app", "--host", "0.0.0.0", "--port", "80"]