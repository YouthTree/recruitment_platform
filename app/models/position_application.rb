class PositionApplication < ActiveRecord::Base
  
  belongs_to :position
  has_many   :questions, :through => :position
  
  attr_accessible :full_name, :email, :phone, :answers
  
  validates_presence_of :full_name, :email, :phone
  validates_format_of   :email, :with => Devise.email_regexp
  validates_associated  :answers

  serialize :raw_answers

  def answers
    @answers ||= Answers.new(self)
  end
  
  def answers=(value)
    answers.attributes = value
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

