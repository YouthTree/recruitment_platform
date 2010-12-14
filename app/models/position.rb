class Position < ActiveRecord::Base
  belongs_to :team
end

# == Schema Information
#
# Table name: positions
#
#  id                               :integer         not null, primary key
#  title                            :string(255)
#  short_description                :text
#  team_id                          :integer
#  paid                             :boolean         default(FALSE)
#  duration                         :string(255)
#  time_commitment                  :decimal(, )
#  rendered_paid_description        :text
#  rendered_general_description     :text
#  rendered_position_description    :text
#  rendered_application_description :text
#  general_description              :text
#  position_description             :text
#  application_description          :text
#  paid_description                 :text
#  published_at                     :datetime
#  expires_at                       :datetime
#  cached_slug                      :string(255)
#  created_at                       :datetime
#  updated_at                       :datetime
#

