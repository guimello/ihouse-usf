################################################################################
class CreateTasks < ActiveRecord::Migration
  
  ################################################################################
  def self.up
    create_table :tasks do |t|
      t.integer     :key,       :null => false
      t.references  :house,     :null => false, :foreign_key => {:dependent => :delete}
      t.text        :operation, :null => false
      t.string      :status,    :null => false, :default => Serial::Status::NEW

      t.timestamps
    end

    add_index :tasks, :key, :unique => true
  end

  ################################################################################
  def self.down
    drop_table :tasks
  end
end