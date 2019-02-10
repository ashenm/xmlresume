#!/usr/bin/env sh
# Install XMLResume Build Dependencies

set -e

# python3 libraries
pip3 install --requirement requirements.txt

# chrome-headless
curl -sSL https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - && \
  echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list && \
  sudo apt-get update && sudo apt-get install --assume-yes --fix-broken google-chrome-stable
