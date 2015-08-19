after_fork do |server, worker|
 # Replace with MongoDB or whatever
  if defined?(ActiveRecord::Base)
     ActiveRecord::Base.establish_connection
     Rails.logger.info('Connected to ActiveRecord')
  end

# If you are using Redis but not Resque, change this
 if defined?(Resque)
    Resque.redis = ENV['REDISTOGO_URL']
    Rails.logger.info('Connected to Redis')
 end
end