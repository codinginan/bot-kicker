require 'slack-ruby-client'
require 'dotenv'
Dotenv.load

Slack.configure do |config|
  config.token = ENV['TOKEN']
end

client = Slack::RealTime::Client.new
puts "Starting kicker-bot"

client.on :message do |data|
  kick_user(client, data) if data['channel'] == ENV['CHANNEL'] && data['subtype'] == 'group_join' && data['user'] == ENV['USER']
end

def kick_user(client, data)
  puts "Kicking Phil"
  client.web_client.chat_postMessage({channel: ENV['CHANNEL'], text: "I don't think <@#{data['user']}> wants to do pushups anymore."})
  client.web_client.chat_postMessage({channel: ENV['CHANNEL'], text: 'Kicking him in: '})
  (1..3).to_a.reverse.each do |num|
    client.web_client.chat_postMessage({channel: ENV['CHANNEL'], text: num.to_s })
    sleep(1)
  end
  client.web_client.groups_kick({channel: data['channel'], user: data['user']})
end

client.start!
