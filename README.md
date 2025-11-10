# Qolda Deployment with LMDeploy

This Docker setup deploys Qolda, an open-source vision-language model, using lmdeploy for serving the model via API.

## Prerequisites

- Docker
- Docker Compose
- NVIDIA GPU with CUDA support
- NVIDIA Container Toolkit

## Quick Start

The Qolda model is open source and publicly available. No authentication or setup required!

### Build and Run with Docker Compose

```bash
docker-compose up -d
```

### Build and Run with Docker

```bash
# Build the image
docker build -t qolda-lmdeploy .

# Run the container
docker run -d \
  --name qolda-lmdeploy \
  --gpus all \
  -p 23333:23333 \
  --shm-size 8g \
  -v huggingface-cache:/root/.cache/huggingface \
  qolda-lmdeploy
```

## Configuration

You can customize the deployment by modifying environment variables in [docker-compose.yml](docker-compose.yml):

- `MODEL_NAME`: The HuggingFace model to deploy (default: `issai/Qolda`)
- `SERVER_PORT`: API server port (default: `23333`)
- `BACKEND`: Inference backend (default: `pytorch`)
- `TP`: Tensor parallelism degree (default: `1`)
- `SESSION_LEN`: Maximum session length (default: `32768`)

## Usage

Once the container is running, you can access the API at `http://localhost:23333`.

### Example API Request

```bash
curl http://localhost:23333/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "issai/Qolda",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

## Logs

View container logs:

```bash
docker-compose logs -f
```

Or with Docker:

```bash
docker logs -f qolda-lmdeploy
```

## Stop and Remove

```bash
docker-compose down
```

Or with Docker:

```bash
docker stop qolda-lmdeploy
docker rm qolda-lmdeploy
```

## Troubleshooting

### Model Download Issues

- The first run will download the Qolda model from HuggingFace (no authentication required)
- This may take some time depending on your internet connection
- Model files are cached in a Docker volume to avoid re-downloading
- Ensure you have sufficient disk space for the model (~8GB)

### GPU Errors

- Ensure NVIDIA drivers are properly installed
- Verify NVIDIA Container Toolkit is configured correctly
- Check GPU availability with: `docker run --rm --gpus all nvidia/cuda:12.4.0-base-ubuntu22.04 nvidia-smi`

## Notes

- Adjust `shm_size` if you encounter shared memory errors
- Ensure your GPU has sufficient VRAM for the model (minimum 8GB recommended)
- Qolda is fully open source and can be freely used and modified

## About Qolda

Qolda is an open-source vision-language model fine-tuned for multimodal understanding. The model is available on HuggingFace at [issai/Qolda](https://huggingface.co/issai/Qolda).
