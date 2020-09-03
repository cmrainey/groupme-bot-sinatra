#require_relative "environment.rb"
post "/" do
  message = params
  # parse the GroupMe callback into a useful form:
  message = JSON.parse(request.body.read)
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

  # select the appropriate bot for this message
  # see config.ru for how this array is obtained
  bot = BOTS.select{ |b| b["group_id"].to_s == message["group_id"].to_s }.first

  # don't run unless we have a bot for this group
  unless bot == nil || bot.empty?
    # commands start with "!", but you can define a different starting char as needed
    # see the CommandProcessor class in command_processor.rb to change this if desired
    if message["text"][0] == "!"
      CommandProcessor.process(message, bot)
    else
      unless bot["disable_scanner"]
        # scan for keywords for automated responses
        MessageScanner.scan(message, bot)
      end
    end
  end
end