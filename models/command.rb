require 'sinatra/activerecord'

class Command < ActiveRecord::Base

  validates_uniqueness_of :command

  def self.search_command(command, bot)
    c = Command.where(:invocation => command).where(:bot_id => bot.bot_id).first
    if c.present?
      c.call(bot.bot_id)
    else
      GroupMeApi.post_message("Unknown command #{command}.", bot.bot_id)
    end
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
      text = "Merry Christmas, #{message.name}!"
    end
    return MessageReply.new(text, attachment, bot)
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
    return MessageReply.new(text, attachment, bot)
  end

  def self.roll(message, bot)
    # simple dice roller takes a command in the form "xdy" where x is the number of dice and y is
    # the number of faces, e.g. 1d20 or 8d6
    dice = message.text.gsub("!roll ", "")
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
    return MessageReply.new(text, nil, bot)
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
    return MessageReply.new(text, nil, bot)
  end

  def self.baby_progress(message, bot)
    today = Date.today
    baby_start = Date.new(2020,11,27)
    baby_finish = Date.new(2021,8,27)
    baby_pct = (( ( today - baby_start ) / ( baby_finish - baby_start ) ).to_f * 100).round(1)
    baby_pct_not = 100.0 - baby_pct
    bar = "["
    (baby_pct / 6).round.times do
      bar << "👶"
    end
    (baby_pct_not / 6).round.times do
      bar << "__"
    end
    bar << "]"
    return MessageReply.new("Baby is \n#{bar} #{baby_pct}%\ncomplete.", nil, bot)
  end

  def self.weather(message, bot)
    # gets the current weather at a given 5-digit ZIP code from the OpenWeather API
    # see open_weath_api.rb for the API wrapper class
    zip = message.text.gsub("!weather ", "").to_i.to_s
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
    return MessageReply.new(text, nil, bot)
  end

  def call(bot_id)
    GroupMeApi.post_message(self.text, bot_id)
  end

end