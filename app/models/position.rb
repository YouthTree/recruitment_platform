class Position < ActiveRecord::Base
  include MarkdownFormattedModel

  TIME_COMMITMENTS = [:'1_hour', :'2_to_3_hours', :a_full_day, :a_couple_of_days, :full_time]

  scope :with_questions, includes(:position_questions => :question)

  attr_accessor :next_question_id # Used for showing a question select

  has_many :position_questions, :dependent => :destroy, :autosave => true do

    def ordered
      if loaded?
        sort_by { |i| i.order_position || 0 }
      else
        order("#{quoted_table_name}.order_position ASC")
      end
    end

    def next_order_position
      if loaded?
        base = map  { |r| r.order_position || 0 }.max
      else
        base = maximum(:order_position) || 0
      end
      base + 1
    end

  end

  has_many :questions, :through => :position_questions

  has_many :applications, :class_name => 'PositionApplication'

  has_many :contact_emails, :class_name => 'EmailAddress', :as => :addressable, :dependent => :destroy

  belongs_to :team
  
  accepts_nested_attributes_for :position_questions, :allow_destroy => true
  accepts_nested_attributes_for :contact_emails, :allow_destroy => true, :reject_if => lambda { |a| a[:email].blank? }

  is_sluggable   :title, :use_cache => false
  is_convertable :paid_description, :general_description, :position_description, :applicant_description
  is_publishable
  
  validates_presence_of :title, :short_description, :duration, :time_commitment, :team,
                        :general_description, :position_description, :applicant_description

  validates_presence_of :paid_description, :if => :paid?

  validates_presence_of :contact_emails, :if => :published?

  validates_associated  :contact_emails

  validate :ensure_published_at_is_valid

  validates_inclusion_of :time_commitment, :in => TIME_COMMITMENTS

  attr_accessible :title, :short_description, :paid, :duration, :time_commitment, :paid_description, :team_id,
                  :general_description, :position_description, :applicant_description, :published_at, :expires_at,
                  :position_questions_attributes, :next_question_id, :contact_emails_attributes
  
  before_validation :setup_child_parents

  acts_as_indexed :fields => [:title, :short_description, :position_description, :applicant_description, :paid_description],
    :if => lambda { |r| r.viewable? }

  def self.expired
    where "#{quoted_table_name}.expires_at <= ?", Time.now
  end
  
  def self.unexpired
    where "#{quoted_table_name}.expires_at > ?", Time.now
  end

  def self.viewable
    unexpired.published
  end
  
  def self.search(params = {})
    PositionSearch.new viewable, params
  end

  def expired?
    expires_at.present? && expires_at <= Time.now
  end
  
  def viewable?
    published? && !expired?
  end

  def status
    if !published?
      :draft
    elsif expired?
      :expired
    else
      :published
    end
  end

  def human_status
    I18n.t status, :scope => 'ui.position_status', :default => status.to_s.humanize
  end

  def time_commitment
    (value = read_attribute(:time_commitment)) and TIME_COMMITMENTS[value]
  end

  def time_commitment=(value)
    write_attribute(:time_commitment, value && TIME_COMMITMENTS.index(value.to_sym))
  end

  def human_time_commitment
    return '' if time_commitment.blank?
    time_commitment.to_s.humanize
  end
  
  def to_application_reporter(options = {})
    PositionApplicationReporter.new self, options
  end

  protected
  
  def ensure_published_at_is_valid
    if expires_at.present? && published_at.present? && expires_at <= published_at
      errors.add :expires_at, :must_be_ordered_correctly
    end
  end
  
  def setup_child_parents
    position_questions.each { |pq| pq.position = self }
  end

end

# == Schema Information
#
# Table name: positions
#
#  id                             :integer         not null, primary key
#  title                          :string(255)
#  short_description              :text
#  team_id                        :integer
#  paid                           :boolean         default(FALSE)
#  duration                       :string(255)
#  time_commitment                :decimal(, )
#  rendered_paid_description      :text
#  rendered_general_description   :text
#  rendered_position_description  :text
#  rendered_applicant_description :text
#  general_description            :text
#  position_description           :text
#  applicant_description          :text
#  paid_description               :text
#  published_at                   :datetime
#  expires_at                     :datetime
#  cached_slug                    :string(255)
#  created_at                     :datetime
#  updated_at                     :datetime
#

