#!/usr/bin/env ruby

################################################################################
ENV["RAILS_ENV"] ||= 'development'
require File.dirname(__FILE__) + '/../../../config/environment'
require File.dirname(__FILE__) + '/writer.rb'

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
        # Endless loop over all tasks.
        # Loop infinito sobre as tarefas.
        loop do
          # Finds new tasks.
          # Encontra nova tarefas.
          if @house
            tasks = Task.find_all_by_house_id_and_status house.id, Serial::Status::NEW
          else
            tasks = Task.all :conditions => {:status => Serial::Status::NEW}
          end

          # Sleeps for a while if there are no tasks for the moment.
          # Dorme por um período de tempo caso não haja tarejas no momento.
          if tasks.empty?
            sleep_for_a_while
          else
            # Found tasks, so it updates its state to 'WORKING' and write it through the serial port.
            # Encontrou tarefas, então é atualizado o seu estado e é enviado a tarefa a porta serial.
            tasks.each {|task| task.update_attribute('status', Serial::Status::WORKING) and Serial::Agent::Writer.write(task)}

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
options = {}

unless ARGV[0].blank?
  options.merge! :house => House.find(ARGV[0])
end

agent = Serial::Agent::NewTasker.new options

agent.listen