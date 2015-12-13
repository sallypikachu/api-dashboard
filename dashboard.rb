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
    region_code = @geolocation.region_code
    url = "http://api.wunderground.com/api/#{ENV['WUNDERGROUND_API_KEY']}/conditions/q/#{state}/#{city}.json"
    info = Net::HTTP.get_response(URI(url)).body
    @info = JSON.parse(info)["current_observation"]
    uri = "http://api.nytimes.com/svc/topstories/v1/technology.json?api-key=#{ENV['NYTIMES_API_KEY']}"
    tech = Net::HTTP.get_response(URI(uri)).body
    @tech = JSON.parse(tech)["results"]
    event_url = "http://api.seatgeek.com/2/events?venue.city=#{city}&venue.state=#{region_code}"
    event = Net::HTTP.get_response(URI(event_url)).body
    @events = JSON.parse(event)["events"]
    erb :dashboard
  end

  get "/weather" do
    @geolocation = Geolocation.new(request.ip)
    city = @geolocation.city
    state = @geolocation.state
    url = "http://api.wunderground.com/api/#{ENV['WUNDERGROUND_API_KEY']}/conditions/q/#{state}/#{city}.json"
    info = Net::HTTP.get_response(URI(url)).body
    @info = JSON.parse(info)["current_observation"]
    erb :weather
  end

  get "/events" do
    @geolocation = Geolocation.new(request.ip)
    city = @geolocation.city
    region_code = @geolocation.region_code
    event_url = "http://api.seatgeek.com/2/events?venue.city=#{city}&venue.state=#{region_code}"
    event = Net::HTTP.get_response(URI(event_url)).body
    @events = JSON.parse(event)["events"]
    erb :events
  end

  get "/news" do
    uri = "http://api.nytimes.com/svc/topstories/v1/technology.json?api-key=#{ENV['NYTIMES_API_KEY']}"
    tech = Net::HTTP.get_response(URI(uri)).body
    @tech = JSON.parse(tech)["results"]
    erb :news
  end
end


# http://api.wunderground.com/api/14af8b6c34bc042e/conditions/q/CA/San_Francisco.json
