class Search
  extend ActiveModel::Naming  
  extend ActiveModel::Translation
  include ActiveModel::Conversion
  
  attr_reader :attributes
  attr_accessor :relation
  
  def initialize(attributes = {})
    @attributes = (attributes.is_a?(Hash) ? attributes.symbolize_keys : {})
    setup
  end
  
  # Like @attributes.fetch but it will check the presence of the argument.
  def attr(key, default = nil, &blk)
    value = attributes[key.to_sym]
    if value.blank?
      block_given? ? yield : default
    else
      value
    end
  end
  
  def setup
    raise NotImplementedError, 'Implement this in a child class.'
  end
  
  def build_relation
    raise NotImplementedError, 'Implement this in a child class.'
  end
  
  def to_relation
    @relation || build_relation
  end
  
  def respond_to?(method, include_private = false)
    super || to_relation.respond_to?(method, include_private)
  end
  
  def method_missing(method, *args, &blk)
    if to_relation.respond_to?(method)
      to_relation.send method, *args, &blk
    else
      super
    end
  end
  
  def persisted?
    false
  end
  
  def self.i18n_scope
    :search
  end

end