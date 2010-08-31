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
                            }#,
                            #:retries => 0
                          }

          begin
            # For some reason task.reload won't work by itself so we touch the object...
            task.reload
            task.touch

            break if task.status == Serial::Status::ANSWERED

            sleep_for_a_while
          end while task.status != Serial::Status::ANSWERED

          response = {:code => task.answered_status}

          if action_type == ActionTypes::RANGE
            response[:state] = response[:code]
          else
            response[:state] = I18n.t(response[:code].to_sym, :scope => [:action, :device, :turn_on_off, :state])
          end

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