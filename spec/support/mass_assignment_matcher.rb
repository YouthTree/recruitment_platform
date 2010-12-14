module MassAssignmentMatcher
  class Matcher
    
    def initialize(*args)
      @attributes     = Array(args).flatten.reject(&:blank?).map(&:to_s).uniq.sort
      @attribute_hash = @attributes.inject({}) do |h, k|
        h[k] = 'some random value'; h
      end
    end
    
    def matches?(target)
      @model = target
      BHM::Admin.silence_attr_accessible do
        @assigned = @model.send(:sanitize_for_mass_assignment, @attribute_hash).keys.sort.uniq
      end
      @assigned.size == @attributes.size
    end
    
    def failure_message_for_should
      "expected #{@model.inspect} to allow mass assignment of #{(@attributes - @assigned).join(", ")} but it did not."
    end
    
    def failure_message_for_should_not
      "expected #{@model.inspect} to not allow mass assignment of #{@assigned.join(", ")} but it did."
    end
    
    def description
      "allow mass assignment of #{@attributes.to_sentence}"
    end
    
  end
  
  def allow_mass_assignment_of(*args)
    Matcher.new *args
  end
  
end