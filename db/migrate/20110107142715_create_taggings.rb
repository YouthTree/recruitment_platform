class CreateTaggings < ActiveRecord::Migration
  def self.up
    create_table :taggings do |t|
      t.belongs_to :tag
      t.belongs_to :taggable, :polymorphic => true
      t.timestamps
    end
    add_index :taggings, [:tag_id]
    add_index :taggings, [:taggable_id, :taggable_type]
    add_index :taggings, [:tag_id, :taggable_id, :taggable_type]
  end

  def self.down
    drop_table :taggings
  end
end
