# == Schema Information
#
# Table name: questions
#
#  id                  :integer         not null, primary key
#  question            :string(255)
#  short_name          :string(255)
#  hint                :text
#  metadata            :text
#  question_type       :string(255)
#  default_value       :string(255)
#  required_by_default :boolean
#  created_at          :datetime
#  updated_at          :datetime
#

class Question < ActiveRecord::Base
  
  VALID_TYPES      = %w(date_time short_text text multiple_choice check_boxes select scale)
  COLLECTION_TYPES = %w(multiple_choice check_boxes select)
  
  FIELD_TYPE_MAPPING = {
    'date_time'       => :datetime_picker,
    'short_text'      => :string,
    'text'            => :text,
    'multiple_choice' => :radio,
    'check_boxes'     => :check_boxes,
    'select'          => :select,
    'scale'           => :select
  }

  serialize :metadata

  validates_presence_of :question, :short_name, :question_type
  validates_inclusion_of :question_type, :in => VALID_TYPES

  validate :has_multiple_choices,      :if => :has_collection?
  validate :has_correct_scale_choices, :if => :scale?

  attr_accessible :editable_metadata, :question, :short_name, :question_type, :hint, :default_value, :required_by_default

  has_many :position_questions, :dependent => :destroy
  has_many :positions, :through => :position_questions

  def self.except_for(ids)
    ids = Array(ids).flatten.map(&:to_i).uniq.compact
    ids.empty?  ? scoped : where('id NOT IN (?)', ids)
  end

  def self.for_select
    select('question, id').map { |q| [q.question, q.id] }
  end

  def self.human_question_type_name(type)
    I18n.t type, :scope => 'ui.question_types', :default => type.to_s.humanize
  end

  def self.types_for_select
    VALID_TYPES.map do |type|
      [human_question_type_name(type), type]
    end
  end

  def editable_metadata
    if metadata.is_a?(Array)
      metadata * "\n"
    else
      metadata.to_s
    end
  end

  def editable_metadata=(value)
    if value.blank?
      value = nil
    elsif value.is_a?(String)
      value = normalise_array value
    end
    self.metadata = value
  end

  def human_question_type
    question_type.present? ? self.class.human_question_type_name(question_type) : nil
  end

  def to_formtastic_options(question)
    options = {:label => self.question, :as => FIELD_TYPE_MAPPING[question_type]}
    options[:input_html] = {:rows => 5} if text?
    options[:hint] = hint if hint.present?
    if has_collection?
      options[:collection] = Array(metadata).flatten
    elsif scale?
      options[:collection] = Array(scale_range).map(&:to_s)
    end
    if question.respond_to?(:required)
      options[:required] = (question.required.nil? ? required_by_default : question.required)
    end
    options
  end

  def has_collection?
    COLLECTION_TYPES.include?(question_type)
  end

  def normalise_value(value)
    return if value.blank?
    case question_type
    when "date_time", "text", "short_text"
      value.to_s
    when "select", "multiple_choice"
      value = value.to_s
      Array(metadata).include?(value) ? value : nil
    when "check_boxes"
      Array(metadata) & normalise_array(value)
    when "scale"
      int_value = Integer(value) rescue nil
      scale_range.include?(int_value) ? value : nil
    end
  end

  VALID_TYPES.each do |type|
    class_eval(<<-EOF, __FILE__, __LINE__)

      def #{type}?
        question_type == #{type.inspect}
      end

    EOF
  end

  def normalise_array(value)
    Array(value).map(&:strip).reject(&:blank?)
  end

  def scale_range
    return unless scale?
    options = Array(metadata).map(&:to_i)
    options.first..options.last
  end

  protected

  def has_multiple_choices
    if Array(metadata).length < 2
      errors.add :editable_metadata, :incorrect_number_of_choices, :message => 'needs at least 2 choices (1 per line)'
    end
  end

  def has_correct_scale_choices
    options = Array(metadata)
    if options.length != 2
      errors.add :editable_metadata, :needs_two_choices, :message => 'needs 2 choices (1 per line)'
    elsif !options.all? { |o| valid_integer? o }
      errors.add :editable_metadata, :choices_arent_numbers, :message => 'needs numbers as choices'
    elsif options[0].to_i >= options[1].to_i
      errors.add :editable_metadata, :choices_are_invalid, :message => 'must contain two, ordered numbers'
    end
  end

  def valid_integer?(number)
    Integer(number)
    true
  rescue ArgumentError
    false
  end

end
