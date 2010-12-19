require 'spec_helper'

describe Question do

  context 'associations' do
    
    it { should have_many :position_questions }

    it { should have_many :positions, :through => :position_questions }
    
  end
  
  context 'attribute accessibility' do
    
    it { should allow_mass_assignment_of :question, :short_name, :question_type, :editable_metadata, :hint, :default_value, :required_by_default }
    
    it { should_not allow_mass_assignment_of :metadata }
    
  end
  
  context 'validations' do
    
    it { should validate_presence_of :question, :short_name, :question_type }
    
  end
  
  context 'for select' do

    before :each do
      @question_a = Question.make!
      @question_b = Question.make!
      @question_c = Question.make!
      @question_d = Question.make!
      @question_e = Question.make!
    end

    it 'should allow you to get questions for a select' do
      Question.for_select.should =~ [[@question_a.question, @question_a.id], [@question_b.question, @question_b.id], [@question_c.question, @question_c.id], [@question_d.question, @question_d.id], [@question_e.question, @question_e.id]]
    end

    it 'should let you get questions with the exception of a specific id' do
      Question.except_for([]).all.should =~ [@question_a, @question_b, @question_c, @question_d, @question_e]
      Question.except_for([ @question_d.id, @question_e.id]).all.should =~ [@question_a, @question_b, @question_c]
    end

  end

  context 'question types' do
    
    it 'should validate it has a correct type' do
      should allow_values_for :question_type, *Question::VALID_TYPES
      should_not allow_values_for :question_type, 1, :a_symbol, 'something-else', Object.new, nil, "", 'another'
    end
    
    context 'with collections' do

      Question::COLLECTION_TYPES.each do |type|

        it "should have a collection #{type}" do
          subject.question_type = type
          subject.has_collection?.should be_true
        end

      end

      (Question::VALID_TYPES - Question::COLLECTION_TYPES).each do |type|

        it "should not have a collection for #{type}" do
          subject.question_type = type
          subject.has_collection?.should be_false
        end

      end

    end

    Question::VALID_TYPES.each do |type|
      
      it "should consider #{type} a valid type" do
        subject.should allow_values_for :question_type, type
      end
      
      it "should define a #{type} accessor" do
        subject.should respond_to(:"#{type}?")
      end
      
      it "should correctly detect the question type for #{type}?" do
        m = "be_#{type}".to_sym
        subject.question_type = nil
        should_not send(m)
        (Question::VALID_TYPES - [type]).each do |t|
          subject.question_type = t
          should_not send(m)
        end
        subject.question_type = type
        should send(m)
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
    
    before :each do
      @answer = stub!
    end
    
    it 'should return the correct type' do
      subject.to_formtastic_options(@answer).should be_kind_of(Hash)
    end
    
    it 'should return the correct hint' do
      subject.to_formtastic_options(@answer).should_not have_key(:hint)
      subject.hint = 'Some hint goes here.'
      subject.to_formtastic_options(@answer)[:hint].should == 'Some hint goes here.'
    end
    
    it 'should return the correct label' do
      subject.question = 'Are you a ninja?'
      subject.to_formtastic_options(@answer)[:label].should == 'Are you a ninja?'
    end
    
    it 'should return the correct required value when the answer is required' do
      stub(@answer).required { true }
      subject.to_formtastic_options(@answer)[:required].should == true
    end
    
    it 'should return the correct required value when the answer is not required' do
      stub(@answer).required { false }
      subject.to_formtastic_options(@answer)[:required].should == false
    end
    
    it 'should return the correct required value when the answer has no required value and the question is by default required' do
      stub(@answer).required { nil }
      subject.required_by_default = true
      subject.to_formtastic_options(@answer)[:required].should == true
    end

    it 'should return the correct required value when the answer has no required value and the question is not by default required' do
      stub(@answer).required { nil }
      subject.required_by_default = false
      subject.to_formtastic_options(@answer)[:required].should == false
    end

    it 'should return the correct form options for multiple choice question' do
      subject.question_type = 'multiple_choice'
      subject.metadata = %w(a b c)
      options = subject.to_formtastic_options(@answer)
      options[:as].should == :radio_buttons
      options[:collection].should == %w(a b c)
    end

    it 'should return the correct form options for a date time question' do
      subject.question_type = 'date_time'
      subject.to_formtastic_options(@answer)[:as].should == :datetime_picker
    end

    it 'should return the correct form options for a select question' do
      subject.question_type = 'select'
      subject.metadata = %w(a b c)
      options = subject.to_formtastic_options(@answer)
      options[:as].should == :select
      options[:collection].should == %w(a b c)
    end

    it 'should return the correct form options for a check box question' do
      subject.question_type = 'check_boxes'
      subject.metadata = %w(a b c)
      options = subject.to_formtastic_options(@answer)
      options[:as].should == :check_boxes
      options[:collection].should == %w(a b c)
    end

    it 'should return the correct form options for a text question' do
      subject.question_type = 'text'
      subject.to_formtastic_options(@answer)[:as].should == :text
    end

    it 'should return the correct form options for a short text question' do
      subject.question_type = 'short_text'
      subject.to_formtastic_options(@answer)[:as].should == :string
    end
    
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

