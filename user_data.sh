#!/bin/bash
set -e

# Update system
apt update -y

# Install SSM Agent (force install to be safe)
snap install amazon-ssm-agent --classic || true

systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent
systemctl start snap.amazon-ssm-agent.amazon-ssm-agent

# Install Docker
apt install -y docker.io

systemctl start docker
systemctl enable docker

# Create Docker network
docker network create strapi-net || true

# Create volumes
docker volume create strapi-db
docker volume create strapi-app

# Run PostgreSQL
docker run -d \
  --name postgres \
  --network strapi-net \
  -v strapi-db:/var/lib/postgresql/data \
  -e POSTGRES_DB=strapi \
  -e POSTGRES_USER=strapi \
  -e POSTGRES_PASSWORD=StrapiPass123 \
  --restart unless-stopped \
  postgres:14

# Run Strapi (PINNED VERSION)
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
