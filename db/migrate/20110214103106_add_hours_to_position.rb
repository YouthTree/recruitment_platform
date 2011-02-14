class AddHoursToPosition < ActiveRecord::Migration
  
  EXISTING = [[1], [2, 5], [5, 10], [10, 15], [15, 20], [20, 40], [40]]
  
  def self.up
    add_column :positions, :minimum_hours, :integer
    add_column :positions, :maximum_hours, :integer
    Position.reset_column_information
    
    Position.transaction do
      Position.find_each do |position|
        next if position[:time_commitment].blank?
        current_value = EXISTING[position[:time_commitment]]
        next if current_value.blank?
        position.minimum_hours = current_value.first
        position.maximum_hours = current_value.last
        position.save :validate => false
      end
    end
    
    remove_column :positions, :time_commitment
    Position.reset_column_information
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration, "You can not revert the hours of a position."
  end
end
