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
      t.string :author
      t.integer :page_id
      t.integer :position
      t.integer :comments_count, :default => 0

      t.timestamps
    end
    Article.create(:title => "Welcome to Seed", :content => "This is your first seed article! \nLogin at http://yoursiteurl/login to make changes. \nUser: admin\nPassword: administrator", :page_id => 1)
  
    # Some test articles for development
     Article.create(:title => "Test article 1", :content => "An article for testing during development", :page_id => 2)
     Article.create(:title => "Test article 2", :content => "An article for testing during development", :page_id => 2)
     Article.create(:title => "Test article 3", :content => "An article for testing during development", :page_id => 2)
     Article.create(:title => "Test article 4", :content => "An article for testing during development", :page_id => 2)
     Article.create(:title => "Test article 5", :content => "An article for testing during development", :page_id => 2)
  end

  def self.down
    drop_table :articles
  end
end
