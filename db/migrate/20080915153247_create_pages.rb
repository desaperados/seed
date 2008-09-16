class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :title
      t.string :name
      t.string :description
      t.integer :position, :null => false
      t.integer :parent_id
      t.integer :paginate

      t.timestamps
    end
     Page.create(:title => "Home Page", :name => "Home", :description => "Default home page for a new seed installation")
     Page.create(:title => "About Page", :name => "About", :description => "A page where you could write what this site is about")
     Page.create(:title => "Special Page", :name => "Special Stuff", :description => "Stuff that you want only logged in users to see")
     Page.create(:title => "Another Page", :name => "More Stuff", :description => "Be Creative...")
  end

  def self.down
    drop_table :pages
  end
end
