class Schedule < ActiveRecord::Base
  belongs_to :action
  has_one :device, :through => :action
  has_one :house, :through => :device
  has_one :user, :through => :house
  
  act_as_virtual :timing
end
