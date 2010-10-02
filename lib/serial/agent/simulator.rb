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
        # Says it's a query state, set value find actions, or discover message.
        # Diz se é uma mensagem do tipo 'query state', 'set value', 'find actions' ou 'discover'
        if task.operation.sent.key?(:device_identification)
          # Gets the device.
          # Localiza o dispositivo.
          device = Device.find_by_house_id_and_identification task.house.id, task.operation.sent[:device_identification]
          raise Serial::Error::UnknownSerialError, 'error no device' unless device

          # Gets the action.
          # Localiza a ação.
          unless task.operation.sent.key?(:find_actions)
            action = device.actions.find_by_command task.operation.sent[:action_command]
            raise Serial::Error::UnknownSerialError, 'error no action' unless action
          end
        end

        # Responds with a message accordingly.
        # Responde a mensagem apropriadamente.
        if task.operation.sent.key?(:action_query_state)
          message = state_message action
        elsif task.operation.sent.key?(:value)
          message = set_value_message
        elsif task.operation.sent.key?(:discover)
          message = discover_message
        else # Find actions.
          message = find_actions_message
        end

        # Prepends 'P' to the message, in order to say that it's been answered by the PIC.
        # Concatena no início da mensagem um 'P' para identificar uma mensagem enviada pelo PIC.
        message = "#P#{task.key}!#{message}#"
      end

      ################################################################################
      private

      ################################################################################
      def find_actions_message
        message = ''
        KnownAction.find(1,5).each do |action|
          message += '!' unless message.blank?
          message += "#{action.command}!#{action.query_state}!#{(action.action_type == ActionTypes::TURN_ON_OFF) ? 0 : 1}"

          if action.action_type == ActionTypes::RANGE
            message += "!#{action.handle[:range_min]}!#{action.handle[:range_max]}"
          end
        end

        message
      end
      
      ################################################################################
      def discover_message
        message = ''
        # Maybe apply a limit.
        KnownDevice.all.each do |device|
          message += '!' unless message.blank?
          
          case device.device_class
          when 'lamp'
            message += '1'
          when 'fan'
            message += '2'
          when 'tv'
            message += '3'
          when 'thermo'
            message += '4'
          end

          # Device identification.
          message += "!#{device.id}"
        end
        
        message
      end

      ################################################################################
      def state_message(action)
        if action.range?
          rand(action.range_max)
        else
          ['state_on', 'state_off'].fetch rand(2)
        end
      end

      ################################################################################
      def set_value_message
        # 200 OK, 500 Error
        # Loads configuration file in order to decide which value to return
        load_configuration_file['simulation']['set_value_message']
      end

      def load_configuration_file
        YAML::load(File.read(File.dirname(__FILE__) + '/../../../config/simulation.yml'))
      end
    end
  end
end