class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :title
      t.string :name
      t.string :description
      t.integer :position
      t.string :kind
      t.string :menu_type, :default => "primary"
      t.string :viewable_by, :default => "public"
      t.string :editable_by, :default => "all users"
      t.string :permalink
      t.integer :parent_id
      t.integer :paginate
      t.integer :components_count, :default => 0

      t.timestamps
    end
     Page.create(:title => "Home Page", :menu_type => "primary", :kind => "articles", :name => "Home", :description => "Default home page for a new seed installation")
     Page.create(:title => "About Page", :menu_type => "primary",:kind => "articles", :name => "About", :description => "A page where you could write what this site is about")
     Page.create(:title => "News Page", :menu_type => "primary", :kind => "newsitems", :name => "News", :description => "A page for news items with dates and archive section")
     Page.create(:title => "Blog Page", :menu_type => "primary", :kind => "posts", :name => "Blog", :description => "Be Creative...")
     Page.create(:title => "Secondary Menu Default Page", :menu_type => "secondary", :kind => "articles", :name => "Secondary Default", :description => "Secondary Menu Default Page")
  end

  def self.down
    drop_table :pages
  end
end
