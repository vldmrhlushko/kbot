FROM quay.io/projectquay/golang:1.22 AS builder

WORKDIR /app
COPY . .

ARG TARGETOS=linux
ARG TARGETARCH=amd64
ARG VERSION

RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH \
    go build -v -o kbot \
    -ldflags "-X=github.com/vldmrhlushko/kbot/cmd.appVersion=$VERSION"

FROM alpine:latest

WORKDIR /
COPY --from=builder /app/kbot /kbot
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

ENTRYPOINT ["/kbot"]