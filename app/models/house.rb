class House < ActiveRecord::Base
  belongs_to :user
  has_many :devices
	
	has_many :logs, :conditions => {:loggable_type => "Action"}, :order => "created_at DESC"

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :user_id
end
