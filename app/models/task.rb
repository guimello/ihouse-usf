################################################################################
class Task < ActiveRecord::Base

  ################################################################################
  belongs_to  :house
  has_many    :logs, :conditions => {:loggable_type => 'Task'}, :order => 'created_at DESC'

  ################################################################################
  act_as_virtual :operation

  ################################################################################
  before_validation :create_key, :if => Proc.new {|task| task.key.blank? && task.house && !task.status.blank?}
  before_create :prepare_message, :if => Proc.new {|task| task.operation.sent[:message].blank?}

  ################################################################################
  validates_presence_of :house, :operation
  validates_presence_of :key, :status
  validates_numericality_of :key

  validates_uniqueness_of :key, :if => Proc.new {|task| !task.key.blank? && task.house || !task.status.blank?}

  ################################################################################
  def unique_key?
    !Task.exists?(["tasks.key = ?", key])
  end

  ################################################################################
  def create_key
    begin
      self.key = rand 100
    end while(!unique_key?)
  end

  ################################################################################
  def answered_discover_query
    operation.answered.gsub(/\n/, '')
  end

  ################################################################################
  alias :answered_find_actions :answered_discover_query

  ################################################################################
  def answered_status
    operation.answered.split('!').last.sub('#', '').gsub(/\n/, '')
  end

  ################################################################################
  alias :answered_setting_value :answered_status

  ################################################################################
  def wait_for_response
    10.times do
      # For some reason task.reload won't work by itself so we touch the object...
      self.reload
      self.touch

      break if self.status == Serial::Status::ANSWERED

      sleep_for_a_while
    end

    raise Serial::Error::UnknownSerialError if self.status != Serial::Status::ANSWERED
  end

  ################################################################################
  private
  
  ################################################################################
  def prepare_message
    if operation.sent.key? :discover
      operation.sent[:message] = [  key, Serial::Interation::DEVICE_DISCOVERY , operation.sent[:discover] ]
    elsif operation.sent.key? :value
      operation.sent[:message] = [
                                    key,
                                    Serial::Interation::SET_VALUE,
                                    operation.sent[:device_identification],
                                    operation.sent[:action_command],
                                    operation.sent[:value]
                                 ]
    elsif operation.sent.key? :find_actions
      operation.sent[:message] = [  
                                    key,
                                    Serial::Interation::ACTION_DISCOVERY,
                                    operation.sent[:device_identification],
                                    operation.sent[:find_actions]
                                 ]
    else
      operation.sent[:message] = [  
                                    key,
                                    Serial::Interation::CURRENT_STATUS,
                                    operation.sent[:device_identification],
                                    operation.sent[:action_command],
                                    operation.sent[:action_query_state]
                                 ]
    end

    operation.sent[:message] = operation.sent[:message].join('!').insert(0, '#').insert(-1, '#')
  end

  ################################################################################
  def sleep_for_a_while
    begin
      sleep 2
    rescue
    end
  end
end