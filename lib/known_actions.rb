module KnownActions
#	KNOWN_ACTIONS = {
#																	:a001 =>
#																		{
#																			:command => "a001",
#																			:type => Action::ActionTypes::TURN_ON_OFF,
#																			:name => I18n.t(:name, :scope => [:action, :known, :a001]),
#																			:handle => {:class => "toggle-me-fancy margin-auto"}
#																		},
#																	:b001 =>
#																		{
#																			:command => "b001",
#																			:type => Action::ActionTypes::RANGE,
#																			:name => I18n.t(:name, :scope => [:action, :known, :b001]),
#																			:handle => {:class => "slide-me-vertical margin-auto", :style => "height: 200px"}
#																		},
#																	:b002 =>
#																		{
#																			:command => "b002",
#																			:type => Action::ActionTypes::RANGE,
#																			:name => I18n.t(:name, :scope => [:action, :known, :b002]),
#																			:handle => {:class => "slide-me-vertical margin-auto", :style => "height: 200px"}
#																		}
#																	}

	def self.included(klass)
    klass.class_eval do
			include ActionTypes
			def know?
				#!command.blank? and KNOWN_ACTIONS.key? command.to_sym
				!command.blank? and KnownAction.exists? :command => command
			end

			def default_name
				#return KNOWN_ACTIONS[command.to_sym][:name] if know?
				return KnownAction.find_by_command(command).name if know?
				nil
			end

			def self.all_action_types
				[ActionTypes::TURN_ON_OFF, ActionTypes::RANGE]
			end

			def self.known_actions
				KnownAction.all
			end

			def known_action				
				KnownAction.find_by_command(command)
			end
		end
	end
end