class Answers
  extend ActiveModel::Naming  
  extend ActiveModel::Translation
  include ActiveModel::Conversion
  include ActiveModel::Validations
  
  attr_reader :application, :position, :questions
  
  def initialize(application)
    @application = application
    @position    = application.try(:position)
    @questions   = position.try :questions
  end
  
  delegate :persisted?, :to => :application
  
end