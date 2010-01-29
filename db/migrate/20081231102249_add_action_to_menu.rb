class AddActionToMenu < ActiveRecord::Migration
  def self.up
    add_column :menus, :action, :string
  end

  def self.down
    remove_column :menus, :action
  end
end
