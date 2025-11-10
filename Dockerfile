FROM nvidia/cuda:12.4.0-devel-ubuntu22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV CUDA_HOME=/usr/local/cuda

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    git \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip3 install --no-cache-dir --upgrade pip

# Install PyTorch with CUDA support
RUN pip3 install --no-cache-dir \
    torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Install lmdeploy
RUN pip3 install --no-cache-dir lmdeploy

# Create working directory
WORKDIR /app

# Expose the server port
EXPOSE 23333

# Set the model name as an environment variable (can be overridden)
ENV MODEL_NAME=issai/Qolda
ENV SERVER_PORT=23333
ENV BACKEND=pytorch
ENV TP=1
ENV SESSION_LEN=32768

# Create startup script
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
# Run lmdeploy serve api_server\n\
exec lmdeploy serve api_server ${MODEL_NAME} \\\n\
    --server-port ${SERVER_PORT} \\\n\
    --backend ${BACKEND} \\\n\
    --tp ${TP} \\\n\
    --session-len ${SESSION_LEN}\n\
' > /app/start.sh && chmod +x /app/start.sh

# Run the startup script
CMD ["/app/start.sh"]
