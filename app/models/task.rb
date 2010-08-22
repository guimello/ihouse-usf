class Task < ActiveRecord::Base
  belongs_to :house

  validates_presence_of :operation
  validates_presence_of :key
  validates_numericality_of :key

  act_as_virtual :operation
end
