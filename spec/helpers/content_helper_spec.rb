require 'spec_helper'

describe ContentHelper do

  describe '#content_section' do

    it 'renders a string' do
      helper.content_section('').should be_a(String)
    end

    context 'the content does not exist' do
      it 'renders a blank string' do
        helper.content_section('nu:tone').should_not be_blank
      end
    end

    context 'the content section exists' do
      before :each do
        @content = Content.create! :key => 'spor', :content => '_aztec_'
      end

      it 'renders the content as markdown' do
        helper.content_section(:spor).should =~ /aztec/
      end

      context 'a scope is supplied' do
        it 'renders the content with the key as a class' do
          helper.content_section('spor', :scope => 'albums').should =~ /class=.*spor/
        end
      end
    end

  end

  describe '#meta_content' do

    it 'checks for the content section' do
      mock(Content)['meta.hello_world']
      helper.meta_content(:hello_world)
    end

    context 'the given content does not exist' do

      before :each do
        Content.where(:key => 'meta.hello_world').destroy_all
      end

      it 'should return nil' do
        helper.meta_content(:hello_world).should == nil
      end

    end

    context 'the content does exist' do

      let!(:content) { Content.create! :key => 'meta.hello_world', :content => "Hello World" }

      it 'returns a string' do
        helper.meta_content(:hello_world).should be_a(String)
      end

      it 'has the correct content' do
        helper.meta_content(:hello_world).should have_tag('meta[content="Hello World"]')
      end

      it 'accepts a symbol key' do
        helper.meta_content(:hello_world).should be_present
      end

      it 'accepts a string key' do
        helper.meta_content('hello_world').should be_present
      end

      it 'returns a meta tag' do
        helper.meta_content(:hello_world).should have_tag('meta')
      end

      it 'has the correct meta field name' do
        helper.meta_content(:hello_world).should have_tag('meta[name="hello_world"]')
      end

    end

  end

end
