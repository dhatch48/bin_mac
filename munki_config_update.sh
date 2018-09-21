#!/bin/bash

sudo defaults write /Library/Preferences/ManagedInstalls SoftwareRepoURL "http://10.93.0.210/munki_repo"
sudo defaults write /Library/Preferences/ManagedInstalls InstallAppleSoftwareUpdates -bool True 
defaults read /Library/Preferences/ManagedInstalls
