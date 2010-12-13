class Team < ActiveRecord::Base
end

# == Schema Information
#
# Table name: teams
#
#  id                   :integer         not null, primary key
#  name                 :string(255)     not null
#  website_url          :string(255)
#  description          :text
#  rendered_description :text
#  cached_slug          :string(255)
#  logo                 :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

