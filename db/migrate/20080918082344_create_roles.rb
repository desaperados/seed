class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name
      t.string :description
    end
    
    create_table :roles_users, :id => false do |t|
      t.belongs_to :role
      t.belongs_to :user
    end
  end

  def self.down
    drop_table :roles
    drop_table :roles_users
  end
end