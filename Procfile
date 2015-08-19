web: bundle exec unicorn -p $PORT -E $RACK_ENV -c ./config/unicorn.rb
resque: env TERM_CHILD=1 QUEUE=* bundle exec rake resque:work
