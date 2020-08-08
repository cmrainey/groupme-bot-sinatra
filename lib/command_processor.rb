class CommandProcessor
  def self.process(message, bot)
    name = message["name"]
    message_body = message["text"]
    attachment = nil
    if message_body == "!podbaydoors"
      text = "I'm sorry #{name}, I'm afraid I can't do that."
    elsif message_body.include?("!weather")
      zip = message_body.gsub("!weather ", "").to_i.to_s
      if zip.length < 5
        zeroes = 5 - zip.length
        zeroes.times do
          zip = "0" + zip
        end
      end
      begin
        text = OpenWeatherApi.call_api(zip)
      rescue
        text = "Couldn't get weather for ZIP code #{zip}."
      end
    elsif message_body == "!stefanchristmas"
      text = "Merry Christmas!"
      image = File.open("assets/christmas_gifs/#{CHRISTMAS_GIFS.sample}", "r")
      begin
        image_url = GroupMeApi.post_image(image)
        attachment = { "type" => "image", "url" => image_url }
      rescue
        text = "Merry Christmas, Stefan!"
      end
    elsif message_body == "!study"
      text = "Go study!"
      image = File.open("assets/study_gifs/#{STUDY_GIFS.sample}", "r")
      begin
        image_url = GroupMeApi.post_image(image)
        attachment = { "type" => "image", "url" => image_url }
      rescue
        text = "Go study!"
      end
    elsif message_body.include?("!roll")
      dice = message_body.gsub("!roll ", "")
      text = DiceRoller.roll(dice)
    elsif message_body == "!progressbar"
      today = Date.today
      days_this_year = Date.new(today.year, 12, 31).yday
      pct_done = (100.0 * today.yday / days_this_year).round
      pct_not = 100 - pct_done
      bar = "["
      (pct_done / 2).round.times do
        bar << "|"
      end
      (pct_not / 2).round.times do
        bar << " "
      end
      bar << "]"
      text = "#{today.strftime("%Y")} is \n#{bar} #{pct_done}%\n complete."
    else
      text = "Unknown command. I'm sorry #{name}, I'm afraid I can't do #{message_body}."
    end

    unless text == nil
      send = GroupMeApi.post_message(text, bot[:bot_id], attachment)
    end
  end
end