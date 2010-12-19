class User < ActiveRecord::Base
  devise :imap_authenticatable, :rememberable, :trackable, :timeoutable

  attr_accessible :email, :password, :remember_me
end
