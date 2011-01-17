class AddStateToPositionApplications < ActiveRecord::Migration
  def self.up
    add_column :position_applications, :state, :string
    add_index :position_applications, :state
  end

  def self.down
    remove_column :position_applications, :state
  end
end
