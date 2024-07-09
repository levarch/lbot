# Simple Telegram Bot

Based on Cobra CLI and Telebot

## Packages and dependencies used

- fmt
- log
- os
- time
- github.com/spf13/cobra
- gopkg.in/telebot.v3

## Development and testing

```sh
# code format
gofmt -s -w ./

# install dependencies
go get

# change product version if needed 
echo "1.0.3" > VERSION

# first: you have to generate token for the bot in BotFather (Telegram messenger)
# export bot token to variables
read -s TELE_TOKEN && echo $TELE_TOKEN
export TELE_TOKEN

# build module with baked appVersion variable
go build -ldflags "-X="github.com/levarch/lbot/cmd.appVersion=v$(cat VERSION)

# run chat bot
./lbot start
```
