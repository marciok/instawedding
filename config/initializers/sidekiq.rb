if Rails.env.production?
  sidekiq_config = { url: ENV['REDISCLOUD_URL'], namespace: 'sidekiq_worker' }
  Sidekiq.configure_server do |config|
    config.redis = sidekiq_config
  end

  Sidekiq.configure_client do |config|
    config.redis = sidekiq_config
  end
end




