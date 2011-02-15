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
  
  attr_accessible :full_name, :email_address_attributes, :phone, :answers, :state_event

  validates_presence_of :email_address, :unless => :new_record?
  validates_associated  :email_address, :unless => :new_record?

  validates_presence_of :full_name, :phone, :if => :submitted?
  validates_associated  :answers, :if => :submitted?

  serialize :raw_answers

  after_initialize :setup_default_email_address
  before_save      :generate_searchable_identifier
  after_update     :send_saved_email, :if => :should_send_saved_email?
  after_save       :update_parent_count
  after_destroy    :update_parent_count

  scope :submitted, where(:state => 'submitted')
  scope :created,   where(:state => 'created')
  scope :ordered,   order('updated_at DESC')

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

    after_transition :created => :submitted, :do => :send_submission_emails

  end

  def self.from_searchable_identifier!(identifier)
    where(:searchable_identifier => identifier).first.tap do |identifier|
      raise ActiveRecord::RecordNotFound if identifier.blank?
    end
  end

  def self.since(time)
    where(:created_at.gt => time)
  end

  def to_param
    searchable_identifier.presence || id
  end

  protected

  def setup_default_email_address
    build_email_address if email_address.blank? && !new_record?
  end

  def send_submission_emails
    PositionNotifier.application_received(self).deliver
    PositionNotifier.application_sent(self).deliver
  end

  def should_send_saved_email?
    !submitted? && email_address.email_changed?
  end

  def send_saved_email
    PositionNotifier.application_saved(self).deliver
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
  
  def update_parent_count
    position.generate_submitted_count! if position.present?
  end

end
