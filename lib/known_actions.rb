module KnownActions
	KNOWN_ACTIONS = {
																	:a001 =>
																		{
																			:command => "a001",
																			:type => Action::ActionTypes::TURN_ON_OFF,
																			:name => I18n.t(:name, :scope => [:action, :known, :a001])
																		},
																	:b001 =>
																		{
																			:command => "b001",
																			:type => Action::ActionTypes::RANGE,
																			:name => I18n.t(:name, :scope => [:action, :known, :b001])
																		},
																	:b002 =>
																		{
																			:command => "b002",
																			:type => Action::ActionTypes::RANGE,
																			:name => I18n.t(:name, :scope => [:action, :known, :b002])
																		}
																	}

	def self.included(klass)
    klass.class_eval do
			include ActionTypes
			def know_this?
				!command.blank? and KNOWN_ACTIONS.key? command.to_sym
			end

			def default_name
				return KNOWN_ACTIONS[command.to_sym][:name] if know_this?
				nil
			end

			def self.all_action_types
				[ActionTypes::TURN_ON_OFF, ActionTypes::RANGE]
			end
		end
	end
end