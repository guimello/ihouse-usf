################################################################################
class CreateKnownDevice < ActiveRecord::Migration

  ################################################################################
  def self.up
    create_table :known_devices do |t|
      t.string :device_class, :null => false
      t.string :display_icon, :null => false

      t.timestamps
    end
  end

  ################################################################################
  def self.down
    drop_table :known_device
  end
end