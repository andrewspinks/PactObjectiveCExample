#!/bin/bash
set -o pipefail

brew tap pact-foundation/pact-ruby-standalone
brew install pact-ruby-standalone
brew cask install fastlane

gem update cocoapods
pod update
