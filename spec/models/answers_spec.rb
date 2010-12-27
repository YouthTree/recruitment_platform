require 'spec_helper'

describe Answers do
  
  let(:position_application) { PositionApplication.make }
  let(:subject)              { Answers.new position_application   }
  
  context 'validations'
  
  context 'getting properties of the answers' do
    let(:position)    { position_application.position }
    
    its(:application) { should == position_application }
    its(:position)    { should == position }
    
    context 'with stubbed out questions' do
      before(:each) { position.questions << Question.make }
      
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