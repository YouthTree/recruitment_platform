class AddOrderablePositionToTeam < ActiveRecord::Migration
  def self.up
    add_column :teams, :order_position, :integer
  end

  def self.down
    remove_column :teams, :order_position
  end
end
