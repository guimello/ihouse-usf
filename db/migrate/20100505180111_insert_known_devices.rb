################################################################################
class InsertKnownDevices < ActiveRecord::Migration

  ################################################################################
  def self.up
    KnownDevice.transaction do
      KnownDevice.create  :device_class => 'lamp',
                                      :display_icon => 'lights'

      KnownDevice.create  :device_class => 'fan',
                                      :display_icon => 'fan'

      KnownDevice.create  :device_class => 'tv',
                                      :display_icon => 'television'

      KnownDevice.create  :device_class => 'thermo',
                                      :display_icon => 'thermometer-red'
    end
  end

  ################################################################################
  def self.down
    KnownDevice.delete_all
  end
end