################################################################################
class KnownDevice < ActiveRecord::Base

  ################################################################################
  validates_uniqueness_of :device_class

  ################################################################################
  def name
     I18n.t(:name, :scope => [:device, :known, device_class.to_sym])
  end
end