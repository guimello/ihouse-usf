class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.references  :user,      :null => false, :foreign_key => {:dependent => :delete}
      t.references  :loggable,  :polymorphic => {:default => 'Action'}
      t.text        :custom,   :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :logs
  end
end
