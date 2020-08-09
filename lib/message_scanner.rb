class MessageScanner
  def self.scan(message, bot)
    grinch_keys = ["halloween", "spook", "grinch", "october"]
    grinch_keys.each do |key|
      if message["text"].downcase.include?(key)
        CommandProcessor.christmas(message, bot)
      end
    end
    if message["text"].downcase.include?("spoil")
      text = "Rosebud is the sled!"
      send = GroupMeApi.post_message(text, bot[:bot_id])
    end
  end
end