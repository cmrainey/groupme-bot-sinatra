require 'sinatra/activerecord'

class Bot < ActiveRecord::Base
  validates_uniqueness_of :bot_id
end