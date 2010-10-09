################################################################################
class CreateHouses < ActiveRecord::Migration

  ################################################################################
  def self.up
    create_table :houses do |t|
      t.references  :user,        :null => false, :foreign_key => {:dependent => :delete}
      t.string      :name,        :null => false
      t.text        :description

      t.timestamps
    end
  end

  ################################################################################
  def self.down
    drop_table :houses
  end
end