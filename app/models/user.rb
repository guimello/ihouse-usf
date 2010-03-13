class User < ActiveRecord::Base
  has_many :houses
  has_many :devices, :through => :houses
  has_many :logs, :conditions => {:loggable_type => "Device"}, :order => "created_at DESC"

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_length_of :password, :minimum => 6, :if => :password_changed?
  validates_presence_of :password_confirmation, :if => :password_changed?
  validates_confirmation_of :password, :if => :password_changed?
  validates_uniqueness_of :username, :if => :username_changed?
  validates_presence_of :username

  def to_s
    username
  end

  def self.authenticate(username, password)
    user = self.find_by_username_and_password username, password

    return (user.nil?) ? false : user
  end  
end
