require 'spec_helper'

describe Position do
  
  context 'associations' do
    it { should belong_to :team }
  end
  
  context 'validations' do
    it { should validate_presence_of :title, :short_description, :duration, :time_commitment, :team, :paid_description, :general_description, :position_description, :applicant_description }
  end
  
  context 'accessible attributes' do
    it { should allow_mass_assignment_of :title, :short_description, :duration, :time_commitment, :team_id, :paid_description, :general_description, :position_description, :applicant_description, :paid }
    it { should_not allow_mass_assignment_of :rendered_paid_description, :rendered_general_description, :rendered_position_description, :rendered_applicant_description }
  end
  
  context 'content conversions' do
    
    it 'should have a format field that is always markdown' do
      subject.should_not respond_to(:format=)
      subject.format.should == 'markdown'
    end
    
  end
  
  context 'slug generation' do
    
    it 'should automatically generate the slug' do
      Position.make!(:title => 'Marketing Monkey').to_param.should == 'marketing-monkey'
    end
    
    it 'should generate sequential slugs' do
      Position.make!(:title => 'something').to_param.should == 'something'
      Position.make!(:title => 'something').to_param.should == 'something--1'
    end
    
  end
  
end

# == Schema Information
#
# Table name: positions
#
#  id                             :integer         not null, primary key
#  title                          :string(255)
#  short_description              :text
#  team_id                        :integer
#  paid                           :boolean         default(FALSE)
#  duration                       :string(255)
#  time_commitment                :decimal(, )
#  rendered_paid_description      :text
#  rendered_general_description   :text
#  rendered_position_description  :text
#  rendered_applicant_description :text
#  general_description            :text
#  position_description           :text
#  applicant_description          :text
#  paid_description               :text
#  published_at                   :datetime
#  expires_at                     :datetime
#  cached_slug                    :string(255)
#  created_at                     :datetime
#  updated_at                     :datetime
#

