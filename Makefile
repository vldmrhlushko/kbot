.PHONY: build linux windows macos format lint test clean
APP=$(shell basename $(shell git remote get-url origin ))
REGISTRY=vldmrhlushko
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)

# default
TARGETOS=linux
TARGETARCH=amd64

BINARY_NAME=kbot

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

build:
	@echo "Building for $(TARGETOS)/$(TARGETARCH)"
	CGO_ENABLED=0 GOOS=$(TARGETOS) GOARCH=$(TARGETARCH) \
	go build -v -o build/$(TARGETOS)-$(TARGETARCH)/$(BINARY_NAME) \
	-ldflags "-X=$(PKG).appVersion=$(VERSION)"

# Platforms

linux:
	$(MAKE) build TARGETOS=linux TARGETARCH=amd64

linux-arm:
	$(MAKE) build TARGETOS=linux TARGETARCH=arm64

windows:
	$(MAKE) build TARGETOS=windows TARGETARCH=amd64

macos:
	$(MAKE) build TARGETOS=darwin TARGETARCH=amd64


image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

clean:
	rm -rf kbot