class Device < ActiveRecord::Base
	include KnownDevices
	
  belongs_to :house
  has_one :user, :through => :house
  has_many :actions
	accepts_nested_attributes_for :actions, :allow_destroy => true

  has_many :schedules, :through => :actions
  #has_many :voice_commands, :through => :actions

	validates_presence_of :identification, :query_state, :device_class
	validates_presence_of :name, :unless => Proc.new {|device| !device.default_name.blank?}
	validates_uniqueness_of :identification, :scope => [:house_id]

	before_save :reset_name, :if => Proc.new {|device| device.name == device.default_name}

	def reset_name
		self.name = nil
	end

	def to_s
		name || default_name
	end

	named_scope :order_by_room, :order => :room
	named_scope :group_by_room, :group => :room
	named_scope :by_room, Proc.new {|room| {:conditions => {:room => room}}}

	def enable_advanced?(field)
		return false if ["name", "room"].include? field.to_s or
		device_class.blank? or identification.blank? or query_state.blank? or
		device_class != device_class_was or identification != identification_was or
		query_state != query_state_was

		true
	end
end