class AddKnownActionToAction < ActiveRecord::Migration
  def self.up		
		add_column :actions, :known_action_id, :integer, :null => true
		add_foreign_key(:actions, :known_actions, :dependent => :delete)
  end

  def self.down
  end
end
