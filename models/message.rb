class Message

  def initialize(json_array)
    @attachments = json_array["attachments"]
    @avatar_url  = json_array["avatar_url"]
    @created_at  = json_array["created_at"]
    @group_id    = json_array["group_id"]
    @id          = json_array["id"]
    @name        = json_array["name"]
    @sender_id   = json_array["sender_id"]
    @sender_type = json_array["sender_type"]
    @source_guid = json_array["source_guid"]
    @system      = json_array["system"]
    @text        = json_array["text"]
    @user_id     = json_array["user_id"]
  end

  def group_bot
    Bot.where(:bot_id => self.bot_id)
  end

end