class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.string :video
      t.string :article_type, :default => "article"
      t.string :imagesize
      t.string :imageposition
      t.boolean :commentable, :default => true
      t.string :author
      t.integer :page_id
      t.integer :position
      t.integer :comments_count, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
