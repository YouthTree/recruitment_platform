require 'spec_helper'

describe ContentHelper do
  include ApplicationHelper
  include ContentHelper

  describe '#content_section' do

    it 'renders a string' do
      content_section('').should be_a(String)
    end

    context 'the content does not exist' do
      it 'renders a blank string' do
        content_section('nu:tone').should_not be_blank
      end
    end

    context 'the content section exists' do
      before :each do
        @content = Content.create! :key => 'spor', :content => '_aztec_'
      end

      it 'renders the content as markdown' do
        content_section(:spor).should =~ /aztec/
      end

      context 'a scope is supplied' do
        it 'renders the content with the key as a class' do
          content_section('spor', :scope => 'albums').should =~ /class=.*spor/
        end
      end
    end

  end

end
