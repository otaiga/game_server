require 'sinatra'
require 'json'
require 'redis'
require './lib/redis_setting'

include Sinatra::Middleware

helpers do
  def redis
    Sinatra::Middleware::REDIS
  end

  def data
    return if params[:Body].to_s.empty?
    params[:Body]
  end
end

get '/' do
  erb :index
end

get '/json_test.json' do
  content_type :json
  {
    state: [
      'Right',
      5.0,
      'Right',
      5.0,
      'Right',
      5.0
    ]
  }.to_json
end

get '/player' do
  content_type :json
  commands = JSON.parse(redis.get('state'))
  {
    state: commands['commands']
  }.to_json
end

post '/update_player' do
  commands = []
  array = params[:player].split(', ')
  array.each do |item|
    commands << item.split(':')
  end
  redis.set('state', {commands: commands}.to_json)
  redis.expire('state', 10)
  redirect '/'
end

post '/update' do
  data = JSON.parse(request.body.read, symbolize_names: true)
  redis.set('state', data[:state])
  redis.expire('state', 5)
end

post '/sms_update' do
  if data
    redis.set('state', data)
    redis.expire('state', 5)
  end
end