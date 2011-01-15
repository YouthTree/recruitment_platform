require 'spec_helper'

describe ContentHelper do
  include ContentHelper

  describe '#content_section' do

    before :each do
      @content = Content.create! :key => 'spor', :content => '_aztec_'
    end

    it 'renders a string' do
      content_section(nil).should be_a(String)
    end

    context 'the content does not exist' do
      it 'renders a blank string' do
        content_section('nu:tone').should be_blank
      end
    end

    context 'the content section exists' do
      it 'renders the content as markdown' do
        content_section('spor').should_not be_blank
      end
    end

  end

end
