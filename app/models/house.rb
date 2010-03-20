class House < ActiveRecord::Base
  belongs_to :user
  has_many :devices

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :user_id
end
