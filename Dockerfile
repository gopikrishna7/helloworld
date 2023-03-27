FROM node:12-slim As builder

WORKDIR /app

COPY package.json package.json

RUN npm install

COPY . .

FROM gcr.io/distroless/nodejs:10
COPY --from=builder /app /app
WORKDIR /app
CMD [ "index.js" ]

