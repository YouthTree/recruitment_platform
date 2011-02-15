require 'spec_helper'

describe ApplicationHelper do
  
  describe '#auto_link_options' do
    
    let(:options) do
      {
        :hint  => "Hello there, http://google.com/ and sutto@sutto.net",
        :label => "Oh lookey me, http://twitter.com/ and bob@example.com"
      }
    end
    
    it 'should not auto-link with no fields' do
      autolinked = auto_link_options(options)
      autolinked[:hint].should_not have_tag('a')
      autolinked[:label].should_not have_tag('a')
    end
    
    it 'should not add non-existant fields' do
      autolinked = auto_link_options(options, :hint, :label, :another)
      autolinked.should_not have_key(:another)
    end
    
    it 'should auto-link the specified fields' do
      autolinked = auto_link_options(options, :hint, :label)
      autolinked[:hint].should have_tag('a')
      autolinked[:label].should have_tag('a')
    end
    
    it 'should auto-link urls' do
      autolinked = auto_link_options(options, :hint, :label)
      autolinked[:hint].should have_tag('a[href="http://google.com/"]', 'http://google.com/')
      autolinked[:label].should have_tag('a[href="http://twitter.com/"]', 'http://twitter.com/')
    end
    
    it 'should auto-link emails' do
      autolinked = auto_link_options(options, :hint, :label)
      autolinked[:hint].should have_tag('a[href="mailto:sutto@sutto.net"]', 'sutto@sutto.net')
      autolinked[:label].should have_tag('a[href="mailto:bob@example.com"]', 'bob@example.com')
    end
    
    it "should not auto-link fields that aren't in the list" do
      autolinked = auto_link_options(options, :hint)
      autolinked[:hint].should have_tag('a')
      autolinked[:label].should_not have_tag('a')
    end
    
  end
  
end
