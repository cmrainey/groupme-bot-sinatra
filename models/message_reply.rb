class MessageReply

  def initialize(text, attachment=nil, bot)
    @text = text
    @attachment = attachment
    @bot = bot
  end

  def bot
    Bot.where(:bot_id => self.bot_id)
  end

  def post
    if self.attachment.present?
      GroupMeApi.post_message(self.text, self.bot_id, self.attachment)
    else
      GroupMeApi.post_message(self.text, self.bot_id)
    end
  end

end