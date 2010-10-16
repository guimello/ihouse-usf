#!/usr/bin/env ruby

################################################################################
ENV["RAILS_ENV"] = ARGV[0] || 'development'
require File.dirname(__FILE__) +  '/../../../config/environment'

################################################################################
module Serial
  ################################################################################
  module Agent
    ################################################################################
    class Reader

      ################################################################################
      attr_accessor :serial, :simulate

      ################################################################################
      def initialize(options = {})
        @serial = SerialPort.new options[:port], 9600, 8, 1, SerialPort::NONE
        @simulate = options[:simulate]
      end

      ################################################################################
      def listen
        loop do
          Thread.new self, @serial.gets do |reader, message|
            parser = Parser.new :query => message.strip

            if parser.pic_answered?
              task = Task.find_by_key parser.key

              task.operation.answered = parser.message
              task.status = Serial::Status::ANSWERED
              task.save!
            elsif simulate
              Serial::Agent::Writer.write simulate_message(Task.find_by_key(parser.key))
            end
          end
        end
      end

      ################################################################################
      private

      ################################################################################
      def simulate_message(task)
        simulator = Serial::Agent::Simulator.new task
        simulator.simulate_message
      end
    end
  end
end

################################################################################
serial = YAML::load(File.read(File.dirname(__FILE__) + '/../../../config/serial_reader.yml'))
reader = Serial::Agent::Reader.new :port => serial['reader']['port'], :simulate => (serial['reader']['simulate'] == true)
reader.listen