class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.string :name, :null => false
      t.string :website_url
      t.text   :description
      t.text   :rendered_description
      t.string :cached_slug
      t.string :logo
      t.timestamps
    end
    add_index :teams, :cached_slug
  end

  def self.down
    drop_table :teams
  end
end
