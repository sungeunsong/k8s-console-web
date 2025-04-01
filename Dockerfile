# Node.js 기반 경량 이미지
FROM node:18-alpine

# 필수 도구 설치 (Helm 설치용)
RUN apk add --no-cache curl tar gzip

# Helm 설치 (공식 바이너리 직접 설치 방식 – 가장 안정적)
RUN curl -LO https://get.helm.sh/helm-v3.13.3-linux-amd64.tar.gz \
 && tar -zxvf helm-v3.13.3-linux-amd64.tar.gz \
 && mv linux-amd64/helm /usr/local/bin/helm \
 && chmod +x /usr/local/bin/helm \
 && rm -rf helm-v3.13.3-linux-amd64.tar.gz linux-amd64

# 앱 디렉토리 설정
WORKDIR /app

# 의존성 설치
COPY package*.json ./
RUN npm install

# 앱 소스 및 Helm Chart 복사
COPY . .       
COPY helm-charts/ ./helm-charts/

# Express 포트 (기본 3000)
EXPOSE 3000

# 앱 실행
CMD ["npm", "start"]
