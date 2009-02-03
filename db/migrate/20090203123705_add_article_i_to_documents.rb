class AddArticleIToDocuments < ActiveRecord::Migration
  def self.up
    add_column :documents, :article_id, :integer
  end

  def self.down
    remove_column :documents, :article_id
  end
end
