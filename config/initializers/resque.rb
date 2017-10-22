# frozen_string_literal: true

Resque.redis = "#{ENV.fetch('REDIS_HOST') { 'localhost' }}:#{ENV.fetch('REDIS_PORT') { 6379 }}"
Resque.after_fork = proc { ActiveRecord::Base.establish_connection }
