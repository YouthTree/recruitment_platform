class ChangeTimeCommitmentOnPosition < ActiveRecord::Migration
  def self.up
    change_column :positions, :time_commitment, :integer
  end

  def self.down
    change_column :positions, :time_commitment, :decimal
  end
end
