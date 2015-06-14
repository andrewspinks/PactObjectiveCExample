#!/bin/bash
set -o pipefail

xcodebuild -workspace PactObjectiveCExample.xcworkspace -scheme PactObjectiveCExample clean test -sdk iphonesimulator | xcpretty -c