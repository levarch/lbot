export DOCKER_CLI_HINTS=false

# GOOS and GOARCH variables for build
TARGET_OS=$(shell uname | tr "[:upper:]" "[:lower:]")
TARGET_ARCH=$(shell if [[ $(uname -m) -ne "aarch64" ]]; then uname -m; else echo "arm64"; fi)

# folders
BIN_FOLDER=out
USER_NAME=levpa
APP_PATH=$(USER_NAME)/golang_web_server

# VERSION variable constructed from last tag name and short commit SHA
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)

# docker tag constructed from version, architecture and operating system
DOCKER_TAG=$(VERSION)-$(TARGET_ARCH)-$(TARGET_OS)

.SILENT:
check:
	echo "\n GOOS: $(TARGET_OS)  \n GOARCH: $(TARGET_ARCH) \n VERSION: $(VERSION) \n"

format:
	gofmt -s -w ./

lint:
	golangci-lint run

test: format lint
	go test -v

build: check
	go get
	CGO_ENABLED=0 \
	GOOS=$(TARGET_OS) \
	GOARCH=$(TARGET_ARCH) \
	go build -v -o $(BIN_FOLDER)/lbot \
    -ldflags "-X="github.com/levarch/lbot/cmd.appVersion=$(VERSION)

	echo "Binary size, time, name:"
	ls -lh ./$(BIN_FOLDER) | grep lbot | awk {'print $$5,$$8,$$9'} && echo

image: check
	docker build -t $(APP_PATH):$(DOCKER_TAG) -q .
	docker scout quickview $(APP_PATH):$(DOCKER_TAG)
	# docker scout cves $(APP_PATH):$(DOCKER_TAG)

push: check
	echo $(DOCKER_PASS) | docker login --username $(USER_NAME) --password-stdin
	docker push $(APP_PATH):$(DOCKER_TAG)

clean:
	docker images | grep $(APP_PATH) | awk '{print $$3}' | xargs docker rmi || :
	rm -rf -v ./$(BIN_FOLDER)
