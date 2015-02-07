#!/bin/bash
set -o pipefail

cd Vendor/pact-consumer-swift
git pull
git submodule update --init --recursive
cd -

xcodebuild -project PactObjectiveCExample.xcodeproj -scheme PactObjectiveCExample clean test -sdk iphonesimulator | xcpretty -c