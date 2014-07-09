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
    state: ['Right 5', 'Right 5']
  }.to_json
end

get '/player' do
  content_type :json
  {
    state: redis.get('state')
  }
end

post '/update_player' do
  redis.set('state', params[:player])
  redis.expire('state', 5)
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