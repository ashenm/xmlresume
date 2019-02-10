#!/usr/bin/env sh
# Posit Dependencies

set -e

# trigger homepage build
curl -fsS \
  --request POST \
  --output /dev/null \
  --header "Travis-API-Version: 3" \
  --header "Accept: application/json" \
  --header "Content-Type: application/json" \
  --header "Authorization: token ${TRAVIS_API_TOKEN}" \
  --data "{ \"request\": { \"branch\": \"master\", \"message\": \"Build to parity with commit "${TRAVIS_COMMIT}" on "${TRAVIS_REPO_SLUG}"\" } }" "https://api.travis-ci.org/repo/ashenm%2Fhomepage/requests"
