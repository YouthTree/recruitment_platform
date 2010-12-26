class PositionSearch < Search
  
  attr_reader :team_ids, :query
  
  def setup
    @query    = attr(:query)
    @team_ids = value_to_array(attr(:team_ids), &:to_i)
  end
  
  def build_relation
    relation = base_relation
    # Add the conditions on this search.
    relation = relation.with_query(query) if query.present?
    relation = relation.where(:team_id => team_ids) if team_ids.present?
    # Return an AR::Relation
    relation
  end
  
end