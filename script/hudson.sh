#!/bin/bash
# Script executed by hudson
echo "Executing $0"
echo "Running in $(pwd)"
rm -rf tmp/newrelic_rpm vendor/plugins/newrelic_rpm vendor/gems vendor/newrelic_rpm
mkdir -p tmp
mkdir -p log
mkdir -p vendor/gems
mkdir -p vendor/plugins

source ~/.rvm/scripts/rvm

rvm $RUBY@rails21_agent_tests --create

gem install rails --version=2.1.2

git clone hudson@repo.newrelic.com:/git/ruby_agent.git tmp/newrelic_rpm

(cd tmp/newrelic_rpm; git checkout -b integration origin/integration; rake build )
gem install tmp/newrelic_rpm/pkg/*.gem -i vendor --no-rdoc --no-ri
export RAILS_ENV=test

rake gems:install
rake --trace ci:setup:testunit test:newrelic || echo "Unit test failures"

