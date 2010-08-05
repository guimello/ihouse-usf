################################################################################
require 'serialport'

################################################################################
module Serial
  ################################################################################
  class Writer   
    
    ################################################################################
    def self.write(message)
      communication_key = Writer.generate_communication_key
      
      SerialPort.new $serial_port_writer, 9600, 8, 1, SerialPort::NONE do |serial|
        serial.puts "#{communication_key}!#{message}"
      end
      
      communication_key
    end
    
    ################################################################################
    def self.generate_communication_key
      (t = Time.now.to_f.to_s.gsub('.','')).length < 15 ? t + ('0' * (15 - t.length)) : t
    end   
  end
end
