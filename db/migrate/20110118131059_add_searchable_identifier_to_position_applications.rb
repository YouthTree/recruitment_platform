class AddSearchableIdentifierToPositionApplications < ActiveRecord::Migration
  def self.up
    add_column :position_applications, :searchable_identifier, :string
  end

  def self.down
    remove_column :position_applications, :searchable_identifier
  end
end
