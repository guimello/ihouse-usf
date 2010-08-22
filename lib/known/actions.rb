module Known
  module Actions
    def self.included(klass)
      klass.class_eval do
        include ActionTypes
        def know?
          !command.blank? and KnownAction.exists? :command => command
        end

        def default_name
          return KnownAction.find_by_command(command).name if know?
          nil
        end

        def display_icon(key)
          if !handle.send("display_icon_#{key}".to_sym).blank?
            handle.send("display_icon_#{key}".to_sym)
          elsif  know?
            known_action.handle["display_icon_#{key}".to_sym]
          else
            #icon class
            "unknown-action"
          end
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
end