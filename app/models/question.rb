class Question < ActiveRecord::Base
  
  VALID_TYPES      = %w(date_time short_text text multiple_choice check_boxes select scale)
  COLLECTION_TYPES = %w(multiple_choice check_boxes select)
  
  FIELD_TYPE_MAPPING = {
    'date_time'       => :datetime_picker,
    'short_text'      => :string,
    'text'            => :text,
    'multiple_choice' => :radio_buttons,
    'check_boxes'     => :check_boxes,
    'select'          => :select
  }

  serialize :metadata

  validates_presence_of :question, :short_name, :question_type
  validates_inclusion_of :question_type, :in => VALID_TYPES

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
      value = Array(value).map(&:strip).reject(&:blank?)
    end
    self.metadata = value
  end

  def human_question_type
    question_type.present? ? self.class.human_question_type_name(question_type) : nil
  end

  def to_formtastic_options(answer)
    options = {:label => question, :as => FIELD_TYPE_MAPPING[question_type]}
    options[:hint] = hint if hint.present?
    options[:collection] = Array(metadata).flatten if has_collection?
    if answer.respond_to?(:required)
      options[:required] = (answer.required.nil? ? required_by_default : answer.required)
    end
    options
  end

  def has_collection?
    COLLECTION_TYPES.include?(question_type)
  end

  VALID_TYPES.each do |type|
    class_eval(<<-EOF, __FILE__, __LINE__)

      def #{type}?
        question_type == #{type.inspect}
      end

    EOF
  end

end

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

