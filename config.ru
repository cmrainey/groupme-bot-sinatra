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

run Sinatra::Application