# zsh-history-on-success

> Zsh plugin for filtering the commands saved to your zsh history file

Save yourself from repeating the same mistakes by filtering out your unsuccessful commands from your zsh history file.

Original code was written by Dean Scarff from this [blog post](https://scarff.id.au/blog/2019/zsh-history-conditional-on-command-success/). Some further features have been added.

## Features

1. Saves commands that exited successfully to your zsh history file.
1. Saves commands that exited with Ctrl+C and have been running for longer than the Ctrl+C duration (configurable with environment variables). Useful for saving commands that do not exit like running a web server.

## Install

Run this command to install this plugin if you are using [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh).

```bash
git -C "${ZSH_CUSTOM:-${ZSH:-$HOME/.oh-my-zsh}/custom}/plugins" clone --depth=1 https://github.com/nyoungstudios/zsh-history-on-success
```

## Configuration

This plugin can be configured with environment variables.

- `ZSH_HISTORY_DISABLE_CTRL_C_SAVES`. If set to `true`, commands that exited with Ctrl+C and have been running for longer than the Ctrl+C duration will not be saved to your zsh history file.
- `ZSH_HISTORY_CTRL_C_DURATION_MINUTES`. This is the threshold for the number of minutes that a command has been run for when the Ctrl+C signal was received must meet before it will be saved to your zsh history file. The default duration is 10 minutes.
- `ZSH_HISTORY_CTRL_C_DURATION_SECONDS`. Use this if you prefer to set the number of seconds. This is the threshold for the number of seconds that a command has been run for when the Ctrl+C signal was received must meet before it will be saved to your zsh history file.
