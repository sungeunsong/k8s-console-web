FROM node:18-alpine

# 필요한 도구 설치
RUN apk add --no-cache curl bash tar gzip

# Helm 설치 (스크립트 직접 다운로드 후 실행)
RUN curl -LO https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
 && chmod +x get-helm-3 \
 && ./get-helm-3

WORKDIR /app
COPY package*.json ./
RUN npm ci

COPY . .
EXPOSE 3000

CMD ["npm", "start"]
