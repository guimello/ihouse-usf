################################################################################
module Serial

  ################################################################################
  module Devices

    ################################################################################
    def self.included(klass)
      klass.class_eval do

        ################################################################################
        def find_actions
          task = Task.create! :house => self.house,
                              :operation => {
                                :sent => {
                                  :device_identification => self.identification,
                                  :find_actions => 912
                                }
                              }

          task.wait_for_response

          response = normalize_response task.answered_find_actions

          index = 0
          actions = []
          begin
            action_type = case response[index + 2]
                          when '0'
                            ActionTypes::TURN_ON_OFF
                          when '1'
                            ActionTypes::RANGE
                          end
            action = Action.new(  :device => self,
                                    :action_type => action_type,
                                    :command => response[index],
                                    :query_state => response[index + 1])
            if action.range?
              action.range_min = response[index + 3]
              action.range_max = response[index + 4]

              index += 2
            else
              # TODO: get the device class (device_class) when choose icons accordingly
              action.handle.display_icon_on = 'lights-on'
              action.handle.display_icon_off = 'lights-off'
            end

            actions << action
            index += 3
          end while index < response.size

          task.destroy
          actions
        end

        ################################################################################
        def self.discover(house)
          task = Task.create! :house => house,
                              :operation => {
                                :sent => {
                                  :discover => 911 # Discover code.
                                }
                              }

          task.wait_for_response
          
          response = normalize_response task.answered_discover_query

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

        ################################################################################
        private

        ################################################################################
        def normalize_response(response)
          response = response.split '!'
          response[0] = ''
          response[response.size() -1] = response.last.sub '#', ''
          response.reject! {|value| value.blank?}
          response
        end
      end
    end
  end
end