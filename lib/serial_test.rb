#!/usr/bin/env ruby

ENV["RAILS_ENV"] ||= "development"
require File.dirname(__FILE__) + "/../config/environment"

require 'rubygems'
require 'serialport'

sp = SerialPort.new '/dev/pts/4', 9600, 8, 1, SerialPort::NONE

device = Device.first

1.upto 10 do |i|
  #puts "=> #{sp.write('AT\r\n')}"  
  Thread.new sp, "#{(t = Time.now.to_f.to_s.gsub('.','')).length < 15 ? t + ('0' * (15 - t.length)) + '!' : t }!#{device.query_state}!#{device.identification}!#{device.actions.first.command}$" do |serial, message|
    puts "Thread => #{serial.puts(message)}"  
  end
end

sp.close
