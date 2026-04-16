# Use a slim, modern Python base image to support newer syntax and libraries
FROM python:3.11-slim-bullseye

# Set environment defaults
ENV TAILSCALE_HOSTNAME="Render-server-by-surya"
ENV TAILSCALE_ADDITIONAL_ARGS=""
# Prevent Python from writing .pyc files and buffer stdout/stderr for Render logs
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install required system tools and build dependencies
# Added git and build-essential, which are often required to compile Python dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    nano \
    procps \
    tmux \
    neofetch \
    ca-certificates \
    curl \
    wget \
    git \
    jq \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Tailscale
RUN curl -fsSL https://tailscale.com/install.sh | sh

# Create necessary directories for Tailscale to function properly
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale /tmp

# Set the working directory for your project
WORKDIR /app

# (Optional) Pre-install Python dependencies for faster Render build times
# COPY requirements.txt /app/
# RUN pip3 install --no-cache-dir -r requirements.txt

# Copy your start script and make it executable
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Copy the rest of your repository into the container
# COPY . /app/

CMD ["./start.sh"]
