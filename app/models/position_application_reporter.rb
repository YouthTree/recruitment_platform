require 'fastercsv'

class PositionApplicationReporter
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  
  attr_reader :position, :base_scope
  
  MODEL_FIELDS = %w(full_name email_address phone)
  
  def initialize(position, options = {})
    @position        = position
    @base_scope      = position.applications
    @options         = options.is_a?(Hash) ? options : {}
    @question_fields = position.questions.map { |q| [q.short_name, "question_#{q.id}"] }
  end
  
  def build_csv(into = "")
    csv = FasterCSV.new(into, :headers => field_labels, :write_headers => true)
    base_scope.find_each do |app|
      csv << fields.map { |field| lookup_field app, field }
    end
  end
  
  def to_csv(into = "")
    into.tap { |destination| build_csv destination }
  end
  
  def fields
    fields = option_array(:fields)
    available_fields = self.available_field_names
    if fields.present?
      # Use & to get a list of acceptible field names.
      available_fields & fields
    else
      available_fields
    end
  end
  
  def lookup_field(application, row_name)
    if MODEL_FIELDS.include? row_name
      application.send(row_name).to_s
    else
      application.answers.send(row_name).to_s
    end
  end
  
  def option_array(key)
    Array(@options[key]).flatten.reject(&:blank?).map(&:to_s).uniq
  end
  
  def available_field_names
    MODEL_FIELDS + @question_fields.map(&:last)
  end
  
  def available_field_options
    @available_field_options ||= begin
      base = MODEL_FIELDS.map { |f| [PositionApplication.human_attribute_name(f), f] }
      base += @question_fields
      base
    end
  end
  
  def field_labels
    fields.map do |field|
      if MODEL_FIELDS.include? field
        PositionApplication.human_attribute_name field
      else
        @question_fields.find { |f| f.last == field }.first
      end
    end
  end
  
  def persisted?
    false
  end
  
end