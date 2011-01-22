# == Schema Information
#
# Table name: position_applications
#
#  id                    :integer         not null, primary key
#  position_id           :integer
#  full_name             :string(255)
#  phone                 :string(255)
#  identifier            :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  raw_answers           :text
#  state                 :string(255)
#  searchable_identifier :string(255)
#

class PositionApplication < ActiveRecord::Base
  
  belongs_to :position
  has_many   :questions, :through => :position
  has_one    :email_address, :as => :addressable, :dependent => :destroy
  
  accepts_nested_attributes_for :email_address
  
  attr_accessible :full_name, :email_address_attributes, :phone, :answers

  validates_presence_of :full_name, :email_address, :phone, :if => :submitted?
  validates_associated  :answers, :email_address, :if => :submitted?

  serialize :raw_answers

  after_initialize :setup_default_email_address
  before_save      :generate_searchable_identifier


  def answers(force = false)
    @answers = nil if force
    @answers ||= Answers.new(self)
  end
  
  def answers=(value)
    answers.attributes = value
  end
  
  # The application state machine

  state_machine :state, :initial => :created do

    state :created
    state :submitted

    event :submit do
      transition :created => :submitted
    end

    after_transition :created => :submitted, :do => :send_notification_email

  end

  protected

  def setup_default_email_address
    # Setup the default email
    build_email_address if email_address.blank?
  end

  def send_notification_email
    PositionNotifier.application_received(self).deliver
  end

  def generate_searchable_identifier
    return if searchable_identifier.present?
    while searchable_identifier.blank? || searchable_identifier_taken?
      self.searchable_identifier = self.class.generate_random_token
    end
  end

  def searchable_identifier_taken?
    self.class.other_than(self).where(:searchable_identifier => searchable_identifier).exists?
  end

  def self.other_than(child)
    if child.new_record?
      scoped
    else
      where(:id.ne => child.id)
    end
  end

  def self.generate_random_token
    ActiveSupport::SecureRandom.hex(32)
  end

end
