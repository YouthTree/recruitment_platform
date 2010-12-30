class RemoveEmailFromPositionApplications < ActiveRecord::Migration
  def self.up
    remove_column :position_applications, :email
  end

  def self.down
    add_column :position_applications, :email, :string
  end
end
