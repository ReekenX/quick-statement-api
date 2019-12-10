namespace :token do
  desc 'Export database to JSON'
  task :generate => :environment do
    token_str = SecureRandom.uuid.slice(0, 13)
    Token.create(api_token: token_str)
    puts "New Token for API authorization: #{token_str}"
  end
end
