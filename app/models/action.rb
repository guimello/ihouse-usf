################################################################################
class Action < ActiveRecord::Base

  ################################################################################
  include Known::Actions
  include Serial::Actions

  ################################################################################
  act_as_virtual :handle

  ################################################################################
  belongs_to  :device
  has_one     :house, :through    => :device
  has_many    :logs,  :conditions => {:loggable_type => 'Action'}, :order => 'created_at DESC'
  
  ################################################################################
  validates_presence_of     :command,     :action_type, :query_state
  validates_uniqueness_of   :command,     :scope          => [:device_id]
  validates_numericality_of :command,     :only_integer   => true
  validates_numericality_of :query_state, :only_integer   => true
  validates_inclusion_of    :action_type, :in             => [ActionTypes::TURN_ON_OFF, ActionTypes::RANGE]
  validates_presence_of     :name,        :unless         => Proc.new {|action| action.know?}
  validates_presence_of     :range_min,   :range_max, :if => Proc.new {|action| action.validates_range?}
  validates_numericality_of :range_min,   :range_max, :only_integer => true, :if => Proc.new {|action| action.validates_range?}
  validate                  :range_min_less_then_range_max, :if     => Proc.new {|action| action.validates_range?}

  ################################################################################
  before_save :reset_ranges,  :unless => Proc.new {|action| action.validates_range?}
  before_save :reset_name,    :if     => Proc.new {|action| action.name == action.default_name || action.name.blank?}

  ################################################################################
  named_scope :turn_on_off, :conditions => {:action_type => ActionTypes::TURN_ON_OFF}
  named_scope :range,       :conditions => {:action_type => ActionTypes::RANGE}

  ################################################################################
  attr_writer :temp_id
  attr_reader :new_value

  ################################################################################
  def new_value=(value)
    @new_value = value.to_i
  end

  ################################################################################
  def range_min_less_then_range_max
    return true if range_min.nil? and range_max.nil?
    if range_min >= range_max
      errors.add :range_min, I18n.t(:range_min_must_be_less_than_range_max,     :scope => [:action, :messages, :error])
      errors.add :range_max, I18n.t(:range_max_must_be_greater_than_range_min,  :scope => [:action, :messages, :error])
    end    
  end

  ################################################################################
  def to_s
    name || default_name || ''
  end

  ################################################################################
  def reset_name
    self.name = nil
  end

  ################################################################################
  def reset_ranges
    self.range_min = self.range_max = nil
  end

  ################################################################################
  def self.ACTION_TYPES
    {
      I18n.t(:turn_on_off,  :scope => [:action, :action_type, :types]) => ActionTypes::TURN_ON_OFF,
      I18n.t(:range,        :scope => [:action, :action_type, :types]) => ActionTypes::RANGE
    }
  end

  ################################################################################
  def validates_range?
    [ActionTypes::RANGE].include? action_type
  end

  ################################################################################
  def range?
    ActionTypes::RANGE == action_type
  end

  ################################################################################
  def turn_on_off?
    ActionTypes::TURN_ON_OFF == action_type
  end

  ################################################################################
  def customizing?
    return true if !known_action
    (known_action.action_type != action_type || (range? && known_action.handle[:orientation] != handle.orientation))
  end

  ################################################################################
  def slider_orientation
    (customizing?) ? handle.orientation : known_action.handle[:orientation]
  end

  ################################################################################
  def label_translation(which)
    I18n.t((!customizing?) ? known_action.handle[:translation_keys][which.to_sym].to_sym : which.to_sym, :scope => [:action, :device, ((action_type) ? action_type.to_sym : :turn_on_off), :state])
  end

  ################################################################################
  def temp_id
    (@temp_id.blank?) ? (@temp_id = rand.to_s.gsub('.','')) : @temp_id
  end

  ################################################################################
  def valid_new_value?
    if range?
      new_value >= range_min && new_value <= range_max
    else
      [0,1].include? new_value
    end
  end

  ################################################################################
  def write_log(options = {})
    if options[:action] == :set
      if range?
        message = I18n.t(:value_changed_to, :scope => [:action, :log], :value => new_value)
      else
        message = I18n.t("turned_#{new_value == 1 ? 'on' : 'off'}".to_sym, :scope => [:action, :log])
      end

      Log.create!(:loggable => self, :user => house.user, :custom => {:message => message}).save!
    end
  end
end