class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    
    create_table :users do |t|
      t.imap_authenticatable
      t.rememberable
      t.trackable
      t.timestamps
    end

    add_index :users, :email, :unique => true
  end

  def self.down
    drop_table :users
  end
end
