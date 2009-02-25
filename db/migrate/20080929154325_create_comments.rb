class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :name
      t.string :email
      t.string :website
      t.text :comment
      t.string :user_ip
      t.string :user_agent
      t.string :referrer
      t.boolean :approved, :default => false, :null => false
      t.integer :post_id

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
