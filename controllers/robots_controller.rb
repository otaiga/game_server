module Controllers
  class RobotsController < Controllers::ApplicationController

    get '/setup' do
      protected!
      erb :robot_vote
    end

    get '/red' do
      state = redis.get('red')
      return no_data_response unless state
      redis.del('red')
      state
    end

    get '/blue' do
      state = redis.get('blue')
      return no_data_response unless state
      redis.del('blue')
      state
    end

    get '/red_count' do
      state = redis.get('red_count')
      return no_data_response unless state
      state
    end

    get '/blue_count' do
      state = redis.get('blue_count')
      return no_data_response unless state
      state
    end

    get '/settings_question' do
      redis.get('robot_question')
    end

    get '/settings_time' do
      redis.get('robot_time_period')
    end

    get '/warning' do
      protected!
      erb :warning
    end

    get '/success' do
      protected!
      erb :success
    end

    get '/winner_result' do
      red = redis.get('red_count').to_i
      blue = redis.get('blue_count').to_i
      return 'Draw' if red == blue
      return 'Red' if red > blue
      'Blue'
    end

    post '/update_settings' do
      question = params[:question].to_s
      time_period = params[:time_period].to_i
      redirect 'robots/warning' if question.empty?
      redirect 'robots/warning' if time_period <= 0
      setup_vote(question, time_period)
      redirect 'robots/success'
    end

    post '/reset_settings' do
      redis.del(
        'blue_count',
        'red_count',
        'blue',
        'red',
        'robot_time_period',
        'robot_question'
      )
      redirect 'robots/success'
    end

    post '/robot_update' do
      return {} unless data && match_robot(data.upcase)
      robot = data.downcase
      redis.set(robot, 'HIT')
      redis.expire(robot, 10)
      current = redis.get("#{robot}_count").to_i
      redis.set("#{robot}_count", current += 1 )
    end

    post '/test_robot_update' do
      data = JSON.parse(request.body.read, symbolize_names: true)
      return {} unless data[:robot] && match_robot(data[:robot].upcase)
      robot = data[:robot].downcase
      redis.set(robot, 'HIT')
      redis.expire(robot, 10)
      current = redis.get("#{robot}_count").to_i
      redis.set("#{robot}_count", current += 1 )
    end
  end
end
