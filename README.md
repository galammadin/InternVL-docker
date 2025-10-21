# InternVL Deployment with LMDeploy

This Docker setup deploys InternVL using lmdeploy for serving the model via API.

## Prerequisites

- Docker
- Docker Compose
- NVIDIA GPU with CUDA support
- NVIDIA Container Toolkit
- HuggingFace account with access to the model
- HuggingFace access token

## Setup

### 1. Get HuggingFace Token

1. Go to https://huggingface.co/settings/tokens
2. Create a new token with read permissions
3. Make sure you have access to the private model `issai/InternVL3_5-4B-stage3-v8`
4. Request access to the model repository if you haven't already

### 2. Configure Environment

Create a `.env` file from the example:

```bash
cp .env.example .env
```

Edit `.env` and add your HuggingFace token:

```
HF_TOKEN=hf_your_actual_token_here
```

**IMPORTANT**: Never commit your `.env` file with the actual token!

## Quick Start

### Build and Run with Docker Compose

```bash
docker-compose up -d
```

### Build and Run with Docker

```bash
# Build the image
docker build -t internvl-lmdeploy .

# Run the container (replace YOUR_HF_TOKEN with your actual token)
docker run -d \
  --name internvl-lmdeploy \
  --gpus all \
  -p 23333:23333 \
  --shm-size 8g \
  -e HF_TOKEN=YOUR_HF_TOKEN \
  -v huggingface-cache:/root/.cache/huggingface \
  internvl-lmdeploy
```

## Configuration

You can customize the deployment by modifying environment variables in [docker-compose.yml](docker-compose.yml):

- `MODEL_NAME`: The HuggingFace model to deploy (default: `issai/InternVL3_5-4B-stage3-v8`)
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
    "model": "issai/InternVL3_5-4B-stage3-v8",
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
docker logs -f internvl-lmdeploy
```

## Stop and Remove

```bash
docker-compose down
```

Or with Docker:

```bash
docker stop internvl-lmdeploy
docker rm internvl-lmdeploy
```

## Security Notes

- **Never commit your `.env` file** with the actual HuggingFace token
- The `.env` file is already in `.dockerignore` and should be in `.gitignore`
- You can also pass the token via command line, but environment files are safer

## Troubleshooting

### Authentication Errors

If you get authentication errors:
1. Verify your HuggingFace token is correct
2. Ensure you have access to the model `issai/InternVL3_5-4B-stage3-v8`
3. Check that the token has read permissions

### Model Download Issues

- The first run will download the model from HuggingFace, which may take some time
- Model files are cached in a Docker volume to avoid re-downloading
- Ensure you have sufficient disk space for the model

## Notes

- Adjust `shm_size` if you encounter shared memory errors
- Ensure your GPU has sufficient VRAM for the model
- The container will automatically login to HuggingFace if `HF_TOKEN` is provided
