#!/usr/bin/env ruby

################################################################################
ENV["RAILS_ENV"] ||= 'development'
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
            parser = Parser.new :query => message
            task = Task.find_by_key parser.key

            message = simulate_message task if simulate
            
            task.operation.answered = message
            task.status = Serial::Status::ANSWERED
            task.save!
          end
        end
      end

      ################################################################################
      def simulate_message(task)
        device = Device.find_by_house_id_and_identification task.house.id, task.operation.sent[:device_identification]
        raise Serial::Error::UnknownSerialError, 'error no device' unless device

        action = device.actions.find_by_command task.operation.sent[:action_command]
        raise Serial::Error::UnknownSerialError, 'error no action' unless action

        unless task.operation.sent[:action_query_state].blank?
          message = case action.action_type
            when ActionTypes::RANGE
              rand(action.range_max)
            when ActionTypes::TURN_ON_OFF
              ['state_on', 'state_off'].fetch rand(2)
            end
        else
          # write code here
        end

        message = "##{task.key}!#{message}#"
      end

      ################################################################################
      private :simulate_message
    end
  end
end

################################################################################
serial = YAML::load(File.read(File.dirname(__FILE__) + '/../../../config/serial_reader.yml'))
reader = Serial::Agent::Reader.new :port => serial['reader']['port'], :simulate => (serial['reader']['simulate'] == true)
reader.listen