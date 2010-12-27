class CreatePositionApplications < ActiveRecord::Migration
  def self.up
    create_table :position_applications do |t|
      t.belongs_to :position
      t.string :full_name
      t.string :email
      t.string :phone
      t.string :identifier

      t.timestamps
    end
  end

  def self.down
    drop_table :position_applications
  end
end
