class Device < ActiveRecord::Base
  belongs_to :house
  has_one :user, :through => :house
  has_many :actions
  has_many :schedules, :through => :actions
  #has_many :voice_commands, :through => :actions

	validates_presence_of :identification
end
