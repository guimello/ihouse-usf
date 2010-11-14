################################################################################
class House < ActiveRecord::Base

  ################################################################################
  belongs_to  :user
  has_many    :devices
  has_many    :actions, :through    => :devices
  has_many    :taks
  has_many    :logs,    :conditions => {:loggable_type => 'House'}, :order => 'created_at DESC'

  ################################################################################
  validates_presence_of   :name, :user
  validates_uniqueness_of :name, :scope => :user_id

  ################################################################################
  accepts_nested_attributes_for :devices, :allow_destroy => true, :reject_if => proc {|attributes|
      attributes['name'].blank?         &&
      attributes['room'].blank?         &&
      attributes['device_class'].blank? &&
      attributes['identification'].blank?
  }

  ################################################################################
  def to_s
    name
  end
end