# load libraries
require "sinatra"
require "json"
require "openssl"
require "faraday"
require "mimemagic"
require "net/http"
# load local code
require_relative "app"
require_relative "lib/apis/group_me_api"
require_relative "lib/apis/command_processor"
require_relative "models/bot"
require_relative "models/command"
require_relative "models/message"
require_relative "models/message_reply"
require_relative "models/scannable"
# database
require 'sinatra/activerecord'

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
else
  # varibles above can be set in development by adding them in environment.rb
  # you'll need to create your own based on evironment.rb.example
  require_relative 'environment'
end

run Sinatra::Application