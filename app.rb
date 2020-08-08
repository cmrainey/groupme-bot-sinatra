#require_relative "environment.rb"
post "/" do
  message = params
  message = JSON.parse(request.body.read)
  # select the appropriate bot for this message
  bot = BOTS.select{ |b| b[:group_id].to_s == message["group_id"].to_s }.first
  unless bot == nil || bot.empty? # don't run unless we have a bot for this group
    if message["text"][0] == "!" #commands start with "!", but you can define a different starting char as needed
      CommandProcessor.process(message, bot)
    else
      MessageScanner.scan(message, message) # scan for keywords for automated responses
    end
  end
end