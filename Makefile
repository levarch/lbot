
TAG=$(shell git describe --tags --abbrev=0)
SHA=$(shell git rev-parse --short HEAD)

TARGET_OS=$(shell uname | tr "[:upper:]" "[:lower:]")
TARGET_ARCH=$(shell uname -m)

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

build: format
	if [ -z $(shell git describe --tags --abbrev=0) ]; then echo "No tags in the repo!" && exit 1; fi
	CGO_ENABLED=0 GOOS=${TARGET_OS} GOARCH=${TARGET_ARCH} go build -v -ldflags "-X="github.com/levarch/lbot/cmd.appVersion=${TAG}-${SHA}

clean:
	rm -rf lbot