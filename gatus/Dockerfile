# Build stage
FROM golang:1.26 AS builder

# Set working directory
WORKDIR /app

# Copy in dependencies
COPY go.mod go.sum ./

# Install dependencies
RUN go mod download

# Copies the rest of the code into the container
COPY . .

# Builds the app
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -o gatus .

# Runtime stage
FROM gcr.io/distroless/static-debian12

WORKDIR /app

COPY --from=builder /app ./

# Runs the container with a non root user
USER nonroot:nonroot

EXPOSE 8080

CMD ["./gatus"]

#test3
