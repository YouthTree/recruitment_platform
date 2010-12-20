class User < ActiveRecord::Base

  devise :imap_authenticatable, :rememberable, :trackable, :timeoutable

  attr_accessible :email, :password, :remember_me

  validates_presence_of   :email, :allow_blank => true
  validates_uniqueness_of :email, :case_sensitive => false, :allow_blank => true
  validates_format_of     :email, :with => Devise.email_regexp, :message => :invalid_email, :allow_blank => true

end
