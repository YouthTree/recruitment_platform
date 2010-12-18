require 'spec_helper'

describe Question do

  context 'associations' do
    
    it { should have_many :mission_positions }
    
  end
  
  context 'attribute accessibility' do
    
    it { should allow_mass_assignment_of :question, :short_name, :question_type, :raw_metadata, :hint, :default_value, :required_by_default }
    
    it { should_not allow_mass_assignment_of :metadata }
    
  end
  
  context 'validations' do
    
    it { should validate_presence_of :question, :short_name, :question_type }
    
  end
  
  context 'question types' do
    
    it 'should validate it has a correct type' do
      should allow_values_for :question_type, *Question::VALID_TYPES
      should_not allow_values_for :question_type, 1, :a_symbol, 'something-else', Object.new, nil, "", 'another'
    end
    
    Question::VALID_TYPES.each do |type|
      
      it "should consider #{type} a valid type" do
        subject.should allow_values_for :question_type, type
      end
      
      it "should define a #{type} accessor" do
        subject.should respond_to(:"#{type}?")
      end
      
    end
    
    it 'should let you get the human type name' do
      with_translations :ui => {:question_types => {:test_type => 'Some Test Type'}} do
        subject.question_type = 'test_type'
        subject.human_question_type.should == 'Some Test Type'
        subject.question_type = 'multiple_choice'
        subject.human_question_type.should == 'Multiple Choice'
      end
    end
    
    it 'should let you get human type options for a select' do
      options = Question.types_for_select
      options.map(&:last).should =~ Question::VALID_TYPES
      options.map(&:first).should =~ Question::VALID_TYPES.map { |t| Question.human_question_type_name(t) }
    end
    
  end
  
  context 'dealing with metadata' do
    
    it 'should serialize metadata' do
      subject.metadata.should be_nil
      subject.metadata = [1, 2, "a"]
      # Get the data back.
      subject.metadata.should == [1, 2, "a"]
    end
    
    it 'should set metadata to nil with a blank value' do
      subject.metadata = 'something'
      subject.editable_metadata = ''
      subject.editable_metadata.should == nil
      subject.metadata.should == nil
    end
    
    it 'should convert it to an array if a string' do
      subject.editable_metadata = "a\nb\nc\nd"
      subject.metadata.should == %w(a b c d)
    end
    
    it 'should store it normally otherwise' do
      subject.editable_metadata = %w(a b c d)
      subject.metadata.should == %w(a b c d)
    end
    
    it 'should let you get it as a raw string from an array' do
      subject.metadata = %w(a b c d)
      subject.editable_metadata.should == "a\nb\nc\nd"
    end
    
    it 'should let you get it as a raw string from nil' do
      subject.metadata = nil
      subject.editable_metadata.should == ''
    end
    
  end
  
  context 'getting form options' do
    
    it 'should return the correct form options for multiple choice question'
    
    it 'should return the correct form options for a date time question'
    
    it 'should return the correct form options for a select question'
    
    it 'should return the correct form options for a multiple choice question'
    
    it 'should return the correct form options for a check box question'
    
    it 'should return the correct form options for a text question'
    
    it 'should return the correct form options for a short question'
    
  end

end

# == Schema Information
#
# Table name: questions
#
#  id                  :integer         not null, primary key
#  question            :string(255)
#  short_name          :string(255)
#  hint                :text
#  metadata            :text
#  question_type       :string(255)
#  default_value       :string(255)
#  required_by_default :boolean
#  created_at          :datetime
#  updated_at          :datetime
#

