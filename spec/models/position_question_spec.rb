require 'spec_helper'

describe PositionQuestion do
  
  context 'associations' do
    
    it { should belong_to :position }
    
    it { should belong_to :question }
    
  end
  
  context 'validations' do
    
    it { should validate_presence_of :question, :position }  
    
  end
  
  context 'accessible attributes' do
    
    it { should allow_mass_assignment_of :question, :question_id, :required, :order_position }
    
    it { should_not allow_mass_assignment_of :position, :position_id }
    
  end
  
  context 'setting the order position' do

    it 'should default to setting it to 1 if the position is blank' do
      subject.order_position = nil
      subject.position = nil
      subject.send :_run_save_callbacks
      subject.order_position.should == 1
    end

    it 'should find the next order position if possible and set it to that' do
      subject.order_position = nil
      subject.position = Position.make
      mock(subject.position.position_questions).next_order_position { 3 }
      subject.send :_run_save_callbacks
      subject.order_position.should == 3
    end

    it 'should not set it if the order position if present' do
      subject.order_position = 3
      dont_allow(subject).order_position = anything
      subject.send :_run_save_callbacks
    end

  end

end
