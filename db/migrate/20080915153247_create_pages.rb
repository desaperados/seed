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
     Page.create(:title => "Home Page", :name => "Home")
     Page.create(:title => "About Page", :name => "About")
     Page.create(:title => "Special Page", :name => "Special")
     Page.create(:title => "Great Page", :name => "Great Stuff")
  end

  def self.down
    drop_table :pages
  end
end
