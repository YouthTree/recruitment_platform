# == Schema Information
#
# Table name: users
#
#  id                  :integer         not null, primary key
#  email               :string(255)     default(""), not null
#  remember_token      :string(255)
#  remember_created_at :datetime
#  sign_in_count       :integer         default(0)
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string(255)
#  last_sign_in_ip     :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

class User < ActiveRecord::Base

  devise :imap_authenticatable, :rememberable, :trackable, :timeoutable

  attr_accessible :email, :password, :remember_me

  validates_presence_of   :email, :allow_blank => true
  validates_uniqueness_of :email, :case_sensitive => false, :allow_blank => true
  validates_format_of     :email, :with => Devise.email_regexp, :message => :invalid_email, :allow_blank => true

end
