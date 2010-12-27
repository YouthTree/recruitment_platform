require 'spec_helper'

describe PositionApplication do
  
  context 'associations' do
    it { should belong_to :position }
    it { should have_many :questions, :through => :position }
  end
  
  context 'validations' do
    it { should validate_presence_of :full_name, :email, :phone }
    it { should allow_values_for :email,  'test@example.com', 'web@youthtree.org.au', 'sutto@sutto.net' }
    it { should_not allow_values_for :email, 'blah', nil, '', 'test @ example.com', 'google.com'  }
    
    describe 'validating the answers' do
      
      let(:subject) { PositionApplication.make }
      
      it 'should be invalid when answers is invalid' do
        stub(subject).answers.stub!.valid? { false }
        subject.should_not be_valid
        subject.errors[:answers].should be_present
      end
      
      it 'should be valid when answers is valid' do
        stub(subject).answers.stub!.valid? { true }
        subject.should be_valid
        subject.errors[:answers].should be_blank
      end
      
    end
    
  end
  
  context 'accessible attributes' do
    it { should allow_mass_assignment_of :full_name, :email, :phone, :answers }
    it { should_not allow_mass_assignment_of :position_id, :position, :identifier }
  end
  
end

# == Schema Information
#
# Table name: position_applications
#
#  id          :integer         not null, primary key
#  position_id :integer
#  full_name   :string(255)
#  email       :string(255)
#  phone       :string(255)
#  identifier  :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#