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
# install dependencies
go get

# export token to variables
read -s TELE_TOKEN && echo $TELE_TOKEN && export TELE_TOKEN

# run chat bot
./lbot start
```
