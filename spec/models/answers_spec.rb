require 'spec_helper'

describe Answers do
  
  let(:position_application) { PositionApplication.make }
  let(:subject)              { Answers.new position_application   }
  
  context 'validations' do

    let(:position)   { position_application.position }
    let(:question_1) { Question.make(:question_type => 'text').tap { |i| stub(i).id.returns(1) }  }
    let(:question_2) { Question.make(:question_type => 'text').tap { |i| stub(i).id.returns(2) }  }

    before(:each) do
      position.position_questions.build :question => question_1
      position.position_questions.build :question => question_2
      position.questions = [question_1, question_2]
    end

    it 'should be valid with no required questions' do
      stub(subject).required?(anything) { false }
      should be_valid
    end

    it 'should be invalid with incomplete required questions' do
      stub(subject).required?(question_1) { false }
      stub(subject).required?(question_2) { true  }
      subject.question_1 = nil
      subject.question_2 = nil
      should_not be_valid
      should have(0).errors_on(:question_1)
      should have(1).errors_on(:question_2)
    end

  end

  context 'dealing with questions' do

    let(:position)   { position_application.position }
    let(:question_1) { Question.make(:question_type => 'text').tap { |i| stub(i).id.returns(1) }  }
    let(:question_2) { Question.make(:question_type => 'text').tap { |i| stub(i).id.returns(2) }  }

    before(:each) do
      position.position_questions.build :question => question_1
      position.position_questions.build :question => question_2
      position.questions = [question_1, question_2]
    end

    it 'should iterate over all of the questions' do
      count = 0
      subject.each_question { |q, n| count += 1 }
      count.should == 2
    end

    it 'should yield the questions as the first argument' do
      questions = []
      subject.each_question { |q, _| questions << q }
      questions.should =~ [question_1, question_2]
    end

    it 'should yield the question param as the second argument' do
      questions = []
      subject.each_question { |_, n| questions << n }
      questions.should =~ [:question_1, :question_2]
    end

  end

  context 'dealing with answers' do

    let(:position) { position_application.position }

    before(:each) do
      position.questions = [Question.make(:question_type => 'text'), Question.make(:question_type => 'text')]
      position.questions.each_with_index { |q, i| stub(q).id.returns(i + 1) }
    end

    it 'should have the same object for answers as the raw answers' do
      subject.answers.should be_equal(position_application.raw_answers)
    end

    it 'should correctly map attributes' do
      subject.answers.should == {}
      position_application.raw_answers['question_1'] = '1000'
      subject.answers['question_1'].should == '1000'
      subject.answers['question_2'] = '1001'
      position_application.raw_answers['question_2'].should == '1001'
    end

    it 'should let you mass assign answers' do
      subject.attributes = {
        'question_1' => 'something',
        'question_2' => 'something else'
      }
      subject.question_1.should == 'something'
      subject.question_2.should == 'something else'
    end

    it 'should let you use method missing getters' do
      subject.answers['question_2'] = 'My Test Answer'
      subject.question_2.should == 'My Test Answer'
    end

    it 'should raise a NoMethodMerror for unknown getters' do
      expect { subject.question_3 }.to raise_error(NoMethodError)
    end

    it 'should let you use method missing setters' do
      subject.answers['question_1'].should be_blank
      subject.question_1 = 'Another Answer'
      subject.answers['question_1'].should == 'Another Answer'
    end

    it 'should raise a NoMethodMerror for unknown setters' do
      expect { subject.question_3 = 'Huh!' }.to raise_error(NoMethodError)
    end

    it 'should normalise blank values' do
      subject.question_1 = ''
      subject.question_1.should be_nil
    end

    it 'should let you get a hash of all answers' do
      subject.question_1 = 'Test A'
      subject.question_2 = 'Test B'
      subject.answers.should == {
        'question_1' => 'Test A',
        'question_2' => 'Test B'
      }
    end

    it 'should let you read an answer attribute' do
      subject.question_1 = 'Test A'
      subject.read_attribute(:question_1).should == 'Test A'
    end

    it 'should let you write an answer attribute' do
      subject.write_attribute :question_2, 'My Test Answer'
      subject.question_2.should == 'My Test Answer'
    end

    it 'should use the default_value if present' do
      subject.question_2 = nil
      subject.question_for_name(:question_2).default_value = 'My Simple Response'
      subject.question_2.should == 'My Simple Response'
    end

    it 'should respond to the correct pattern methods for questions' do
      should respond_to(:question_1)
      should respond_to(:question_2)
      should respond_to(:question_1=)
      should respond_to(:question_2=)
      should_not respond_to(:question_9001)
      should_not respond_to(:question_of_doom)
      should_not respond_to(:question_10_100)
      should_not respond_to(:question_answer)
      should_not respond_to(:question_9001=)
      should_not respond_to(:question_of_doom=)
      should_not respond_to(:question_10_100=)
      should_not respond_to(:question_answer=)
    end

  end

  context 'attribute names' do

    describe 'as the origin of a conversion' do

      it 'should return nil for an invalid pattern' do
        subject.send(:param_to_id, 'question_blah').should be_nil
        subject.send(:param_to_id, 'answer_blah').should be_nil
        subject.send(:param_to_id, '').should be_nil
      end

      it 'should return an integer number for a valid pattern' do
        subject.send(:param_to_id, 'question_1').should == 1
        subject.send(:param_to_id, 'question_2').should == 2
        subject.send(:param_to_id, 'question_9002').should == 9002
      end

    end

    describe 'as the destination of a conversion' do

      it 'return the correct value from a question' do
        question = Question.make :question_type => 'text'
        stub(question).id { 42 }
        subject.send(:question_to_param, question).should == :question_42
      end

    end

    describe 'as a way to look up questions' do

      let(:position)   { position_application.position }
      let(:question_1) { Question.make(:question_type => 'text').tap { |i| stub(i).id.returns(1) }  }
      let(:question_2) { Question.make(:question_type => 'text').tap { |i| stub(i).id.returns(2) }  }

      before(:each) do
        position.position_questions.build :question => question_1
        position.position_questions.build :question => question_2
        position.questions = [question_1, question_2]
      end

      it 'should have the correct item for known indexes' do
        subject.question_for_name('question_1').should == question_1
        subject.question_for_name('question_2').should == question_2
      end

      it 'should return nil for an incorrect id' do
        subject.question_for_name('question_3').should be_nil
        subject.question_for_name('question_100').should be_nil
      end

      it 'should return nil for a bad name' do
        subject.question_for_name('question_of_doom').should be_nil
        subject.question_for_name('neat_isnt_it').should be_nil
        subject.question_for_name('answers_for_stuff').should be_nil
      end

      it 'should accept symbols' do
        subject.question_for_name(:question_1).should == question_1
        subject.question_for_name(:question_2).should == question_2
        subject.question_for_name(:question_3).should be_nil
      end

    end

  end
  
  context 'checking the required state of a question' do

    let(:position)   { position_application.position }
    let(:question_1) { Question.make(:question_type => 'text').tap { |i| stub(i).id.returns(1) }  }
    let(:position_question_1) { @position_question_1 }

    before(:each) do
      @position_question_1 = position.position_questions.build :question => question_1
      position.questions = [question_1]
    end

    it 'should be required if the position question is required' do
      position_question_1.required = true
      should be_required(question_1)
    end

    it 'should not be required if the position question is not required' do
      position_question_1.required = false
      should_not be_required(question_1)
    end

    it 'should be required if it has no preference and required by default is true' do
      position_question_1.required = nil
      question_1.required_by_default = true
      should be_required(question_1)
    end

    it 'should not be required if it has no preference and required by default is false' do
      position_question_1.required = nil
      question_1.required_by_default = false
      should_not be_required(question_1)
    end


  end

  context 'getting the options for a question' do

    let(:position)   { position_application.position }
    let(:question_1) { Question.make(:question_type => 'text').tap { |i| stub(i).id.returns(1) }  }
    let(:position_question_1) { @position_question_1 }

    it 'should proxy it to the question' do
      mock(question_1).to_formtastic_options(position_question_1)
      subject.to_formtastic_options(question_1)
    end

  end

  context 'checking if answers are needed' do

    it 'should be false when there are no questions' do
      stub(subject).questions { [] }
      should_not be_needed
    end

    it 'should be true with questions' do
      stub(subject).questions { [Question.make] }
      should be_needed
    end

  end

  context 'getting properties of the answers' do
    let(:position)    { position_application.position }
    
    its(:application) { should == position_application }
    its(:position)    { should == position }
    
    context 'with stubbed out questions' do
      before(:each) { position.questions << Question.make(:question_type => 'text') }
      its(:questions)   { should == position.questions }
    end
    
  end
  
  context 'acting like an activemodel object' do
    include ActiveModel::Lint::Tests
    
    before :each do
      @model = subject
    end
    
    it 'should correctly deal with to_key' do
      test_to_key
    end
    
    it 'should correctly deal with to_param' do
      test_to_param
    end
    
    it 'should correctly implement naming' do
      test_model_naming
    end
    
    it 'should correctly implement persisted?' do
      test_persisted?
    end
    
    it 'should correctly implement validations' do
      test_valid?
      test_errors_aref
      test_errors_full_messages
    end

  end
  
end