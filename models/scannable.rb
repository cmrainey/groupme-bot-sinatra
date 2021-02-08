require 'sinatra/activerecord'

class Scannable < ActiveRecord::Base

  def self.scan_message(message)
    scans = Scannable.where(:group_id => message.group_id).each
    if scans.present?
      scans.each do |s|
        if message.include?(s.text)
          if s.command_invocation.present?
            begin
              Command.public_send(s.command_invocation).post
            end
          else
            MessageReply.new(s.response, nil, bot).post
          end
        end
      end
    end
  end

end