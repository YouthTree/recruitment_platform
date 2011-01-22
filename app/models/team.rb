class Team < ActiveRecord::Base
  include MarkdownFormattedModel
  
  is_convertable :description
  is_sluggable   :name, :use_cache => false
  
  attr_accessible :name, :website_url, :description
  
  validates_presence_of :name, :website_url, :description
  
  has_many :positions

end
