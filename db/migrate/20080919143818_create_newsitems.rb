class CreateNewsitems < ActiveRecord::Migration
  def self.up
    create_table :newsitems do |t|
      t.string :title
      t.string :content
      t.integer :position
      t.integer :page_id
      t.string :imagesize
      t.string :imageposition

      t.timestamps
    end
  end

  def self.down
    drop_table :newsitems
  end
end
