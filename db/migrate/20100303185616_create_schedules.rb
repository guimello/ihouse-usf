class CreateSchedules < ActiveRecord::Migration
  def self.up
    create_table :schedules do |t|
      t.references :action,   :null => false, :foreign_key => {:dependent => :delete}
			t.timestamps
    end
  end

  def self.down
    drop_table :schedules
  end
end
