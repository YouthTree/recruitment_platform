class AddOrderablePositionToPosition < ActiveRecord::Migration
  def self.up
    add_column :positions, :order_position, :integer
  end

  def self.down
    remove_column :positions, :order_position
  end
end
