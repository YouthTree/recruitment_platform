class Answers
  extend ActiveModel::Naming  
  extend ActiveModel::Translation
  include ActiveModel::Conversion
  include ActiveModel::Validations
  
  attr_reader :application, :position, :questions, :position_questions
  
  VALID_NAME_REGEXP = /^question_(\d+)\=?$/

  def initialize(application)
    @application        = application
    @position           = application.try(:position)
    @position_questions = position.try(:position_questions) || []
    @questions          = position.try(:questions) || position_questions.map(&:question)
    build_question_hashes
  end
  
  delegate :persisted?, :to => :application
  
  validate :check_question_requiredness

  def attributes=(value)
    return unless value.is_a?(Hash)
    value.each_pair do |k, v|
      write_attribute k, v if k.to_s =~ VALID_NAME_REGEXP
    end
  end

  def write_attribute(name, value)
    return if question_for_name(name).blank?
    answers[name.to_s] = normalise_value(question_for_name(name), value)
  end

  def read_attribute(name)
    question_for_name(name).presence && answers[name.to_s]
  end

  def answers
    @answers ||= begin
      value = application.raw_answers
      unless value.is_a?(Hash)
        value                   = {}
        application.raw_answers = value
      end
      value
    end
  end

  def question_for_name(name)
    @question_lookups[name.to_s.gsub(/\=$/, '')]
  end

  def method_missing(name, *args, &blk)
    if (question = question_for_name(name)).present?
      name = name.to_s
      if name[-1, 1] == '='
        write_attribute name[0..-2], *args
      else
        read_attribute name
      end
    else
      super
    end
  end

  def respond_to?(name, include_private = false)
    question_for_name(name).present? || super
  end

  def required?(question)
    position_question = @position_question_mapping[question]
    if position_question.present? && !position_question.required.nil?
      position_question.required?
    else
      question.required_by_default?
    end
  end

  def each_question
    sorted_questions.each do |q|
      yield q, question_to_param(q)
    end
  end

  def sorted_questions
    questions.sort_by { |q| @position_question_mapping[q].try(:order_position) || 0 }
  end

  protected

  def check_question_requiredness
    each_question do |question, param|
      if required?(question) && read_attribute(param).blank?
        errors.add param, :blank, :message => 'is blank'
      end
    end
  end

  def build_question_hashes
    @question_lookups = questions.inject({}) do |acc, current|
      acc[question_to_param(current).to_s] = current
      acc
    end
    @position_question_mapping = position_questions.inject({}) do |acc, current|
      acc[current.question] = current
      acc
    end
  end

  def position_question_for(question)
    @position_question_mapping[question]
  end

  def question_to_param(question)
    question.presence && :"question_#{question.id}"
  end

  def param_to_id(id)
    if id.to_s =~ VALID_NAME_REGEXP
      $1.to_i
    else
      nil
    end
  end

  def normalise_value(question, value)
    question.presence && question.normalise_value(value)
  end

end