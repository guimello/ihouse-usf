require "#{Rails.root}/lib/serial/simulator.rb"

serial = Serial::Simulator.new :port => '/dev/pts/4', :house => House.first

serial.listen
