class AddCustomPathToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :custom_path, :string
  end

  def self.down
    remove_column :pages, :custom_path
  end
end
