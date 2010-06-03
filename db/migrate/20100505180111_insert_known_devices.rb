class InsertKnownDevices < ActiveRecord::Migration
  def self.up
    KnownDevice.transaction do
      KnownDevice.create  :device_class => "lamp",
                                      :query_state => "state_lamp",
                                      :display_icon => "lights"

      KnownDevice.create  :device_class => "fan",
                                      :query_state => "state_fan",
                                      :display_icon => "fan"

      KnownDevice.create  :device_class => "tv",
                                      :query_state => "state_tv",
                                      :display_icon => "television"
    end
  end

  def self.down
    KnownDevice.delete_all
  end
end
