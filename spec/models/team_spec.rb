require 'spec_helper'

describe Team do
  
  context 'associations' do
    it { should have_many :positions }
  end
  
  context 'validations' do
    it { should validate_presence_of :name, :website_url, :description }
    it { should allow_values_for :website_url, 'http://google.com/', 'http://youthtree.org.au/something', 'http://some-random.web/test?page=index' }
  end
  
  context 'accessible attributes' do
    it { should allow_mass_assignment_of :name, :website_url, :description }
    it { should_not allow_mass_assignment_of :rendered_description, :cached_slug }
  end
  
  it_should_behave_like 'a markdown formatted model'
  
  context 'slug generation' do
    
    it 'should automatically generate the slug' do
      Team.make!(:name => 'Big Help Mob').to_param.should == 'big-help-mob'
    end
    
    it 'should generate sequential slugs' do
      Team.make!(:name => 'something').to_param.should == 'something'
      Team.make!(:name => 'something').to_param.should == 'something--1'
    end
    
  end
  
end
