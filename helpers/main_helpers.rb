module Sinatra
  module MainHelpers
    def redis
      Sinatra::Middleware::REDIS
    end

    def data
      return if params[:Body].to_s.empty?
      params[:Body]
    end

    def match_robot(robot)
      return unless robot
      %w(RED BLUE).any? {|r| r == robot}
    end

    def setup_vote(question, time_period)
      return unless question && time_period
      redis.set('robot_question', question)
      redis.set('robot_time_period', time_period)
    end

    def no_data_response
      'No Data'
    end

    def protected!
      return if authorized?
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      halt 401, "Not authorized\n"
    end

    def authorized?
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      user, pass = ENV['USERNAME'], ENV['PASSWORD']
      @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [user, pass]
    end
  end
end