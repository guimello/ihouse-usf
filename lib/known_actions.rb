module KnownActions

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