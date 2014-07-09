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
  redis.get('state')
end

post '/update' do
  data = JSON.parse(request.body.read, symbolize_names: true)
  redis.set('state', data[:state])
end

post '/sms_update' do
  redis.set('state', data) if data
end