require "./models/bot"
require './models/message'
require './models/message_reply'
require './lib/apis/group_me'
require './lib/apis/open_weather'

class Message
  attr_accessor :attachments,:avatar_url,:created_at,:group_id,:id,:name,:sender_id,:sender_type,:source_guid,:system,:text,:user_id

  def initialize(attachments,avatar_url,created_at,group_id,id,name,sender_id,sender_type,source_guid,system,text,user_id)
    @attachments = attachments
    @avatar_url  = avatar_url
    @created_at  = created_at
    @group_id    = group_id
    @id          = id
    @name        = name
    @sender_id   = sender_id
    @sender_type = sender_type
    @source_guid = source_guid
    @system      = system
    @text        = text
    @user_id     = user_id
  end

  def self.create_from_hash(json_array)
    Message.new(json_array["attachments"],
      json_array["avatar_url"],
      json_array["created_at"],
      json_array["group_id"],
      json_array["id"],
      json_array["name"],
      json_array["sender_id"],
      json_array["sender_type"],
      json_array["source_guid"],
      json_array["system"],
      json_array["text"],
      json_array["user_id"]
    )
  end

  def bot
    Bot.where(:group_id => self.group_id).first
  end

end