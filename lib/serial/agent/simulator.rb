################################################################################
module Serial
  ################################################################################
  module Agent
    ################################################################################
    class Simulator

      ################################################################################
      attr_accessor :task

      ################################################################################
      def initialize(task)
        @task = task
      end
      
      ################################################################################
      def simulate_message
        device = Device.find_by_house_id_and_identification task.house.id, task.operation.sent[:device_identification]
        raise Serial::Error::UnknownSerialError, 'error no device' unless device

        action = device.actions.find_by_command task.operation.sent[:action_command]
        raise Serial::Error::UnknownSerialError, 'error no action' unless action

        unless task.operation.sent[:action_query_state].blank?
          message = case action.action_type
            when ActionTypes::RANGE
              rand(action.range_max)
            when ActionTypes::TURN_ON_OFF
              ['state_on', 'state_off'].fetch rand(2)
            end
        else
          # write code here
        end

        message = "##{task.key}!#{message}#"
      end
    end
  end
end