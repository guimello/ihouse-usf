class Device < ActiveRecord::Base
  belongs_to :project
  has_one :user, :through => :project
  has_many :actions
  has_many :schedules, :through => :actions
  has_many :voice_commands, :through => :actions
end
