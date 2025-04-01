FROM node:18-alpine

# 필요한 도구 설치
RUN apk add --no-cache curl tar gzip

# Helm 설치 (스크립트 대신 직접 바이너리 다운로드)
RUN curl -LO https://get.helm.sh/helm-v3.13.3-linux-amd64.tar.gz \
 && tar -zxvf helm-v3.13.3-linux-amd64.tar.gz \
 && mv linux-amd64/helm /usr/local/bin/helm \
 && chmod +x /usr/local/bin/helm \
 && rm -rf helm-v3.13.3-linux-amd64.tar.gz linux-amd64

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
COPY helm-charts/ ./helm-charts/        # Chart 디렉토리 복사 (명시적으로 추가)

EXPOSE 3000

CMD ["npm", "start"]
