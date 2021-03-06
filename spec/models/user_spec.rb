# == Schema Information
#
# Table name: users
#
#  id                  :integer         not null, primary key
#  email               :string(255)     default(""), not null
#  remember_token      :string(255)
#  remember_created_at :datetime
#  sign_in_count       :integer         default(0)
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string(255)
#  last_sign_in_ip     :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

require 'spec_helper'

describe User do

  context 'attribute accessibility' do
    it { should allow_mass_assignment_of :email, :password, :remember_me }
    it { should_not allow_mass_assignment_of :created_at, :updated_at, :last_sign_in_ip, :last_sign_in_at, :sign_in_count, :remember_token, :current_sign_in_ip, :remember_created_at, :current_sign_in_at }
  end

  context 'validations' do
    before(:all) { @other_user = User.make! }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should allow_values_for :email,  'test@example.com', 'web@youthtree.org.au', 'sutto@sutto.net' }
    it { should_not allow_values_for :email, 'blah', nil, '', 'test @ example.com', 'google.com'  }
    after(:all) { @other_user.delete }
  end

end
