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

          begin
            # For some reason task.reload won't work...
            task.reload
            break if task.status == Serial::Status::ANSWERED

            begin
              sleep 3
            rescue
            end

          end while(task.status != Serial::Status::ANSWERED)

          task.reload

          response = {:code => task.answered_status}

          if action_type == ActionTypes::RANGE
            response[:state] = response[:code]
          else
            response[:state] = I18n.t(response[:code].to_sym, :scope => [:action, :device, :turn_on_off, :state])
          end

          task.destroy
          response
        end
      end
    end
  end
end