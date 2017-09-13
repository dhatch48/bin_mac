#!/usr/bin/env bash

defaults write com.apple.screensaver askForPassword 1
defaults write com.apple.screensaver askForPasswordDelay 300    # 5 min

defaults read com.apple.screensaver
