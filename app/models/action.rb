class Action < ActiveRecord::Base
  belongs_to  :device
  #belongs_to  :voice_command
  has_many    :schedules

	validates_presence_of :command, :action_type
	#validates_presence_of :name, :if => Proc.new {|action| action.default_name.blank?}

	def self.ACTION_TYPES
		{
			I18n.t(:turn_on_off, :scope => [:action, :action_type, :types]) => "turn_on_off",
			I18n.t(:range, :scope => [:action, :action_type, :types]) => "range"
		}
	end
end
