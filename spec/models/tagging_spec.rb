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

require 'spec_helper'

describe Tagging do
  
  context 'associations' do
    it { should belong_to :tag }
    it { should belong_to :taggable, :polymorphic => true }
  end
  
end
