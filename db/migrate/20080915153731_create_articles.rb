class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :title
      t.string :content
      t.string :video
      t.string :article_type, :default => "article"
      t.string :imagesize
      t.string :imageposition
      t.boolean :commentable, :default => true
      t.integer :page_id
      t.integer :position

      t.timestamps
    end
    Article.create(:title => "Welcome to Seed", :content => "This is your first seed article! \nLogin using the link in the bottom right corner to make changes. \nUser: admin\nPassword: administrator", :page_id => 1)
  end

  def self.down
    drop_table :articles
  end
end
