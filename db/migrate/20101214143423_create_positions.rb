class CreatePositions < ActiveRecord::Migration
  def self.up
    create_table :positions do |t|
      t.string     :title
      t.text       :short_description
      t.belongs_to :team
      t.boolean    :paid, :default => false
      t.string     :duration
      t.decimal    :time_commitment      
      # Content fields, oh my!
      t.text :rendered_paid_description
      t.text :rendered_general_description
      t.text :rendered_position_description
      t.text :rendered_application_description
      t.text :general_description
      t.text :position_description
      t.text :application_description
      t.text :paid_description
      # Track when it goes live / expires
      t.datetime :published_at
      t.datetime :expires_at
      # Give it a slug
      t.string :cached_slug
      t.timestamps
    end
    add_index :positions, :cached_slug
  end

  def self.down
    drop_table :positions
  end
end
