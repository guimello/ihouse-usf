#!/usr/bin/env ruby

################################################################################
ENV["RAILS_ENV"] = ARGV[0] || 'development'
require File.dirname(__FILE__) +  '/../config/environment'


serial_port = SerialPort.new '/dev/tty.usbserial', 9600, 8, 1, SerialPort::NONE

#serial_port.puts '#12!2!1!1!0#'
serial_port.puts '#95!3!1!1!1#'

loop { puts serial_port.gets.strip.match(/#(\w)+(!|\w)*#/) }
#loop { puts serial_port.gets.strip }

serial_port.close


##########################################################################
#
#
#3.times { puts "Em Ruby tudo é objeto!" }
#
#class Fixnum
#
#  def mais(numero)
#    self.+ numero
#  end
#
#end
#
#puts 5.mais 6
#
#
#vetor_de_strings = %w{Java C Ruby PHP}.map do |linguagem|
#
#  linguagem == 'Ruby' ?
#   'Blocos em Ruby são importantes.' :
#   linguagem
#
#end
#
#puts vetor_de_strings.inspect
#mensagem = 'sd'
#
#SerialPort.new  '/dev/tty.usbserial',
#                9600,
#                8,
#                1,
#                SerialPort::NONE do |serial|
#  serial.puts 'iHouse USF'
#  mensagem = serial.gets
#end
#
#
#mensagem