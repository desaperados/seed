class CreateComponents < ActiveRecord::Migration
  def self.up
    create_table :components do |t|
      t.string :title
      t.integer :page_id
      t.integer :source_page
      t.integer :limit
      t.integer :position
      t.string :order
      t.string :snippet_class

      t.timestamps
    end
  end

  def self.down
    drop_table :components
  end
end
