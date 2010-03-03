class User < ActiveRecord::Base
  has_many :houses
  has_many :devices, :through => :houses
  has_many :logs, :conditions => {:loggable_type => "Device"}, :order => "created_at DESC"

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  def to_s
    username
  end
end
