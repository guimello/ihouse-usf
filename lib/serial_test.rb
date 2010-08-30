#!/usr/bin/env ruby

ENV["RAILS_ENV"] ||= "development"
require File.dirname(__FILE__) + "/../config/environment"

require 'rubygems'
require 'serialport'


sp = SerialPort.new '/dev/ttys004', 9600, 8, 1, SerialPort::NONE

#device = Device.first

#m = "#{(t = Time.now.to_f.to_s.gsub('.','')).length < 15 ? t + ('0' * (15 - t.length)) : t }!#{device.query_state}!#{device.identification}!#{device.actions.first.command}$"
m = 'sdfsadf'
1.upto 10 do |i|    
  Thread.new sp, "#{m}" do |serial, message|
    puts "Thread => #{serial.puts(message)}"  
  end
end

sp.close
