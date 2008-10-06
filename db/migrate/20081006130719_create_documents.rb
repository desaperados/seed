class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.string :name
      t.integer :size
      t.string :content_type
      t.string :filename
      t.integer :component_id

      t.timestamps
    end
  end

  def self.down
    drop_table :documents
  end
end
