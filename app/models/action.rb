class Action < ActiveRecord::Base
  include Known::Actions
  include Serial::Actions
  
  act_as_virtual :handle
  
  belongs_to  :device
  #belongs_to  :voice_command
  has_many    :schedules  

  validates_presence_of :command, :action_type, :query_state
  validates_uniqueness_of :command, :scope => [:device_id]
  validates_inclusion_of :action_type, :in => [Action::ActionTypes::TURN_ON_OFF, Action::ActionTypes::RANGE]
  validates_presence_of :name, :unless => Proc.new {|action| action.know?}
  validates_presence_of :range_min, :range_max, :if => Proc.new {|action| action.validates_range?}
  validates_numericality_of :range_min, :range_max, :only_integer => true, :if => Proc.new {|action| action.validates_range?}
  validate :range_min_less_then_range_max, :if => Proc.new {|action| action.validates_range?}

  before_save :reset_ranges, :unless => Proc.new {|action| action.validates_range?}
  before_save :reset_name, :if => Proc.new {|action| action.name == action.default_name or action.name.blank?}

  named_scope :turn_on_off, :conditions => {:action_type => ActionTypes::TURN_ON_OFF}
  named_scope :range, :conditions => {:action_type => ActionTypes::RANGE}
  
  def range_min_less_then_range_max
    return true if range_min.nil? and range_max.nil?
    if range_min >= range_max
      errors.add :range_min, I18n.t(:range_min_must_be_less_than_range_max, :scope => [:action, :messages, :error])
      errors.add :range_max, I18n.t(:range_max_must_be_greater_than_range_min, :scope => [:action, :messages, :error])
    end    
  end

  def to_s
    name || default_name
  end

  def reset_name
    self.name = nil
  end

  def reset_ranges
    self.range_min = self.range_max = nil
  end

  def self.ACTION_TYPES
    {
      I18n.t(:turn_on_off, :scope => [:action, :action_type, :types]) => ActionTypes::TURN_ON_OFF,
      I18n.t(:range, :scope => [:action, :action_type, :types]) => ActionTypes::RANGE
    }
  end

  def validates_range?
    [ActionTypes::RANGE].include? action_type
  end
  
  attr_writer :temp_id
  
  def temp_id
    (@temp = rand.to_s.gsub('.','_') if @temp.nil?) && @temp
  end
end
