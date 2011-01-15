require 'spec_helper'

describe Content do

  describe '.[]' do
    before :each do
      @content = Content.create! :key => 'blinky bill'
    end

    it "should find the content with key 'blinky bill'" do
      Content['blinky bill'].should == @content
    end

    it 'should return nil for a nonexistant content key' do
      Content['terrence smart'].should be_nil
    end
  end

end
