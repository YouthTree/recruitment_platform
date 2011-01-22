# == Schema Information
#
# Table name: position_applications
#
#  id                    :integer         not null, primary key
#  position_id           :integer
#  full_name             :string(255)
#  phone                 :string(255)
#  identifier            :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  raw_answers           :text
#  state                 :string(255)
#  searchable_identifier :string(255)
#

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

    describe 'when not submitted' do
      before(:each) { stub(subject).submitted? { false } }
      it { should_not validate_presence_of :full_name, :email_address, :phone }
      it { should_not validate_associated :email_address }
    end

    describe 'when submitted' do
      before(:each) { stub(subject).submitted? { true } }
      it { should validate_presence_of :full_name, :email_address, :phone }
      it { should validate_associated :email_address }
    end
    
    describe 'validating the answers' do
      
      let(:subject) { PositionApplication.make(:state => 'submitted') }

      it 'should not validate the answers when not submitted' do
        dont_allow(subject.answers).valid?
        stub(subject).submitted? { false }
        subject.valid?
      end
      
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
  
  describe 'application states' do

    it 'should default to created' do
      PositionApplication.new.should be_created
      PositionApplication.make!.should be_created
    end

    it 'should let you transition to submitted' do
      app = PositionApplication.make!
      app.should be_created
      app.submit!
      app.should be_submitted
    end

  end

  describe 'sending the notification email' do

    it 'should send a notification email on create' do
      position_application = PositionApplication.make
      mock(PositionNotifier).application_received(position_application).mock!.deliver
      position_application.save
    end

    it 'should not send a notification email on create' do
      position_application = PositionApplication.make!
      dont_allow(PositionNotifier).application_received(anything)
      position_application.update_attributes :full_name => "Some new full name"
    end

  end

  describe 'searchable tokens' do

    it 'should generate a token on create' do
      position_application = PositionApplication.make
      position_application.searchable_token.should be_blank
      position_application.save
      position_application.searchable_token.should be_present
    end

    it 'should generate unique tokens' do
    end

  end

end
