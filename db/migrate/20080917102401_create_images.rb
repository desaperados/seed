class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.integer :size
      t.string :article_type
      t.string :filename
      t.integer :height
      t.integer :width
      t.integer :parent_id
      t.string :thumbnail
      t.integer :article_id

      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
