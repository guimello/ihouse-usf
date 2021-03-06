################################################################################
class CreateActions < ActiveRecord::Migration

  ################################################################################
  def self.up
    create_table :actions do |t|
      t.references  :device,        :null => false, :foreign_key => {:dependent => :delete}
      t.integer     :command,       :null => false #commando a ser enviado para o controlador
      t.string      :action_type,   :null => false #tipo do comando (setar valor, faixa de valores)
      t.integer     :range_min,     :null => true #menor valor possível se possuir faixa de valores
      t.integer     :range_max,     :null => true #maior valor possível se possuir faixa de valores
      t.string      :name,          :null => true #to change default name (turn on, apply, start)
      t.integer     :query_state,   :null => false

      t.timestamps
    end
  end

  ################################################################################
  def self.down
    drop_table :actions
  end
end