class PositionSearch < Search
  
  attr_reader :team_ids, :query
  
  def setup
    @query    = attr(:query)
    @team_ids = Array(attr(:team_ids)).flatten.reject(&:blank?).map(&:to_i).uniq 
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