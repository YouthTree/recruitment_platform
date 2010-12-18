class Position < ActiveRecord::Base
  belongs_to :team
  
  is_sluggable   :title
  is_convertable :paid_description, :general_description, :position_description, :applicant_description
  is_publishable
  
  belongs_to :team
  
  validates_presence_of :title, :short_description, :duration, :time_commitment, :team,
                        :paid_description, :general_description, :position_description, :applicant_description
  
  attr_accessible :title, :short_description, :paid, :duration, :time_commitment, :paid_description, :team_id,
                  :general_description, :position_description, :applicant_description, :published_at, :expires_at
  
  def self.expired
    where 'expires_at <= ?', Time.now
  end
  
  def self.unexpired
    where 'expires_at > ?', Time.now
  end

  def self.viewable
    unexpired.published
  end
  
  def expired?
    expires_at.present? && expires_at <= Time.now
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

  def humanised_status
    I18n.t status, :scope => 'ui.position_status'
  end

  def format
    'markdown'
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

