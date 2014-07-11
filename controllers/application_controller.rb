module Controllers
  class ApplicationController < Sinatra::Base
    include Sinatra::Middleware
    helpers Sinatra::MainHelpers 
  end
end
