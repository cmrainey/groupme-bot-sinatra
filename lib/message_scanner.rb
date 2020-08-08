class MessageScanner
  def self.scan
    if message["name"].downcase.include?("stefan") || message["name"].downcase.include?("ze")
      grinch_keys = ["halloween", "spook", "grinch", "october"]
      grinch_keys.each do |key|
        if message["text"].downcase.include?(key)
          message["text"] = "!stefanchristmas"
          CommandProcessor.process_command(message, bot_id)
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