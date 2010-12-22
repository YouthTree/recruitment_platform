class PositionsDataset < Dataset::Base
  
  def load
    name_model Team.make!, :published
    name_model Team.make!, :expired
    name_model Team.make!, :mixed
    name_model Team.make!, :unpublished
    name_model Team.make!, :draft
    
    create_positions :published do |t|
      Position.make! :team => t
    end
    
    create_positions :expired do |t|
      Position.make! :expired, :team => t
    end
    
    create_positions :draft do |t|
      Position.make! :draft, :team => t
    end
    
    create_positions :unpublished, 1 do |t|
      Position.make! :unpublished, :team => t
    end
    
    # All of the mixed states.
    
    create_positions :mixed, 1, :mixed_draft do |t|
      Position.make! :draft, :team => t
    end
    
    create_positions :mixed, 1, :mixed_expired do |t|
      Position.make! :expired, :team => t
    end
    
    create_positions :mixed, 1, :mixed_unpublished do |t|
      Position.make! :unpublished, :team => t
    end
    
    create_positions :mixed, 1, :mixed_published do |t|
      Position.make! :team => t
    end
    
    
  end
  
  def create_positions(name, count = 4, field_name = name)
    parent = find_model(:team, name)
    1.upto(count) do |i|
      record = yield parent
      name_model record, :"#{field_name}_#{i}"
    end
  end
  
end