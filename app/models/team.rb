class Team < ActiveRecord::Base
  
  is_convertable :description
  is_sluggable   :name
  
  attr_accessible :name, :website_url, :description
  
  validates_presence_of :name, :website_url, :description
  
  # Use markdown as a standard markup format for content since it
  # fufills the primary requirements in terms of copy paste etc.
  def format
    'markdown'
  end
  
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

