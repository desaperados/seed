class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :title
      t.string :name
      t.string :description
      t.integer :position
      t.string :kind, :default => "articles"
      t.string :menu_type, :default => "primary"
      t.string :viewable_by, :default => "public"
      t.string :editable_by, :default => "all users"
      t.integer :parent_id
      t.integer :paginate
      t.integer :components_count, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
