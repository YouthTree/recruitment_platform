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

# == Schema Info
#
# Table name: contents
#
#  id                :integer(4)      not null, primary key
#  content           :text
#  rendered_content  :text
#  key               :string(255)
#  title             :string(255)
#  type              :string(255)
#  created_at        :datetime
#  updated_at        :datetime
