TAG=$(shell git describe --tags --abbrev=0 2> /dev/null)
SHA=$(shell git rev-parse --short HEAD)

TARGET_OS=$(shell uname | tr "[:upper:]" "[:lower:]")
TARGET_ARCH=$(shell if [[ $(uname -m) -ne "aarch64" ]]; then uname -m; else echo "arm64"; fi)

REGISTRY=levpa
APP=golang_web_server

.SILENT:
check:
	if [ -z $(TAG) ]; then echo "No tags in the repo!" && exit 1; fi
	echo "\n GOOS: $(TARGET_OS)  GOARCH: $(TARGET_ARCH) \n TAG: $(TAG) SHA: $(SHA) \n"

format:
	gofmt -s -w ./

lint:
	golangci-lint run

test: format lint
	go test -v

build: check format lint
	go get
	CGO_ENABLED=0 GOOS=${TARGET_OS} GOARCH=${TARGET_ARCH} go build -v -o out/lbot -ldflags "-X="github.com/levarch/lbot/cmd.appVersion=${TAG}-${SHA}

image: check
	docker build . -t ${REGISTRY}/${APP}:${TAG}-${SHA}-${TARGET_ARCH} -q
	docker scout quickview ${REGISTRY}/${APP}:${TAG}-${SHA}-${TARGET_ARCH}
	docker scout cves ${REGISTRY}/${APP}:${TAG}-${SHA}-${TARGET_ARCH}

push: check
	echo $(DOCKER_PASS) | docker login --username levpa --password-stdin
	docker push ${REGISTRY}/${APP}:${TAG}-${SHA}-${TARGET_ARCH}

clean:
	docker image rm ${REGISTRY}/${APP} 2> /dev/null || :
	rm -rf ./out
