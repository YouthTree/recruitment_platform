class EmailAddress < ActiveRecord::Base
  
  validates_presence_of   :email
  validates_format_of     :email, :with => Devise.email_regexp
  validates_uniqueness_of :email, :scope => [:addressable_type, :addressable_id], :allow_blank => true
  
  belongs_to :addressable, :polymorphic => true
  
  def to_s
    email
  end
  
end
