################################################################################
class Log < ActiveRecord::Base

  ################################################################################
  belongs_to :loggable, :polymorphic => true
  belongs_to :user

  ################################################################################
  act_as_virtual :custom

  ################################################################################
  named_scope :action_logs,
              Proc.new {
              |current_user, house|
              conditions = ["logs.user_id = ? #{house != 'all' ? 'AND d.house_id = ?' : ''}", current_user.id]
              conditions << house.id if house != 'all'
                { :order => 'logs.created_at DESC',
                  :limit => 15,
                  :joins => [ %{
                              JOIN actions as a on a.id = logs.loggable_id AND logs.loggable_type = 'Action'
                              JOIN users as u on u.id = logs.user_id
                              JOIN devices as d on a.device_id = d.id}],
                  :conditions => conditions}}
end