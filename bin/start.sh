#!/bin/bash

bundle check || bundle install

if [ -f tmp/pids/server.pid ]; then
  rm -f tmp/pids/server.pid
fi

bundle exec bin/rails server -p $PORT -b 0.0.0.0
