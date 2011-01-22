class AddSearchableIdentifierToPositionApplications < ActiveRecord::Migration
  def self.up
    add_column :position_applications, :searchable_identifier, :string
    PositionApplication.reset_column_information
    PositionApplication.find_each do |pa|
      next if pa.searchable_identifier.present?
      pa.update_attribute :searchable_identifier, pa.id.to_s
    end
  end

  def self.down
    remove_column :position_applications, :searchable_identifier
  end
end
