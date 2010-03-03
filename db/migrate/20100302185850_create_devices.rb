class CreateDevices < ActiveRecord::Migration
  def self.up
    create_table :devices do |t|
      t.references :house,    :null => false, :foreign_key => {:dependent => :delete}
      t.string  :code,          :null => false
      t.string  :room,          :null => false
      t.string  :custom_name,   :null => true
      t.string :query_code,    :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :devices
  end
end
