shared_examples_for 'a markdown formatted model' do
  
  context 'content conversions' do
    
    it 'should have a format field that is always markdown' do
      subject.should_not respond_to(:format=)
      subject.format.should == 'markdown'
    end
    
    it 'should never change format' do
      subject.should respond_to(:format_changed?)
      subject.format_changed?.should be_false
    end
    
  end
  
end