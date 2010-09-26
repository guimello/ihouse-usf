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
          task = Task.create! :house => self.house,
                          :operation => {
                            :sent => {
                              :device_identification => self.device.identification,
                              :action_command => self.command,
                              :action_query_state => self.query_state
                            }
                          }

          task.wait_for_response

          response = {:code => task.answered_status}

          if range?
            response[:state] = response[:code]
          else
            response[:state] = I18n.t(response[:code].to_sym, :scope => [:action, :device, :turn_on_off, :state])
          end

          task.destroy
          response
        end

        ################################################################################
        def send_new_value
          task = Task.create! :house => self.house,
                    :operation => {
                      :sent => {
                        :device_identification => self.device.identification,
                        :action_command => self.command,
                        :value => self.new_value
                      }
                    }

          task.wait_for_response

          response = {:success => task.answered_setting_value.to_i, :operation => task.operation}
          task.destroy
          
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