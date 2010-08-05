class CreateDevices < ActiveRecord::Migration
  def self.up
    create_table :devices do |t|
      t.references :house,    :null => false, :foreign_key => {:dependent => :delete}
      t.string :device_class, :null => false
      t.string  :identification,          :null => false
      t.string  :room,          :null => false
      t.string  :name,   :null => true      
      t.timestamps
    end
  end

  def self.down
    drop_table :devices
  end
end
