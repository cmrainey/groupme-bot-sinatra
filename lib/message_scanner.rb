class MessageScanner
  def self.scan
    grinch_keys = ["halloween", "spook", "grinch", "october"]
    grinch_keys.each do |key|
      if message["text"].downcase.include?(key)
        text = "Merry Christmas!"
        image = File.open("assets/christmas_gifs/#{CHRISTMAS_GIFS.sample}", "r")
        begin
          image_url = GroupMeApi.post_image(image)
          attachment = { "type" => "image", "url" => image_url }
        rescue
          text = "Merry Christmas, Stefan!"
        end
      end
    end
    if message["text"].downcase.include?("spoil")
      text = "Rosebud is the sled!"
    end
    unless text == nil
      send = GroupMeApi.post_message(text, bot_id)
    end
  end
end