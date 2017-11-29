def configure_cron
  rails_root = File.dirname(__FILE__) + '/../..'
  puts rails_root
  schedule_file = rails_root + "/config/schedule.yml"
  puts schedule_file
  if File.exists?(schedule_file)
      puts "exists"
    sidekiq_cron = YAML.load_file(schedule_file)
    puts sidekiq_cron
    Sidekiq::Cron::Job.load_from_hash sidekiq_cron
  end
end

def configure_server
  Sidekiq.configure_server do |config|
    config.redis = { :url => 'redis://envios-ya-martinlg.c9users.io:6379/0' }
  end
end

def configure_client
  Sidekiq.configure_client do |config|
    config.redis = { :url => 'redis://envios-ya-martinlg.c9users.io:6379/0' }
  end
end

if Rails.env == 'production'
  # For production, run server configs
  #configure_server
  #configure_client
else 
    #configure_cron
    #configure_client
    #configure_server
    #configure_cron
end