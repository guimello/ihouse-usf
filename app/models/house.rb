################################################################################
class House < ActiveRecord::Base

  ################################################################################
  belongs_to  :user
  has_many    :devices
  has_many    :taks
  has_many    :logs, :conditions => {:loggable_type => 'House'}, :order => 'created_at DESC'

  ################################################################################
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :user_id

  ################################################################################
  accepts_nested_attributes_for :devices, :allow_destroy => true

  ################################################################################
  def to_s
    name
  end
end
