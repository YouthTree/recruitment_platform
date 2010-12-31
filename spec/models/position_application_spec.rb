require 'spec_helper'

describe PositionApplication do
  
  context 'associations' do
    specify { should belong_to :position }
    specify { should have_many :questions, :through => :position }
    specify { should have_one  :email_address, :as => :addressable }
    specify { should accept_nested_attributes_for :email_address }

    it 'should automatically set the email address to be a relationship' do
      PositionApplication.new.email_address.should be_present
    end

  end
  
  context 'validations' do

    specify { should validate_presence_of :full_name, :email_address, :phone }
    specify { should validate_associated :email_address }
    
    describe 'validating the answers' do
      
      let(:subject) { PositionApplication.make }
      
      it 'should be invalid when answers is invalid' do
        stub(subject).answers.stub!.valid? { false }
        should_not be_valid
        subject.errors[:answers].should be_present
      end
      
      it 'should be valid when answers is valid' do
        stub(subject).answers.stub!.valid? { true }
        should be_valid
        subject.errors[:answers].should be_blank
      end
      
    end
    
  end
  
  context 'accessible attributes' do
    specify { should allow_mass_assignment_of :full_name, :email_address_attributes, :phone, :answers }
    specify { should_not allow_mass_assignment_of :position_id, :position, :identifier }
  end

  describe '#answers' do

    its(:answers) { should be_kind_of Answers }

    it 'should return the same object' do
      old_object = subject.answers
      subject.answers.should be_equal(old_object)
    end

    its('answers.application') { should == subject }

  end

  describe '#answers=' do

    let(:attributes) { {:question_1 => 'Yes'} }

    it 'should call attributes= on the answer attribute' do
      mock(subject).answers.mock!.attributes = attributes
      subject.answers = attributes
    end

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