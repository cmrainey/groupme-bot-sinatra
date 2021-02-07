#require_relative "environment.rb"
require "sinatra/base"
require "sinatra/activerecord"


class Application < Sinatra::Base
  post "/" do
    message = params
    # parse the GroupMe callback into a useful form:
    message = Message.new(JSON.parse(request.body.read))
    # for reference, the GroupMe callback posts JSON data in this format:
    #
    #  {
    #    "attachments": [],
    #    "avatar_url": "https://i.groupme.com/123456789",
    #    "created_at": 1302623328,
    #    "group_id": "1234567890",
    #    "id": "1234567890",
    #    "name": "John",
    #    "sender_id": "12345",
    #    "sender_type": "user",
    #    "source_guid": "GUID",
    #    "system": false,
    #    "text": "Hello world ☃☃",
    #    "user_id": "1234567890"
    #  }
    #
    if message.bot.present?
      if message.text[0] == "!"
        command = message.text[/(\!\S+)/,1].gsub("!","")
        begin
          Command.public_send(command, message, bot).post
        rescue
          Command.search_command(command, bot)
        end
      else
        Scannable.scan_message(message).post
      end
    end
  end
end