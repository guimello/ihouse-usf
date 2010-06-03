module SerialActions
  def self.included(klass)
    klass.class_eval do
      def state
        if action_type == Action::ActionTypes::RANGE
          rand(range_max)
        else
          I18n.t((["state_on","state_off"].fetch rand(2)).to_sym, :scope => [:action, :device, :turn_on_off, :state])
        end
      end

      def state_and_code
        if action_type == Action::ActionTypes::RANGE
          code = rand(range_max)
          {:code => code, :state => code}
        else
          code = ["state_on","state_off"].fetch rand(2)
          {:code => code, :state => I18n.t(code.to_sym, :scope => [:action, :device, :turn_on_off, :state])}
        end
      end

      def state_code
        if action_type == Action::ActionTypes::RANGE
          rand(range_max)
        else
          ["state_on","state_off"].fetch rand(2)
        end
      end
    end
  end
end
