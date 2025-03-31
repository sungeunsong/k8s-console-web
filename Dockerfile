FROM node:18-alpine

RUN apk add --no-cache curl tar gzip

# Helm 설치 (스크립트 우회 – 직접 바이너리 설치)
RUN curl -LO https://get.helm.sh/helm-v3.13.3-linux-amd64.tar.gz \
 && tar -zxvf helm-v3.13.3-linux-amd64.tar.gz \
 && mv linux-amd64/helm /usr/local/bin/helm \
 && chmod +x /usr/local/bin/helm \
 && rm -rf helm-v3.13.3-linux-amd64.tar.gz linux-amd64

WORKDIR /app
COPY package*.json ./
RUN npm ci

COPY . .
EXPOSE 3000

CMD ["npm", "start"]
