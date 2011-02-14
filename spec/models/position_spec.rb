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
#  time_commitment                :integer
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
#  time_commitment_flexibility    :string(255)
#  order_position                 :integer
#

require 'spec_helper'

describe Position do
  
  context 'associations' do

    it { should belong_to :team }

    it { should have_many :position_questions }

    it { should have_many :questions, :through => :position_questions }

    it { should have_many :applications, :class_name => 'PositionApplication' }

    it { should have_many :contact_emails, :class_name => 'EmailAddress', :as => :addressable }

    it { should accept_nested_attributes_for :position_questions, :contact_emails, :allow_destroy => true }
    
    it { should have_many :taggings, :dependent => :destroy, :as => :taggable }
    it { should have_many :tags, :through => :taggings }

  end
  
  context 'validations' do

    it { should validate_presence_of :title, :short_description, :duration, :team, :general_description, :position_description, :applicant_description }

    it { should validate_associated :contact_emails }
    
    it { should validate_numericality_of :minimum_hours, :maximum_hours, :greather_than => 0, :less_than_or_equal_to => 40, :only_integer => true, :allow_blank => false }

    it 'should not require the paid description when unpaid' do
      mock(subject).paid? { false }
      should_not validate_presence_of :paid_description
    end

    it 'should require the paid description when paid' do
      mock(subject).paid? { true }
      should validate_presence_of :paid_description
    end
    
    it 'should ensure the expired at date is before published at' do
      subject.published_at = 2.weeks.ago
      should_not allow_values_for :expires_at, 4.weeks.ago, 2.months.ago, 1.year.ago, subject.published_at
      should allow_values_for :expires_at, (subject.published_at + 1.day), 2.weeks.from_now, nil
    end
    
    it 'should require the contact emails only when published' do
      stub(subject).published? { false }
      should_not validate_presence_of :contact_emails
      stub(subject).published? { true }
      should validate_presence_of :contact_emails
    end
    
    it 'should require the min hours is less than the max' do
      position = Position.make
      position.minimum_hours = 11
      position.maximum_hours = 10
      position.should_not be_valid
      p position.errors.full_messages
      position.maximum_hours = 12
      position.should be_valid
      position.maximum_hours = 11
      position.should be_valid
    end

  end
  
  context 'accessible attributes' do
    it { should allow_mass_assignment_of :title, :short_description, :duration, :minimum_hours, :maximum_hours, :team_id, :paid_description, :general_description, :position_description, :applicant_description, :paid, :position_questions_attributes, :contact_emails_attributes, :tag_list }
    it { should_not allow_mass_assignment_of :rendered_paid_description, :rendered_general_description, :rendered_position_description, :rendered_applicant_description }
  end
  
  it_should_behave_like 'a markdown formatted model'
  
  context 'slug generation' do
    
    it 'should automatically generate the slug' do
      Position.make!(:title => 'Marketing Monkey').to_param.should == 'marketing-monkey'
    end
    
    it 'should generate sequential slugs' do
      Position.make!(:title => 'something').to_param.should == 'something'
      Position.make!(:title => 'something').to_param.should == 'something--1'
    end
    
  end
  
  context 'the status of the position' do

    it 'should not be viewable if it is not published' do
      stub(subject).expired?   { false }
      stub(subject).published? { false }
      should_not be_viewable
    end

    it 'should not be viewable if it is expired' do
      stub(subject).expired?   { true }
      stub(subject).published? { true }
      should_not be_viewable
    end

    it 'should be viewable if it is published and not expired' do
      stub(subject).expired?   { false }
      stub(subject).published? { true }
      should be_viewable
    end

    it 'should not be expired when expires_at is in the future' do
      subject.expires_at = 1.week.from_now
      should_not be_expired
    end

    it 'be expired when expires_at is now' do
      t = Time.now
      stub(Time).now { t }
      subject.expires_at = t
      should be_expired
    end

    it 'be expired when expires_at is in the past' do
      subject.expires_at = 1.week.ago
      should be_expired
    end

    it 'should be published when published at is now' do
      t = Time.now
      stub(Time).now { t }
      subject.published_at = t
      should be_published
    end

    it 'should be published when published at is in the past' do
      subject.published_at = 1.week.ago
      should be_published
    end

    it 'should not be published when published at is in the future' do
      subject.published_at = 1.from_now
      should_not be_published
    end

  end

  context 'content conversions' do

    [:paid_description, :general_description, :position_description, :applicant_description].each do |field|

      it "should automatically convert the #{field} on validation" do
        position = Position.make(field => '# Sample Text')
        position.save
        position.send(:"rendered_#{field}").should have_tag(:h1, 'Sample Text')
      end

    end

  end

  context 'position named scopes' do

    before :each do
      @viewable_a     = Position.make!(:published_at => 1.week.ago, :expires_at => 1.week.from_now)
      @viewable_b     = Position.make!(:published_at => 2.months.ago, :expires_at => 2.hours.from_now)
      @expired_a     = Position.make!(:published_at => 2.months.ago, :expires_at => 2.hours.ago)
      @expired_b     = Position.make!(:published_at => nil, :expires_at => 2.weeks.ago)
      @unpublished_a = Position.make!(:published_at => 2.months.from_now, :expires_at => 3.months.from_now)
      @unpublished_b = Position.make!(:published_at => 1.week.from_now, :expires_at => nil)
    end

    it 'should return the correct positions for unpublished' do
      Position.viewable.all.should =~ [@viewable_a, @viewable_b]
    end

    it 'should return the correct positions for unpublished' do
      Position.unpublished.all.should =~ [@unpublished_a, @unpublished_b, @expired_b]
    end

    it 'should return the correct positions for published' do
      Position.published.all.should =~ [@viewable_a, @viewable_b, @expired_a]
    end

    it 'should return the correct positions for expired' do
      Position.expired.all.should =~ [@expired_a, @expired_b]
    end

    it 'should return the correct positions for unexpired' do
      Position.unexpired.all.should =~ [@viewable_a, @viewable_b, @unpublished_a]
    end

  end

  context 'getting the status of a position' do

    it 'should be published when published and unexpired' do
      stub(subject).published? { true }
      stub(subject).expired?   { false }
      subject.status.should == :published
    end

    it 'should be expired when when published and expired' do
      stub(subject).published? { true }
      stub(subject).expired?   { true }
      subject.status.should == :expired
    end

    it 'should be draft when not published' do
      stub(subject).published? { false }
      stub(subject).expired?   { false }
      subject.status.should == :draft
    end

    it 'should let you get the humanised status' do
      with_translations :ui => {:position_status => {:test_status => 'My Test Status'}} do
        mock(subject).status.times(any_times) { :test_status }
        subject.human_status.should == 'My Test Status'
      end
    end

  end

  context 'dealing with position questions' do

    before :each do
      @position = Position.make!
      10.times { @position.position_questions.create :question => Question.make! }
      @questions = @position.questions
    end

    context 'with the association loaded' do

      before :each do
        @position = Position.with_questions.find(@position.id)
      end

      it 'should return a sorted array for ordered' do
        @position.position_questions.ordered.should be_kind_of(Array)
        @position.position_questions.ordered.map(&:order_position) == Array(1..10)
      end

      it 'should not use the database operation' do
        dont_allow(@position.position_questions).maximum
        @position.position_questions.next_order_position
      end

      it 'should return the the correct value for next order position' do
        @position.position_questions.next_order_position.should == 11
      end

      it 'should default to 1 with no order positions' do
        # Same as no values
        stub.instance_of(PositionQuestion).order_position { nil }
        @position.position_questions.next_order_position.should == 1
      end

    end

    context 'without the association loaded' do

      before :each do
        @position = Position.find(@position.id)
      end

      it 'should return a relation for ordered' do
        @position.position_questions.ordered.should be_kind_of(ActiveRecord::Relation)
        @position.position_questions.ordered.map(&:order_position) == Array(1..10)
      end

      it 'should use maximum on the association for the next order position' do
        mock(@position.position_questions).maximum(:order_position) { 10 }
        @position.position_questions.next_order_position.should == 11
      end

      it 'should default to 1 with no order positions' do
        stub(@position.position_questions).maximum(:order_position) { nil }
        @position.position_questions.next_order_position.should == 1
      end

      it 'should return the correct value for the next order position' do
        @position.position_questions.next_order_position.should == 11
      end

    end

  end

  context 'searching on positions' do

    it 'should have a search class method' do
      Position.should respond_to(:search)
    end

    it 'should return a position search object' do
      Position.search.should be_kind_of PositionSearch
    end

    it 'should pass the arguments to Position Search' do
      viewable = Object.new
      mock(Position).viewable { viewable }
      mock(PositionSearch).new viewable, :a => 1
      Position.search :a => 1
    end

  end

  describe 'getting an application reporter' do

    specify { should respond_to(:to_application_reporter) }

    it 'should bu default pass it through with an empty hash' do
      object = Object.new
      mock(PositionApplicationReporter).new(subject, Hash.new) { object }
      subject.to_application_reporter.should == object
    end

    it 'should pass through options when given' do
      object = Object.new
      mock(PositionApplicationReporter).new(subject, :fields => %w(full_name)) { object }
      subject.to_application_reporter(:fields => %w(full_name)).should == object
    end

  end
  
  context 'tagging' do
    
    subject { Position.make! }
    
    it 'should default to an empty tag list' do
      subject.tag_list.should == ''
    end
    
    it 'should let you set the tag list' do
      subject.tags.should == []
      subject.tag_list = 'a, b, c'
      subject.tags.size.should == 3
      subject.tags.map(&:name).should == %w(a b c)
    end
    
    it 'should let you get a correctly setup tag list' do
      subject.tag_list = 'x, y, z'
      subject.tag_list.should == 'x, y, z'
    end
    
    it 'should correctly normalise tag lists' do
      subject.tag_list = 'a, y,    a,c'
      subject.tag_list.should == 'a, y, c'
    end
    
    it 'should correctly tag counts' do
      Position.tag_counts.should == {}
      Position.make! :tag_list => 'a, b, c'
      Position.make! :tag_list => 'a, b'
      Position.make! :tag_list => 'b'
      Position.tag_counts.should == {
        'b' => 3,
        'a' => 2,
        'c' => 1
      }
    end

    it 'should correctly tag counts' do
      Position.tag_options.should == []
      Position.make! :tag_list => 'a, b, c'
      Position.make! :tag_list => 'a, b'
      Position.make! :tag_list => 'b'
      Position.tag_options.should == %w(a b c)
    end

    it 'should let you correctly find tagged positions' do
      position_a = Position.make! :tag_list => 'a', :title => 'Position A'
      position_b = Position.make! :tag_list => 'b', :title => 'Position B'
      position_c = Position.make! :tag_list => 'c', :title => 'Position C'
      Position.tagged_with('a').all.should =~ [position_a]
      Position.tagged_with(%w(a b)).all.should =~ [position_a, position_b]
      Position.tagged_with('a, b').all.should =~ [position_a, position_b]
      Position.tagged_with(['c', '']).all.should =~ [position_c]
      Position.tagged_with('').all.should =~ [position_a, position_b, position_c]
      Position.tagged_with(['']).all.should =~ [position_a, position_b, position_c]
    end

  end

  describe '#human_time_commitment' do

    let(:position) { Position.new }


    it 'has a valid description for no range' do
      position.attributes = {:minimum_hours => nil, :maximum_hours => nil}
      position.human_time_commitment.should == 'Currently unknown'
    end
    
    it 'has a valid description for both one hour' do
      position.attributes = {:minimum_hours => 1, :maximum_hours => 1}
      position.human_time_commitment.should == '1 hour'
    end
    
    it 'has a valid description for both the same' do
      position.attributes = {:minimum_hours => 5, :maximum_hours => 5}
      position.human_time_commitment.should == '5 hours'
    end
    
    it 'has a valid description for two different numbers' do
      position.attributes = {:minimum_hours => 10, :maximum_hours => 30}
      position.human_time_commitment.should == '10 to 30 hours'
    end

  end

  context '#clone_for_editing' do

    let(:original_position) do
      Position.make!(:tag_list => 'a, b, c, d').tap do |position|
        position.questions << Question.make!
        position.contact_emails.create! :email => 'test-a@example.com'
        position.contact_emails.create! :email => 'test-b@example.com'
      end
    end
    
    let(:position) { original_position.clone_for_editing }
    subject        { position }

    it 'should have a blank id' do
      subject.id.should be_blank
    end

    it 'should not be persisted' do
      should_not be_persisted
    end

    it 'should have a blank publishing time' do
      should_not be_published
      should_not be_viewable
      subject.published_at.should be_blank
    end

    it 'should have a blank expiry time' do
      should_not be_expired
      should_not be_viewable
      subject.expires_at.should be_blank
    end

    it 'should not have the rendered content' do
      subject.rendered_applicant_description.should be_blank
      subject.rendered_position_description.should be_blank
      subject.rendered_general_description.should be_blank
      subject.rendered_paid_description.should be_blank
    end

    it 'should not have a cached slug' do
      subject.cached_slug.should be_blank
    end

    it 'should be valid' do
      should be_valid
    end
    
    it 'should preserve the tag list' do
      subject.tag_list.split(", ").should =~ original_position.tag_list.split(", ")
    end
    
    it 'should preserve the email list' do
      subject.contact_emails.size.should == original_position.contact_emails.size
      subject.contact_emails.map(&:email).should == original_position.contact_emails.map(&:email)
    end

    it 'should preserve the questions' do
      subject.position_questions.size.should == original_position.position_questions.size
      subject.position_questions.each do |pq|
        other = original_position.position_questions.detect { |q| q.question_id == pq.question_id }
        other.should be_present
        other.required.should == pq.required
        other.order_position.should == pq.order_position
      end
    end

  end

  context 'ordering' do
    before :each do
      @first = Position.make! :title => 'I am Spartacus', :order_position => 0
      @last = Position.make! :title => 'No, I am Spartacus', :order_position => 1
    end

    it 'has positions in the default order' do
      Position.in_order.all.should == [@first, @last]
    end

    it 'accepts a new ordering for the positions' do
      Position.update_order([@last.id, @first.id])
      Position.in_order.all.should == [@last, @first]
    end
  end

end
