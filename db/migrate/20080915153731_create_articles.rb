class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :title
      t.string :content
      t.integer :page_id
      t.integer :position

      t.timestamps
    end
    Article.create(:title => "Welcome to Seed", :content => "This is your first seed article! Edit or delete this article, Add a new Article or even add a new Page", :page_id => 1)
  end

  def self.down
    drop_table :articles
  end
end
