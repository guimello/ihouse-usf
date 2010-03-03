class House < ActiveRecord::Base
  belongs_to :User
  has_many :devices
end
