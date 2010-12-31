class PositionApplication < ActiveRecord::Base
  
  belongs_to :position
  has_many   :questions, :through => :position
  has_one    :email_address, :as => :addressable, :dependent => :destroy
  
  accepts_nested_attributes_for :email_address
  
  attr_accessible :full_name, :email_address_attributes, :phone, :answers

  validates_presence_of :full_name, :email_address, :phone
  validates_associated  :answers, :email_address

  serialize :raw_answers

  after_initialize :setup_default_email_address
  after_create     :send_notification_email

  def answers
    @answers ||= Answers.new(self)
  end
  
  def answers=(value)
    answers.attributes = value
  end
  
  protected

  def setup_default_email_address
    # Setup the default email
    build_email_address if email_address.blank?
  end

  def send_notification_email
    PositionNotifier.application_received(self).deliver
  end

end

# == Schema Information
#
# Table name: position_applications
#
#  id          :integer         not null, primary key
#  position_id :integer
#  full_name   :string(255)
#  email       :string(255)
#  phone       :string(255)
#  identifier  :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  raw_answers :text
#

