module Controllers
  class MainController < Controllers::ApplicationController

    get '/' do
      erb :index
    end

    get '/json_test.json' do
      content_type :json
      {
        state: [
          ['Right', 5.0],
          ['Right', 5.0],
          ['Right', 5.0]
        ]
      }.to_json
    end

    get '/player' do
      content_type :json
      state = redis.get('state')
      commands = JSON.parse(state) if state
      if commands && commands['commands']
        {
          state: commands['commands']
        }.to_json
      else
        {
          state: ''
        }.to_json
      end
    end

    post '/update_player' do
      commands = []
      array = params[:player].split(', ')
      array.each do |item|
        commands << item.split(':')
      end
      redis.set('state', {commands: commands}.to_json)
      redis.expire('state', 15)
      redirect '/'
    end

    post '/update' do
      data = JSON.parse(request.body.read, symbolize_names: true)
      redis.set('state', data[:state])
      redis.expire('state', 15)
    end

    post '/sms_update' do
      if data
        commands = []
        array = data.split(', ')
        array.each do |item|
          commands << item.split(':')
        end
        redis.set('state', {commands: commands}.to_json)
        redis.expire('state', 15)
      end
    end
  end
end