require './app'
$stdout.sync = true

map '/' do
  run Controllers::MainController
end

map '/robots' do
  run Controllers::RobotsController
end