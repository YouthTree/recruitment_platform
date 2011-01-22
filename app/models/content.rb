class Content < ActiveRecord::Base
  include MarkdownFormattedModel

  attr_accessible :content, :key, :title, :type

  validates_presence_of :key

  is_convertable :content
  is_publishable

  def self.[](key)
    where(:key => key.to_s).first
  end

end
