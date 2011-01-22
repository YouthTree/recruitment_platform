# == Schema Information
#
# Table name: tags
#
#  id   :integer         not null, primary key
#  name :string(255)
#

class Tag < ActiveRecord::Base
  
  has_many :taggings, :dependent => :destroy
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def self.normalise_tag(text)
    text.to_s.to_url
  end
  
  def self.normalise_tag_list(text)
    base_tags = text.to_s.split(",").flatten
    base_tags.reject(&:blank?).map do |t|
      normalise_tag t
    end.uniq
  end
  
  def self.from_list(text)
    list       = normalise_tag_list(text)
    known_tags = where(:name => list).all.inject({}) do |acc, model|
      acc[model.name] = model
      acc
    end
    list.map do |tag|
      known_tags[tag] || Tag.create!(:name => tag)
    end
  end
  
  def self.to_list
    all.map(&:name).join(", ")
  end
  
end
