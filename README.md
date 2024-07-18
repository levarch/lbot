# Simple Telegram Bot

Based on Cobra CLI and Telebot

[LBot Telegram link](https://t.me/levpa_bot)

## Packages and dependencies used

- fmt
- log
- os
- time
- github.com/spf13/cobra
- gopkg.in/telebot.v3

## Development and testing

```sh

# export token to variables
read -s TELE_TOKEN && echo $TELE_TOKEN && export TELE_TOKEN

# run code format, lint, test
make test

# local build
make build

# run chat bot
./out/lbot start

# create new docker image with default OS and architecture
make clean image

# scan image for vulnerabilities and issues
make scan

# paste DockerHub token into terminal
read -s DOCKER_PASS && export DOCKER_PASS

# push new image to Docker Hub
make push

# remove docker images and binary
make clean

```

## Builds for custom architectures and OSes

[GOOS and GOARCH variables can be found here](https://go.dev/doc/install/source#environment)

```sh
# export needed values as a first step, other commands the same 
export GOOS=linux GOARCH=amd64
```
