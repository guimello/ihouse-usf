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
          SerialPort.new '/dev/pts/5', 9600, 8, 1, SerialPort::NONE do |serial|
            serial.puts "#{device.query_state}!#{device.identification}!#{command}"
          end
          if action_type == Action::ActionTypes::RANGE
            rand(range_max)
          else
            I18n.t((["state_on","state_off"].fetch rand(2)).to_sym, :scope => [:action, :device, :turn_on_off, :state])
          end
        end
        
        ################################################################################
#        def state
#          if action_type == Action::ActionTypes::RANGE
#            rand(range_max)
#          else
#            I18n.t((["state_on","state_off"].fetch rand(2)).to_sym, :scope => [:action, :device, :turn_on_off, :state])
#          end
#        end

        ################################################################################
        def state_and_code
          if action_type == Action::ActionTypes::RANGE
            code = rand(range_max)
            {:code => code, :state => code}
          else
            code = ["state_on","state_off"].fetch rand(2)
            {:code => code, :state => I18n.t(code.to_sym, :scope => [:action, :device, :turn_on_off, :state])}
          end
        end
        
        ################################################################################
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
end
