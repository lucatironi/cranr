Resque.redis = "#{ENV.fetch('REDIS_HOST') { 'localhost' }}:#{ENV.fetch('REDIS_PORT') { 6379 }}"
Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }
