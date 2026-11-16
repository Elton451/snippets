# Build Stage
FROM golang:1.27.3 AS build
WORKDIR /usr/local/app

# Copy our app deps
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 go build -o /out/web ./cmd/web

# Runtime Stage
FROM alpine:3.24
COPY --from=build /out/web /web
EXPOSE 8080
RUN addgroup -g 1000 appgroup && adduser -u 1000 -G appgroup -s /bin/sh -D appuser
USER appuser:appgroup
ENTRYPOINT ["/web"]
