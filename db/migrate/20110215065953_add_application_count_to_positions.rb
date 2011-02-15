class AddApplicationCountToPositions < ActiveRecord::Migration
  def self.up
    add_column :positions, :submitted_applications_count, :integer, :default => 0
    Position.reset_column_information
    Position.find_each(&:generate_submitted_count!)
  end

  def self.down
    remove_column :positions, :submitted_applications_count
  end
end
