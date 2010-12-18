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
  
end
