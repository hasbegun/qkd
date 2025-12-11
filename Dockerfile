# QKD - Quantum Key Distribution Simulator
# Based on Python with Cirq

FROM python:3.11-slim

LABEL maintainer="qkd-project"
LABEL description="BB84 Quantum Key Distribution simulator using Cirq"

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy project files
COPY pyproject.toml .
COPY src/ src/
COPY tests/ tests/
COPY demo.py .
COPY docs/ docs/

# Install Python dependencies
RUN pip install --no-cache-dir -e ".[dev]"

# Default command: run the demo
CMD ["python", "demo.py"]
