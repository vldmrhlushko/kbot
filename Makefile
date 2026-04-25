.PHONY: build linux windows macos format lint test clean
APP=$(shell basename $(shell git remote get-url origin ))
REGISTRY=ghcr.io/vldmrhlushko
#VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
VERSION ?= $(shell git describe --tags --always 2>/dev/null || git rev-parse --short HEAD)

PKG=github.com/vldmrhlushko/kbot/cmd

# default
TARGETOS?=linux
TARGETARCH?=amd64


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


#build: format get
#	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/vldmrhlushko/kbot/cmd.appVersion=${VERSION}


# Platforms

linux:
	$(MAKE) build TARGETOS=linux TARGETARCH=amd64

linux-arm:
	$(MAKE) build TARGETOS=linux TARGETARCH=arm64

windows:
	$(MAKE) build TARGETOS=windows TARGETARCH=amd64

macos:
	$(MAKE) build TARGETOS=darwin TARGETARCH=amd64

macos-arm:
	$(MAKE) build TARGETOS=darwin TARGETARCH=arm64

image:
	docker build \
		--build-arg TARGETOS=$(TARGETOS) \
		--build-arg TARGETARCH=$(TARGETARCH) \
		--build-arg VERSION=$(VERSION) \
		-t $(REGISTRY)/$(APP):$(VERSION)-$(TARGETOS)-$(TARGETARCH) \
		.

push:
	docker push $(REGISTRY)/$(APP):$(VERSION)-$(TARGETOS)-$(TARGETARCH)


clean:
	rm -rf build
	docker rmi $(REGISTRY)/$(APP):$(VERSION)-$(TARGETOS)-$(TARGETARCH)
