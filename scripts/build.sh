#!/bin/bash
set -o pipefail

xcodebuild -workspace PactObjectiveCExample.xcworkspace -scheme PactObjectiveCExample clean test -destination 'platform=iOS Simulator,OS=10.0,name=iPhone 6' -sdk iphonesimulator | xcpretty -c
