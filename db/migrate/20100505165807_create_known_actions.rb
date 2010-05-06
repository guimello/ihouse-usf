class CreateKnownActions < ActiveRecord::Migration
  def self.up
		create_table :known_actions do |t|
			t.string :command, :null => false
			t.string :action_type, :null => false			
			t.text :handle, :null => false
		end
  end

  def self.down
		drop_table :known_actions
  end
end
