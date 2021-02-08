require './lib/apis/group_me'

class MessageReply
  attr_accessor :text, :attachment, :bot
  def initialize(text, attachment=nil, bot)
    @text = text
    @attachment = attachment
    @bot = bot
  end

  def post
    if self.attachment.present?
      GroupMeApi.post_message(self.text, self.bot.bot_id, self.attachment)
    else
      GroupMeApi.post_message(self.text, self.bot.bot_id)
    end
  end

end