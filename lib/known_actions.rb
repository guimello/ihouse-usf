module KnownActions
	KNOWN_ACTIONS = {
																	:a001 =>
																		{
																			:command => "a001",
																			:type => Action::ActionTypes::TURN_ON_OFF,
																			:name => I18n.t(:name, :scope => [:action, :known, :a001]),
																			:handle_class => "toggle-me-fancy"
																		},
																	:b001 =>
																		{
																			:command => "b001",
																			:type => Action::ActionTypes::RANGE,
																			:name => I18n.t(:name, :scope => [:action, :known, :b001]),
																			:handle_class => "slide-me-vertical"
																		},
																	:b002 =>
																		{
																			:command => "b002",
																			:type => Action::ActionTypes::RANGE,
																			:name => I18n.t(:name, :scope => [:action, :known, :b002]),
																			:handle_class => "slide-me-fancy"
																		}
																	}

	def self.included(klass)
    klass.class_eval do
			include ActionTypes
			def know?
				!command.blank? and KNOWN_ACTIONS.key? command.to_sym
			end

			def default_name
				return KNOWN_ACTIONS[command.to_sym][:name] if know?
				nil
			end

			def self.all_action_types
				[ActionTypes::TURN_ON_OFF, ActionTypes::RANGE]
			end

			def self.known_actions
				KNOWN_ACTIONS
			end

			def known_action
				return KNOWN_ACTIONS[command.to_sym] if know?
				nil
			end
		end
	end
end