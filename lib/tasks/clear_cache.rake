namespace :cache do
  desc 'Clears Rails cache'
  task :clear => :environment do
    Rails.cache.clear.each do |dir|
      puts "Cleared: #{dir}"
    end
  end
end