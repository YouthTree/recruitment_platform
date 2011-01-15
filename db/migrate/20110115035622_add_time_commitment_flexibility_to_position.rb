class AddTimeCommitmentFlexibilityToPosition < ActiveRecord::Migration
  def self.up
    add_column :positions, :time_commitment_flexibility, :string
  end

  def self.down
    remove_column :positions, :time_commitment_flexibility
  end
end
