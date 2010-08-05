class Device < ActiveRecord::Base
  include Known::Devices
  
  belongs_to :house  
  has_one :user, :through => :house
  has_many :actions
  accepts_nested_attributes_for :actions, :allow_destroy => true

  has_many :schedules, :through => :actions
  #has_many :voice_commands, :through => :actions

  validates_presence_of :identification, :device_class
  validates_presence_of :name, :unless => Proc.new {|device| device.know?}
  validates_uniqueness_of :identification, :scope => [:house_id]

  before_save :reset_name, :if => Proc.new {|device| device.name == device.default_name or device.name.blank?}
  
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
    device_class.blank? or identification.blank? or
    device_class != device_class_was or identification != identification_was

    true
  end

  act_as_virtual :custom
#  serialize :custom  

#  def after_initialize
#    self.custom = OpenStruct.new((custom.kind_of?(OpenStruct)) ? custom.marshal_dump : custom)
#  end

#  before_validation :convert_custom_attributes_to_hash
#  after_validation :convert_custom_attributes_to_ostruct

#  
#  def convert_custom_attributes_to_hash
#    self.custom = custom.marshal_dump if custom.kind_of? OpenStruct
#  end

#  def convert_custom_attributes_to_ostruct
#    self.custom = OpenStruct.new(custom) if custom.kind_of? Hash
#  end

  before_save :reset_display_icon

  def reset_display_icon
    custom.delete_field(:display_icon) if custom.display_icon == default_display_icon
  end

  ################################################################################
  named_scope :query_states, :select => :query_state
end
