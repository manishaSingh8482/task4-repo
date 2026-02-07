#!/bin/bash
set -eux

# Force IPv4 for apt (CRITICAL FIX)
echo 'Acquire::ForceIPv4 "true";' > /etc/apt/apt.conf.d/99force-ipv4

# Update package lists
apt-get update -y

# Install required packages
apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release

# Install Docker (Ubuntu-supported method)
apt-get install -y docker.io

systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu

# Install SSM agent (safe if already present)
snap install amazon-ssm-agent --classic || true
systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent
systemctl start snap.amazon-ssm-agent.amazon-ssm-agent

# Docker network & volumes
docker network create strapi-net || true
docker volume create strapi-db || true
docker volume create strapi-app || true

# PostgreSQL
docker run -d \
  --name postgres \
  --network strapi-net \
  -v strapi-db:/var/lib/postgresql/data \
  -e POSTGRES_DB=strapi \
  -e POSTGRES_USER=strapi \
  -e POSTGRES_PASSWORD=StrapiPass123 \
  --restart unless-stopped \
  postgres:14

# Strapi
docker run -d \
  --name strapi \
  --network strapi-net \
  -p 1337:1337 \
  -v strapi-app:/srv/app \
  -e NODE_ENV=production \
  -e DATABASE_CLIENT=postgres \
  -e DATABASE_HOST=postgres \
  -e DATABASE_PORT=5432 \
  -e DATABASE_NAME=strapi \
  -e DATABASE_USERNAME=strapi \
  -e DATABASE_PASSWORD=StrapiPass123 \
  -e APP_KEYS=key1,key2 \
  -e JWT_SECRET=jwtsecret \
  -e ADMIN_JWT_SECRET=adminjwtsecret \
  --restart unless-stopped \
  strapi/strapi:4.15.0
