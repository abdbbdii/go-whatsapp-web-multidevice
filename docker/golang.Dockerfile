############################
# STEP 1 build executable binary
############################
FROM golang:1.21.5-alpine3.19 AS builder
RUN apk update && apk add --no-cache gcc musl-dev gcompat
WORKDIR /whatsapp
COPY ./src .

# Fetch dependencies.
RUN go mod download
# Build the binary.
RUN go build -o /app/whatsapp

#############################
## STEP 2 build a smaller image
#############################
FROM alpine:3.19
RUN apk update && apk add --no-cache ffmpeg
WORKDIR /app
# Copy compiled from builder.
COPY --from=builder /app/whatsapp /app/whatsapp
# Copy the .env file
COPY .env ./.env
# Run the binary.
ENTRYPOINT ["/app/whatsapp"]