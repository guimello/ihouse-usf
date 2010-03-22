class Log < ActiveRecord::Base
  belongs_to :loggable, :polymorphic => true
  belongs_to :house

 
end