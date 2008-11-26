class RemoveCommentsCountFromArticles < ActiveRecord::Migration
  def self.up
    remove_column :articles, :comments_count
  end

  def self.down
    add_column :articles, :comments_count, :integer, :default => 0
  end
end
