class AddCustomToDevice < ActiveRecord::Migration
  def self.up
    add_column :devices, :custom, :text
  end

  def self.down
    remove_column :devices, :custom
  end
end
