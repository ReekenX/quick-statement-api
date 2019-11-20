if Rails.env == 'production' && ENV['RAVEN_URL']
  Raven.configure do |config|
    config.dsn = ENV['RAVEN_URL']
  end
end
