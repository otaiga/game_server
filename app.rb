require 'sinatra'
require 'json'
require 'redis'
require './lib/redis_setting'

include Sinatra::Middleware

helpers do
  def redis
    Sinatra::Middleware::REDIS
  end
end

get '/' do
  redis.get('state')
end

post '/update' do
  data = JSON.parse(request.body.read, symbolize_names: true)
  redis.set('state', data[:state])
end