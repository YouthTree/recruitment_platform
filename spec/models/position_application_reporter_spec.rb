require 'spec_helper'

describe PositionApplicationReporter do
  
  let(:question_1) { Question.make! :question_type => 'short_text' }
  let(:question_2) { Question.make! :question_type => 'short_text' }
  
  let(:position) do
    Position.make!.tap do |position|
      position.position_questions.create! :question => question_1
      position.position_questions.create! :question => question_2
      position.questions.reload
    end
  end
  
  def make_reporter(options = {})
    if respond_to?(:application)
      application
    else
      position.applications.make! if position.applications.empty?
    end
    PositionApplicationReporter.new position, options
  end
  
  def make_application
    application = position.applications.build :full_name => 'An Example User',
      :email_address_attributes => {:email => 'test@example.com'},
      :phone => '99999999'
    application.attributes = {
      :answers => {
        "question_#{question_1.id}" => 'Example One',
        "question_#{question_2.id}" => 'Example Two'
      }
    }
    application.save
    application
  end
  
  let(:application) { make_application }
  
  context 'getting the available fields' do
    
    let(:model_fields) { PositionApplicationReporter::MODEL_FIELDS }
    
    it 'should default to all fields' do
      reporter = make_reporter
      reporter.fields.should == reporter.available_field_names
    end
    
    it 'should let the user specify the fields they wish to use' do
      fields = model_fields[0, 2]
      reporter = make_reporter :fields => fields
      reporter.fields.should == fields
      reporter.fields.should_not == reporter.available_field_names
    end
    
    it 'should ignore unknown fields' do
      fields = model_fields[0, 2]
      reporter = make_reporter :fields => (fields + %w(another_field something_random))
      reporter.fields.should == fields
    end
    
    it 'should let you get a set of all available field names' do
      reporter = make_reporter
      (reporter.available_field_names & model_fields).should == model_fields
      reporter.available_field_names.should include("question_#{question_1.id}")
      reporter.available_field_names.should include("question_#{question_2.id}")
    end
    
    it 'should let you get a list of available field options' do
      reporter = make_reporter
      options = reporter.available_field_options
      options.should be_present
      options.should be_all { |i| i.size == 2 }
      values = options.map(&:last)
      (values & model_fields).should == model_fields
      options.find { |i| i.last == "question_#{question_1.id}" }.first.should == question_1.short_name
      options.find { |i| i.last == "question_#{question_2.id}" }.first.should == question_2.short_name
    end
    
  end
  
  context 'building csv' do
    
    let(:reporter)     { make_reporter }
    
    it 'should have a to_csv method' do
      reporter.should respond_to(:to_csv)
    end
    
    it 'should return a string from to_csv' do
      reporter.to_csv.should be_a(String)
    end
    
    it 'should return valid csv' do
      expect do
        FasterCSV.parse(reporter.to_csv)
      end.to_not raise_error(FasterCSV::MalformedCSVError)
    end
    
    it 'should have a header row' do
      result = FasterCSV.parse(reporter.to_csv)
      result.first.should == reporter.field_labels
    end
    
    it 'should have the correct number of rows' do
      result = FasterCSV.parse(reporter.to_csv)
      result.size.should == 2
    end
    
    it 'should have the correct values' do
      result = FasterCSV.parse(reporter.to_csv)
      result[1].should == [
        application.full_name,
        application.email_address.to_s,
        application.phone,
        application.answers.send("question_#{question_1.id}"),
        application.answers.send("question_#{question_2.id}")
      ]
    end
    
  end
  
  context 'looking up field values' do
    
    let(:reporter)    { make_reporter }
    
    it 'should know how to lookup model values' do
      reporter.lookup_field(application, 'full_name').should == application.full_name
      reporter.lookup_field(application, 'email_address').should == application.email_address.to_s
    end
    
    it 'should know how to lookup answer values' do
      reporter.lookup_field(application, "question_#{question_1.id}").should == 'Example One'
      reporter.lookup_field(application, "question_#{question_2.id}").should == 'Example Two'
    end
    
  end
  
  context 'acting like an activemodel object' do
    include ActiveModel::Lint::Tests
    
    before :each do
      @model = make_reporter
    end
    
    it 'should correctly deal with to_key' do
      test_to_key
    end
    
    it 'should correctly deal with to_param' do
      test_to_param
    end
    
    it 'should correctly implement naming' do
      test_model_naming
    end
    
    it 'should correctly implement persisted?' do
      test_persisted?
    end

  end
  
end