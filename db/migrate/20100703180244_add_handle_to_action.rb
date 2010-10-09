################################################################################
class AddHandleToAction < ActiveRecord::Migration

  ################################################################################
  def self.up
    add_column :actions, :handle, :text
  end

  ################################################################################
  def self.down
    remove_column :actions, :handle
  end
end