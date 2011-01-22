# == Schema Information
#
# Table name: tags
#
#  id   :integer         not null, primary key
#  name :string(255)
#

require 'spec_helper'

describe Tag do
  
  context 'associations' do
    it { should have_many :taggings, :dependent => :destroy }
  end
  
  context 'validations' do
    before(:each) { Tag.create :name => 'test-tag' }
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name}
  end
  
  describe '.normalise_tag' do
    
    it 'should strip white space' do
      Tag.normalise_tag('     ').should == ''
      Tag.normalise_tag('    a').should == 'a'
      Tag.normalise_tag(' b   ').should == 'b'
      Tag.normalise_tag(' bc  ').should == 'bc'
      Tag.normalise_tag('   a ').should == 'a'
    end
    
    it 'should correctly format basic strings' do
      Tag.normalise_tag('abc').should == 'abc'
      Tag.normalise_tag('a and b and c').should == 'a-and-b-and-c'
      Tag.normalise_tag('xzy').should == 'xzy'
      Tag.normalise_tag('#awesomesauce').should == 'number-awesomesauce'
      Tag.normalise_tag('recruitment, eh').should == 'recruitment-eh'
      Tag.normalise_tag('an-example').should == 'an-example'
    end
    
    it 'should correctly format complex strings' do
      Tag.normalise_tag('testing purposes.').should == 'testing-purposes'
      Tag.normalise_tag('youthtree inc. ltd.').should == 'youthtree-inc-ltd'
      Tag.normalise_tag('ohai there!').should == 'ohai-there'
      Tag.normalise_tag('hi, goodbye, cya later').should == 'hi-goodbye-cya-later'
      Tag.normalise_tag('a&b').should == 'a-and-b'
    end
    
  end
  
  describe '.normalise_tag_list' do
    
    it 'should use normalise_tag under the hook' do
      mock(Tag).normalise_tag('X') { 'y' }
      Tag.normalise_tag_list('X').should == %w(y)
    end
    
    it 'should correctly convert single list items' do
      Tag.normalise_tag_list('X').should == %w(x)
      Tag.normalise_tag_list('y').should == %w(y)
      Tag.normalise_tag_list('a b').should == %w(a-b)
    end
    
    it 'should remove duplicates' do
      Tag.normalise_tag_list('a,b,a').should == %w(a b)
      Tag.normalise_tag_list('a, a').should == %w(a)
      Tag.normalise_tag_list('a,b,b').should == %w(a b)
      Tag.normalise_tag_list('A,b, a').should == %w(a b)
      Tag.normalise_tag_list('a-b, a b').should == %w(a-b)
    end
    
    it 'should remove blank tags' do
      Tag.normalise_tag_list('a-b,,,,,,').should == %w(a-b)
      Tag.normalise_tag_list('a,          ').should == %w(a)
      Tag.normalise_tag_list('a,       , a').should == %w(a)
    end
    
  end
  
  describe 'getting tags from a list' do
    
    it 'should use normalise tag list' do
      mock(Tag).normalise_tag_list('d, e, f') { %w(x y z)}
      Tag.from_list('d, e, f').map(&:name).should == %w(x y z)
    end
    
    it 'should create all unknown tags' do
      Tag.destroy_all
      tags = Tag.from_list('a, b')
      Tag.find_by_name('a').should == tags[0]
      Tag.find_by_name('b').should == tags[1]
      Tag.count.should == 2
    end
    
    it 'should reuse existing tags' do
      expect do
        tag_a = Tag.create!(:name => 'a')
        tag_b = Tag.create!(:name => 'b')
        tags  = Tag.from_list('a,b')
        tags[0].should == tag_a
        tags[1].should == tag_b
      end.to_not change(Team, :count)
    end
    
  end
  
  describe 'to list' do
    
    before(:each) { Tag.destroy_all }
    
    it 'should have the correct value for a single tag entry' do
      Tag.create! :name => 'my-tag'
      Tag.to_list.should == 'my-tag'
    end
    
    it 'should have the correct value for multiple tags' do
      Tag.create! :name => 'tag-one'
      Tag.create! :name => 'tag-two'
      Tag.create! :name => 'tag-three'
      Tag.to_list.should == 'tag-one, tag-two, tag-three'
    end
    
  end
  
end
