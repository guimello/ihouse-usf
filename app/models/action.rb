class Action < ActiveRecord::Base
  belongs_to  :device
  #belongs_to  :voice_command
  has_many    :schedules
end
