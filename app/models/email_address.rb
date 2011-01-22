# == Schema Information
#
# Table name: email_addresses
#
#  id               :integer         not null, primary key
#  email            :string(255)
#  addressable_id   :integer
#  addressable_type :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class EmailAddress < ActiveRecord::Base
  
  validates_presence_of   :email
  validates_format_of     :email, :with => Devise.email_regexp
  validates_uniqueness_of :email, :scope => [:addressable_type, :addressable_id], :allow_blank => true
  
  belongs_to :addressable, :polymorphic => true
  
  def to_s
    email
  end
  
end
