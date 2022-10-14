# not using env variables considering the project testing purpose

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis:6379' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis:6379' }
end