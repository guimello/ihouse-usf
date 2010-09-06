################################################################################
module Serial

  ################################################################################
  module Devices

    ################################################################################
    def self.included(klass)
      klass.class_eval do

        ################################################################################
        def self.discover(house)
          task = Task.create! :house => house,
                          :operation => {
                            :sent => {
                              :discover => 911 # Discover code.
                            }
                          }

          task.wait_for_response
          response = task.answered_discover_query

          response = response.split '!'
          response[0] = ''
          response[response.size() -1] = response.last.sub '#', ''
          response.reject! {|value| value.blank?}

          devices = []
          response.each_with_index do |value, index|
            next if(index % 2 != 0)

            device_class =  case value
                            when '1'
                              'lamp'
                            when '2'
                              'fan'
                            when '3'
                              'tv'
                            when '4'
                              'thermo'
                            end

            devices << Device.new(:house => house, :device_class => device_class, :identification => response[index + 1])
          end

          task.destroy
          devices
        end
      end
    end
  end
end