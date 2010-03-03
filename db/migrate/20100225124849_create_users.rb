class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email,                      :null => false
      t.string :username,               :null => false
      t.string :password,               :null => false
      t.string  :name,                  :null => true
      t.boolean :active,                :null => false, :default => 1
      t.string  :locale,                :null => false, :default => "en"
      t.string  :time_zone,             :null => false, :default => "Brasilia"
      t.string  :style,                 :null => false, :default => "blue"
    end
  end

  def self.down
    drop_table :users
  end
end
