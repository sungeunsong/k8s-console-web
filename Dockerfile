FROM node:18-alpine

RUN apk add --no-cache curl bash tar gzip
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
