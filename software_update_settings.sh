# TOGGLE ALL ON except for Mac OS updates
# before setting values quit system preferences & stop software update - stops deafults cache breaking 'AutomaticCheckEnabled'
osascript -e "tell application \"System Preferences\" to quit"
sudo softwareupdate --schedule off
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticCheckEnabled -bool YES
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticDownload -bool YES
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist ConfigDataInstall -bool YES
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist CriticalUpdateInstall -bool YES
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist ScheduleFrequency -int 5
sudo defaults write /Library/Preferences/com.apple.commerce.plist AutoUpdateRestartRequired -bool NO
sudo defaults write /Library/Preferences/com.apple.commerce.plist AutoUpdate -bool YES
# See the results…
#open "/System/Library/PreferencePanes/AppStore.prefPane/"
