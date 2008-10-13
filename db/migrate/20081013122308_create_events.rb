class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.string :description
      t.string :location
      t.datetime :date
      t.boolean :all_day
      t.integer :page_id
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
