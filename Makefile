TAG=$(shell git describe --tags --abbrev=0 2> /dev/null)
SHA=$(shell git rev-parse --short HEAD)

TARGET_OS=$(shell uname | tr "[:upper:]" "[:lower:]")
TARGET_ARCH=$(shell if [[ $(uname -m) -ne "aarch64" ]]; then uname -m; else echo "arm64"; fi)

REGISTRY=levpa
APP=golang_web_server

check:
	@if [ -z $(TAG) ]; then echo "No tags in the repo!" && exit 1; fi

format:
	gofmt -s -w ./

lint:
	go lint

test:
	go test -v

build: check format
	go get
	CGO_ENABLED=0 GOOS=${TARGET_OS} GOARCH=${TARGET_ARCH} go build -v -o lbot -ldflags "-X="github.com/levarch/lbot/cmd.appVersion=${TAG}-${SHA}

image: check
	docker build . -t ${REGISTRY}/${APP}:${TAG}-${SHA}-${TARGET_ARCH}

push: check
	docker push ${REGISTRY}/${APP}:${TAG}-${SHA}-${TARGET_ARCH}

clean:
	docker image rm ${REGISTRY}/${APP}:${TAG}-${SHA}-${TARGET_ARCH}
	rm -rf ./lbot