#require_relative "environment.rb"
post "/" do
  message = params
  message = JSON.parse(request.body.read)
  # parse the BOTS environment variable
  bots = []
  ENV['BOTS'].split("|").each do |s|
    strings = s.split(";")
    bot_id = strings[0].split(":")[1]
    group_id = strings[2].split(":")[1]
    bots << { :bot_id => bot_id, :group_id => group_id }
  end
  # select the appropriate bot for this message
  bot = bots.select{ |b| b[:group_id].to_s == message["group_id"].to_s }.first
  unless bot == nil || bot.empty? # don't run unless we have a bot for this group
    if message["text"][0] == "!" #commands start with "!", but you can define a different starting char as needed
      CommandProcessor.process(message, bot)
    else
      MessageScanner.scan(message, message) # scan for keywords for automated responses
    end
  end
end