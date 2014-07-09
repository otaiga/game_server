module Sinatra
  # Custom middleware
  module Middleware
    # Redis settings for production vs development
    class RedisSetting
      def self.production_redis
        uri = URI.parse(ENV['REDISTOGO_URL'])
        {
          host: uri.host,
          port: uri.port,
          password: uri.password
        }
      end
    end

    if Sinatra::Base.production?
      REDIS = Redis.new(RedisSetting.production_redis)
    else
      REDIS = Redis.new
    end
  end
end