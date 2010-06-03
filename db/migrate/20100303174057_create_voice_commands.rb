class CreateVoiceCommands < ActiveRecord::Migration
  def self.up
    create_table :voice_commands do |t|
      t.string  :speak, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :voice_commands
  end
end
