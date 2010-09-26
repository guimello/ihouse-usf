################################################################################
module Serial
  ################################################################################
  class Writer   

    ################################################################################
    # Attributes.
    attr_reader :task
    
    ################################################################################
    def self.write(task_or_message)
      message = (task_or_message.is_a? Task) ? task_or_message.operation.sent[:message] : task_or_message
      serial_port = SerialPort.new self.port, 9600, 8, 1, SerialPort::NONE
      serial_port.puts message
      serial_port.close
    end

    ################################################################################
    def self.port
      serial = YAML::load(File.read(File.dirname(__FILE__) + '/../../config/serial_writer.yml'))
      serial['writer']['port']
    end
  end
end