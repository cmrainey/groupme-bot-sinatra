# load libraries
require "sinatra"
require "json"
require "openssl"
require "faraday"
require "mimemagic"
require "net/http"
# load local code
require_relative "app"
require_relative "lib/group_me_api"
require_relative "lib/command_processor"
require_relative "lib/message_scanner"
require_relative "lib/open_weather_api"

# set RACK_ENV if it's not set already
if ENV['RACK_ENV'] != nil
  RACK_ENV = ENV['RACK_ENV']
else
  RACK_ENV = "development"
end

if RACK_ENV == "production"
  # Heroku ENV constants
  GROUPME_POST_URL = ENV['GROUPME_POST_URL']
  GROUPME_IMAGE_URL = ENV['GROUPME_IMAGE_URL']
  GROUPME_ACCESS_TOKEN = ENV['GROUPME_ACCESS_TOKEN']
  OPEN_WEATHER_API_KEY = ENV['OPEN_WEATHER_API_KEY']
  CHRISTMAS_GIFS = ENV['CHRISTMAS_GIFS'].split(",")
  STUDY_GIFS = ENV['STUDY_GIFS'].split(",")
  CERT_PATH = ENV['CERT_PATH']
  # parse the BOTS environment variable since Heroku doesn't do arrays in config vars
  # default string format to parse into bot array is:
  #
  # - "bot_id:abc123;group_name:Test Group 1;group_id:123456|bot_id:def456;group_name:Test Group 2;group_id:654321"
  #
  # you can add any number of bots, separated by "|". I include the group
  # name to help me keep track, but it's not used for anything, so you
  # can remove it if desired
  bots = []
  ENV['BOTS'].split("|").each do |s|
    strings = s.split(";")
    bot_id = strings[0].split(":")[1]
    group_id = strings[2].split(":")[1]
    bots << { :bot_id => bot_id, :group_id => group_id }
  end
  BOTS = bots
else
  # varibles above can be set in development by adding them in environment.rb
  # you'll need to create your own based on evironment.rb.example
  require_relative 'environment'
end

run Sinatra::Application