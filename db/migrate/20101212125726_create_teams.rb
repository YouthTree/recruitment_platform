class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.string :name
      t.string :website_url
      t.test :description
      t.text :rendered_description
      t.string :cached_slug
      t.string :logo

      t.timestamps
    end
  end

  def self.down
    drop_table :teams
  end
end
