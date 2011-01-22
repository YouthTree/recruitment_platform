# == Schema Information
#
# Table name: email_addresses
#
#  id               :integer         not null, primary key
#  email            :string(255)
#  addressable_id   :integer
#  addressable_type :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe EmailAddress do
  
  context 'associations' do
    specify { should belong_to :addressable, :polymorphic => true }
  end
  
  context 'validations' do
    specify { should validate_presence_of :email }
    specify { should allow_values_for :email,  'test@example.com', 'web@youthtree.org.au', 'sutto@sutto.net' }
    specify { should_not allow_values_for :email, 'blah', nil, '', 'test @ example.com', 'google.com'  }
    specify { should validate_uniqueness_of :email, :scope => [:addressable_type, :addressable_id], :allow_blank => true }
  end
  
  context 'attribute accessibility' do
    specify { should allow_mass_assignment_of :email }
  end
  
  it 'should use the email method for to_s' do
    mock(subject).email { 'sutto@sutto.net' }
    subject.to_s.should == 'sutto@sutto.net'
  end
  
end
