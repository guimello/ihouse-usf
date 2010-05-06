class AddKnownDeviceToDevice < ActiveRecord::Migration
  def self.up
		add_column :devices, :known_device_id, :integer, :null => true
		add_foreign_key(:devices, :known_devices, :dependent => :delete)
  end

  def self.down
  end
end
