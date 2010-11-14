################################################################################
class Device < ActiveRecord::Base

  ################################################################################
  include Known::Devices
  include Serial::Devices

  ################################################################################
  belongs_to  :house
  has_one     :user,      :through    => :house
  has_many    :actions
  has_many    :logs,      :conditions => {:loggable_type => 'Device'}, :order => 'created_at DESC'

  ################################################################################
  accepts_nested_attributes_for :actions, :allow_destroy => true, :reject_if => proc {|attributes|
    attributes['name'].blank?     &&
    attributes['command'].blank?  &&
    attributes['query_state'].blank?
  }

  ################################################################################
  act_as_virtual :custom

  ################################################################################
  validates_presence_of     :identification,  :device_class, :house
  validates_numericality_of :identification,  :only_integer => true, :allow_blank => true
  validates_presence_of     :name,            :unless       => Proc.new {|device| device.know?}
  validates_uniqueness_of   :identification,  :scope        => [:house_id]

  ################################################################################
  before_save :reset_name, :if => Proc.new {|device| device.name == device.default_name or device.name.blank?}
  before_save :reset_display_icon

  ################################################################################
  named_scope :order_by_room, :order => :room
  named_scope :group_by_room, :group => :room
  named_scope :by_room, Proc.new {|room| {:conditions => {:room => room}}}
  named_scope :query_states, :select => :query_state

  ################################################################################
  def reset_name
    self.name = nil
  end

  ################################################################################
  def to_s
    name || default_name
  end

  ################################################################################
  def enable_advanced?(field)
    if ["name", "room"].include?(field.to_s)    ||
      device_class.blank?                       ||
      identification.blank?                     ||
      device_class    != device_class_was       ||
      identification  != identification_was

      return false
    end

    true
  end

  ################################################################################
  def reset_display_icon
    custom.delete_field(:display_icon) if custom.display_icon == default_display_icon
  end
end