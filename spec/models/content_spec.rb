require 'spec_helper'

describe Content do

  describe '#content_as_html' do
    let(:content) { Content.new }
    subject { content.content_as_html }
    
    it 'converts content to html' do
      content.content = '<blink>shazwazza</blink>'
      content.content_as_html.should == '<blink>shazwazza</blink>'
    end

    it 'converts nil to html' do
      content.content_as_html.should == ''
    end
  end

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
