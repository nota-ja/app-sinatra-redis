require 'sinatra'
require 'redis'
require 'json'
require 'uri'

get '/env' do
  ENV['VCAP_SERVICES']
end

get '/rack/env' do
  ENV['RACK_ENV']
end

get '/' do
  'hello from sinatra'
end

get '/crash' do
  Process.kill("KILL", Process.pid)
end

post '/service/redis/:key' do
  redis = load_redis
  redis[params[:key]] = request.env["rack.input"].read
end

get '/service/redis/:key' do
  redis = load_redis
  redis[params[:key]]
end

not_found do
  'This is nowhere to be found.'
end

error do
  error = env['sinatra.error']
<<TEXT
#{error.inspect}

Backtrace:
  #{error.backtrace.join("\n  ")}
TEXT
end

def load_redis
  redis_service = load_service('redis')
  Redis.new({:host => (redis_service["hostname"] || redis_service["host"]), :port => redis_service["port"], :password => redis_service["password"]})
end

def load_service(service_name)
  services = JSON.parse(ENV['VCAP_SERVICES'])
  service = nil
  services.each do |k, v|
    v.each do |s|
      if k.downcase.include? service_name.downcase
        service = s["credentials"]
      end
    end
  end
  service
end
