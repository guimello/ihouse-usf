require 'rubygems'
require 'serialport'

sp = SerialPort.new '/dev/pts/4', 9600, 8, 1, SerialPort::NONE

puts 'lets read'
while true do
  #puts "=> #{sp.read 1}" 
  Thread.new sp.gets do |message|
    puts "Thread => #{message}"
  end 
  puts 'going to be ready again'
  #puts $_ 
end

sp.close

#require "/usr/lib/ruby/gems/1.8/gems/ruby-serialport-0.7.0/lib/serialport.so"




#sp = SerialPort.new '/dev/pts/4', 9600, 8, 1, SerialPort::NONE

#open("/dev/tty", "r+") { |tty|
#  tty.sync = true
#  Thread.new {
#    while true do
#      puts 'prin'
#      tty.printf("%c", sp.getc)
#    end
#  }
#  while (l = tty.gets) do
#    puts 'gets'
#    sp.write(l.sub("\n", "\r"))
#  end
#}

#sp.close
