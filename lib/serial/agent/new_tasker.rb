#!/usr/bin/env ruby

################################################################################
ENV["RAILS_ENV"] ||= 'development'
require File.dirname(__FILE__) + '/../../../config/environment'
require File.dirname(__FILE__) + '/../writer.rb'

################################################################################
module Serial
  ################################################################################
  module Agent
    ################################################################################
    class NewTasker

      ################################################################################
      attr_accessor :house

      ################################################################################
      def initialize(options = {})
        @house = options[:house]
      end

      ################################################################################
      def listen
        loop do
          tasks = Task.find_all_by_house_id_and_status house.id, Serial::Status::NEW

          if tasks.empty?
            sleep_for_a_while
          else
            tasks.each {|task| task.update_attribute('status', Serial::Status::WORKING) and Serial::Writer.write(task)}

            sleep_for_a_while
          end
        end
      end

      ################################################################################
      private

      ################################################################################
      def sleep_for_a_while
        begin
          sleep 3
        rescue
        end
      end
    end
  end
end

################################################################################
house_id  = ARGV[0] || raise('House id is required!')

house = House.find house_id
agent = Serial::Agent::NewTasker.new :house => house

agent.listen