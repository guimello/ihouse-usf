class VoiceCommand < ActiveRecord::Base
  has_many  :actions
end
