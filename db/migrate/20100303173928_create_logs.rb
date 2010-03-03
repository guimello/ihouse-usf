class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.references :house,    :null => false, :foreign_key => {:dependent => :delete}
      t.references :loggable, :polymorphic => {:default => "Action"}
      t.string :action, :null => false
      t.datetime :created_at, :null => false
    end
  end

  def self.down
    drop_table :logs
  end
end
