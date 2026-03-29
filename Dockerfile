# ---------- Stage 1: Build ----------
FROM node:20-alpine3.20 AS builder

WORKDIR /app

COPY app/package*.json ./
RUN npm ci

COPY app/ .

# ---------- Stage 2: Production ----------
FROM node:20-alpine3.20

WORKDIR /app

RUN apk update && apk upgrade

COPY --from=builder /app /app

RUN addgroup -S app && adduser -S app -G app
USER app

EXPOSE 3000

CMD ["node", "server.js"]
