class Device < ActiveRecord::Base
	include KnownDevices
	
  belongs_to :house
  has_one :user, :through => :house
  has_many :actions
  has_many :schedules, :through => :actions
  #has_many :voice_commands, :through => :actions

	validates_presence_of :identification, :query_state
	validates_presence_of :name, :unless => Proc.new {|device| !device.default_name.blank?}

	before_save :reset_name, :if => Proc.new {|device| device.name == device.default_name}

	def reset_name
		self.name = nil
	end

	def to_s
		name
	end
end