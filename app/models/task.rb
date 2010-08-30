################################################################################
class Task < ActiveRecord::Base

  ################################################################################
  belongs_to :house

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
  def answered_status
    operation.answered.split('!').last.sub '#', ''
  end

  ################################################################################
  private
  
  ################################################################################
  def prepare_message
    operation.sent[:message] = [key,
                              operation.sent[:device_identification],
                              operation.sent[:action_command],
                              operation.sent[:action_query_state]].join('!').insert(0, '#').insert(-1, '#')
  end
end
