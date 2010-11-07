################################################################################
require 'serialport'

################################################################################
module Serial
  ################################################################################
  module Actions
    ################################################################################
    def self.included(klass)
      ################################################################################
      klass.class_eval do
      
        ################################################################################
        def state
          task = Task.create! :house  => self.house,
                          :operation  => {
                            :sent => {
                              :device_identification  => self.device.identification,
                              :action_command         => self.command,
                              :action_query_state     => self.query_state
                            }
                          }

          begin
            task.wait_for_response
          rescue Serial::Error::UnknownSerialError
            response = {:code           => range? ? 0 : 'state_off',
                        :error_message  => I18n.t(:error_obtaining_the_action_status, :scope => [:action, :messages, :error])}
          end

          response = {:code => task.answered_status} unless response.is_a?(Hash)

          if range?
            response[:state] = response[:code]
          else
            response[:state] = I18n.t(response[:code].to_sym, :scope => [:action, :device, :turn_on_off, :state])
          end

          task.destroy unless response.key?(:error_message)
          response
        end

        ################################################################################
        def send_new_value
          task = Task.create! :house => self.house,
                    :operation => {
                      :sent => {
                        :device_identification  => self.device.identification,
                        :action_command         => self.command,
                        :value                  => self.new_value
                      }
                    }

          begin
            task.wait_for_response
          rescue Serial::Error::UnknownSerialError
            response = {:success => 500, :error => true}
          end

          response = {:success => task.answered_setting_value.to_i, :operation => task.operation} unless response.is_a?(Hash)
          task.destroy unless response.key?(:error)
          
          response
        end

        ################################################################################
        private

        ################################################################################
        def sleep_for_a_while
          begin
            sleep 2
          rescue
          end
        end
      end
    end
  end
end