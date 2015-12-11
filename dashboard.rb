require "./lib/geolocation"
require "sinatra/base"
require "net/http"
require "sinatra"
require "json"
require "pry"

require "dotenv"
Dotenv.load

class Dashboard < Sinatra::Base
  get("/") do
    @ip = request.ip
    @geolocation = Geolocation.new(@ip)
    city = @geolocation.city
    state = @geolocation.state
    url = "http://api.wunderground.com/api/#{ENV['WUNDERGROUND_API_KEY']}/conditions/q/#{state}/#{city}.json"
    info = Net::HTTP.get_response(URI(url)).body
    @info = JSON.parse(info)["current_observation"]
    erb :dashboard
  end

  get "/weather" do
    @geolocation = Geolocation.new(request.ip)
    city = @geolocation.city
    state = @geolocation.state
    url = "http://api.wunderground.com/api/#{ENV['WUNDERGROUND_API_KEY']}/conditions/q/#{state}/#{city}.json"
    info = Net::HTTP.get_response(URI(url)).body
    @info = JSON.parse(info)["current_observation"]
    binding.pry
    erb :weather
  end
end

# http://api.wunderground.com/api/14af8b6c34bc042e/conditions/q/CA/San_Francisco.json
