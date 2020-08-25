class CommandProcessor
  def self.process(message, bot)
    
    # you can add any number of commands; just give them:
    # - an !invoke string
    # - a method on the CommandProcesser class
    # - a case in this method that matches the invoke string to that method

    if message["text"].include?("!podbaydoors")
      open_doors(message, bot)
    elsif message["text"].include?("!weather")
      weather(message, bot)
    elsif message["text"].include?("!christmas")
      christmas(message, bot)
    elsif message["text"].include?("!study")
      study(message, bot)
    elsif message["text"].include?("!roll")
      roll(message, bot)
    elsif message["text"].include?("!progressbar")
      progressbar(message, bot)
    else
      unkown(message, bot)
    end
  end

  def self.unkown_command(message, bot)
    # simple text response with no added logic
    # see group_me_api.rb for the GroupMe API wrapper class
    GroupMeApi.post_message("Unknown command: #{message['text']}")
  end

  def self.christmas(message, bot)
    # post an image in response to a command
    text = "Merry Christmas!"
    image = File.open("assets/christmas_gifs/#{CHRISTMAS_GIFS.sample}", "r")
    begin
      # GroupMe's API only allows images hosted on their image hosting service, so post it there first
      # The post_image method returns the URL of the image for attaching if it succeeds
      image_url = GroupMeApi.post_image(image)
      attachment = { "type" => "image", "url" => image_url }
    rescue
      # you should specify a text fallback for most image posting methods in case the POST to GroupMe's
      # image API fails to complete
      text = "Merry Christmas, #{message["name"]}!"
    end
    GroupMeApi.post_message(text, bot[:bot_id], attachment)
  end

  def self.study(message, bot)
    text = "Go study!"
    image = File.open("assets/study_gifs/#{STUDY_GIFS.sample}", "r")
    begin
      image_url = GroupMeApi.post_image(image)
      attachment = { "type" => "image", "url" => image_url }
    rescue
      text = "Go study!"
    end
    GroupMeApi.post_message(text, bot[:bot_id], attachment)
  end

  def self.roll(message, bot)
    # simple dice roller takes a command in the form "xdy" where x is the number of dice and y is
    # the number of faces, e.g. 1d20 or 8d6
    dice = message["text"].gsub("!roll ", "")
    if /\d+d\d+/.match(dice)
      dice_arr = dice.split("d")
      number = dice_arr[0].to_i
      die = dice_arr[1].to_i
      rolls = []
      roll_total = 0
      number.times do
        roll = rand(1..die)
        roll_total += roll
        rolls << roll
      end
      text = "You rolled #{roll_total} #{rolls}"
    else
      text = "Invalid dice roll request."
    end
    GroupMeApi.post_message(text, bot[:bot_id])
  end

  def self.progressbar(message, bot)
    # calculates the perctange elapsed of the current year and posts an ACII art progress bar
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
    GroupMeApi.post_message(text, bot[:bot_id])
  end

  def self.weather(message, bot)
    # gets the current weather at a given 5-digit ZIP code from the OpenWeather API
    # see open_weath_api.rb for the API wrapper class
    zip = message["text"].gsub("!weather ", "").to_i.to_s
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
    GroupMeApi.post_message(text, bot[:bot_id])
  end

  def self.open_doors(message, bot)
    GroupMeApi.post_message("I'm sorry #{message['name']}, I'm afraid I can't do that.", bot[:bot_id])
  end
end