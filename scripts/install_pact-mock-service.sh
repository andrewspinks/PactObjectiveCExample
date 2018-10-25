#!/bin/bash
set -o pipefail

VERSION=$1

curl -LO https://github.com/pact-foundation/pact-ruby-standalone/releases/download/v$VERSION/pact-$VERSION-osx.tar.gz
tar xzf pact-$VERSION-linux-x86_64.tar.gz
