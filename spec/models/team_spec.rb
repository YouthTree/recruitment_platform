require 'spec_helper'

describe Team do
  
  context 'validations' do
    
    it { should validate_presence_of :name, :website_url, :description }
    
    it { should allow_values_for :website_url, 'http://google.com/', 'http://youthtree.org.au/something', 'http://some-random.web/test?page=index' }
    
  end
  
  context 'content conversions' do
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

