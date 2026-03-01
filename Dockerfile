FROM golang:1.25-alpine AS builder
RUN apk add --no-cache git
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64
RUN go build -ldflags="-s -w" -o /app/kiamagpie .
FROM scratch
COPY --from=builder /app/kiamagpie /kiamagpie
EXPOSE 80-9999
EXPOSE 80-9999/udp
ENTRYPOINT ["/kiamagpie"]
