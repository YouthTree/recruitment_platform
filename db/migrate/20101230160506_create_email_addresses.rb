class CreateEmailAddresses < ActiveRecord::Migration
  def self.up
    create_table :email_addresses do |t|
      t.string :email
      t.belongs_to :addressable, :polymorphic => true
      t.timestamps
    end
    add_index :email_addresses, [:addressable_id, :addressable_type]
  end

  def self.down
    drop_table :email_addresses
  end
end
