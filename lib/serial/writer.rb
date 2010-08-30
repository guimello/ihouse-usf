################################################################################
module Serial
  ################################################################################
  class Writer   

    ################################################################################
    # Attributes.
    attr_reader :task
    
    ################################################################################
    def self.write(task)
      serial_port = SerialPort.new self.port, 9600, 8, 1, SerialPort::NONE
      puts task.operation.sent[:message]
      serial_port.puts task.operation.sent[:message]
      serial_port.close
    end

    ################################################################################
    def self.port
      serial = YAML::load(File.read(File.dirname(__FILE__) + '/../../config/serial_writer.yml'))
      serial['writer']['port']
    end
  end
end