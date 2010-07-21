################################################################################
require 'serialport'

################################################################################
module Serial
  ################################################################################
  class Reader   
    
    ################################################################################
    attr_accessor :serial
    
    ################################################################################
    def initialize(options = {})
      @serial = SerialPort.new options[:port], 9600, 8, 1, SerialPort::NONE
      @house = options[:house]
    end
    
    ################################################################################
    def listen
      loop do
        Thread.new self, @serial.gets do |reader, message|
          parser = Parser.new :query => message        
          reader.simulate :device_identification => parser.device_identification,
                   :action_command => parser.action_command,
                   :command_type => parser.command_type
        end        
      end
    end
    
    ################################################################################
    def simulate(options = {})
      device = @house.devices.find_by_identification options[:device_identification]
      raise Serial::Error::UnknownSerialError, 'error no device' unless device
      
      action = device.actions.find_by_command options[:action_command]
      raise Serial::Error::UnknownSerialError, 'error no action' unless action
            
      if Device.query_states.map(&:query_state).include? options[:command_type]
        simulate_query_state :action => action
      end
    end
    
    ################################################################################
    def simulate_query_state(options = {})
      return rand(options[:action].range_max) if options[:action].action_type == Action::ActionTypes::RANGE
    end
    
    ################################################################################
    private :simulate, :simulate_query_state
  end
end
