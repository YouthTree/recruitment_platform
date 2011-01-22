# == Schema Information
#
# Table name: taggings
#
#  id            :integer         not null, primary key
#  tag_id        :integer
#  taggable_id   :integer
#  taggable_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :taggable, :polymorphic => true

  def self.tagged_ids_for(klass, tags)
    scope = includes(:tag)
    scope = scope.where(:tags => {:name => tags}, :taggable_type => klass.model_name)
    scope = scope.select('DISTINCT(taggable_id)')
    scope.all.map(&:taggable_id)
  end

end
