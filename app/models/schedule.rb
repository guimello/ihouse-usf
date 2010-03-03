class Schedule < ActiveRecord::Base
  belongs_to :action
  has_one :device, :through => :action
end
