export DOCKER_CLI_HINTS=false

# GOOS and GOARCH variables for build
GOOS=$(shell uname | tr "[:upper:]" "[:lower:]")
GOARCH=$(shell if [[ $(uname -m) -ne "aarch64" ]]; then uname -m; else echo "arm64"; fi)

# folders
BIN_FOLDER=out
USER_NAME=levpa
APP_PATH=$(USER_NAME)/golang_web_server

# VERSION variable constructed from last tag name and short commit SHA
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)

# docker tag constructed from version, architecture and operating system
DOCKER_TAG=$(VERSION)-$(GOARCH)-$(GOOS)

# .SILENT:
check:
	echo "\n GOOS: $(GOOS)  \n GOARCH: $(GOARCH) \n VERSION: $(VERSION)\n"

format:
	gofmt -s -w ./

lint:
	golangci-lint run

test: format lint
	go test -v

build: check
	go get
	CGO_ENABLED=0 \
	GOOS=$(GOOS) \
	GOARCH=$(GOARCH) \
	go build -o $(BIN_FOLDER)/lbot \
    -ldflags "-X="github.com/levarch/lbot/cmd.appVersion=$(VERSION)

	echo "\nBinary size, time, name:"
	ls -lh ./$(BIN_FOLDER) | grep lbot | awk {'print $$5,$$8,$$9'} && echo

image: check
	docker build -t $(APP_PATH):$(DOCKER_TAG) .

scan: check
	docker scout quickview $(APP_PATH):$(DOCKER_TAG)
	docker scout cves $(APP_PATH):$(DOCKER_TAG)

push: check
	echo $(DOCKER_PASS) | docker login --username $(USER_NAME) --password-stdin
	docker push $(APP_PATH):$(DOCKER_TAG)

clean:
	docker images | grep $(APP_PATH) | awk '{print $$3}' | xargs docker rmi || :
	rm -rf ./$(BIN_FOLDER)
