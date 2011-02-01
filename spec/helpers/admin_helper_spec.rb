require 'spec_helper'

describe AdminHelper do
  include AdminHelper

  describe '#new_application_count' do
    before :each do
      mock(self).current_user.returns User.make!
    end

    subject { new_application_count }

    it { should be_a(Integer) }
  end

end
