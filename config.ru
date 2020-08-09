require "sinatra"
require "json"
require "openssl"
require "faraday"
require "mimemagic"
require "net/http"
require_relative "app"
require_relative "lib/group_me_api"
require_relative "lib/command_processor"
require_relative "lib/message_scanner"
require_relative "lib/dice_roller"
require_relative "lib/open_weather_api"

# Heroku ENV constants
GROUPME_POST_URL = ENV['GROUPME_POST_URL']
GROUPME_IMAGE_URL = ENV['GROUPME_IMAGE_URL']
GROUPME_ACCESS_TOKEN = ENV['GROUPME_ACCESS_TOKEN']
OPEN_WEATHER_API_KEY = ENV['OPEN_WEATHER_API_KEY']
CHRISTMAS_GIFS = ENV['CHRISTMAS_GIFS'].split(",")
STUDY_GIFS = ENV['STUDY_GIFS'].split(",")
CERT_PATH = ENV['CERT_PATH']
BOTS = ENV['BOTS']

run Sinatra::Application