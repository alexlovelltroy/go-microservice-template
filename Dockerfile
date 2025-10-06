# Build stage
# SPDX-FileCopyrightText: 2025 OpenCHAMI Contributors
#
# SPDX-License-Identifier: MIT

# Build stage
FROM golang:1.25-alpine AS builder

# Install build dependencies and update packages
RUN apk update && apk upgrade && apk add --no-cache git ca-certificates

WORKDIR /app

# Copy go mod files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /app/bin/app .

# Runtime stage
FROM alpine:3.19

# Update and install runtime dependencies
RUN apk update && apk upgrade && apk --no-cache add ca-certificates

WORKDIR /root/

# Copy binary from builder
COPY --from=builder /app/bin/app .

# Expose port (adjust as needed)
EXPOSE 8080

# Run the application
ENTRYPOINT ["./app"]
