require 'spec_helper'

describe PositionSearch do
  
  it 'should be a search sub class' do
    PositionSearch.should < Search
  end
  
  context 'setting up attributes' do
    
    it 'should correctly deal with no team id' do
      PositionSearch.new.team_ids.should == []
    end
    
    it 'should correctly deal with a blank team id' do
      PositionSearch.new(:team_ids => '').team_ids.should == []
    end
    
    it 'should correctly deal with a single team id' do
      PositionSearch.new(:team_ids => '1').team_ids.should =~ [1]
    end
    
    it 'should correctly deal with a multiple team ids' do
      PositionSearch.new(:team_ids => [1, 2, 3]).team_ids.should =~ [1, 2, 3]
    end
    
    it 'should correctly deal with team ids as strings' do
      PositionSearch.new(:team_ids => %w(1 2 3)).team_ids.should =~ [1, 2, 3]
    end
    
    it 'should correctly deal with team ids with blanks' do
      PositionSearch.new(:team_ids => ['', 1, '', '4']).team_ids.should =~ [1, 4]
    end
    
    it 'should correctly deal with team ids with duplicates of the same type' do
      PositionSearch.new(:team_ids => [1, 4, 1, 2]).team_ids.should =~ [1, 2, 4]
    end
    
    it 'should correctly deal with team ids with duplicates of different types' do
      PositionSearch.new(:team_ids => [1, 4, '1', 2]).team_ids.should =~ [1, 2, 4]
    end
    
    it 'should correctly set the query if present' do
      PositionSearch.new(:query => 'x').query.should == 'x'
    end
    
    it 'should correctly set the query if blank' do
      PositionSearch.new(:query => '').query.should be_nil
    end
    
    it 'should correctly set the query if absent' do
      PositionSearch.new.query.should be_nil
    end
    
  end
  
  context 'building the relationship' do
    
    let(:relation) do
      Object.new.tap do |r|
        stub(Position).viewable { r }
      end
    end
    
    it 'should use Position.viewable as the base' do
      mock(Position).viewable { relation }
      PositionSearch.new.to_relation.should == relation
    end
    
    it 'should use use with_query if a query is given' do
      mock(relation).with_query('my query') { relation }
      PositionSearch.new(:query => 'my query').to_relation
    end
    
    it 'should not use with_query without a query' do
      dont_allow(relation).with_query.with_any_args
      PositionSearch.new(:query => '').to_relation
    end
    
    it 'should add team ids if present' do
      mock(relation).where(:team_id => [1, 2, 3]) { relation }
      PositionSearch.new(:team_ids => [1, 2, 3]).to_relation
    end
    
    it 'should not add team ids with an empty team ids list' do
      dont_allow(relation).where(:team_id => anything)
      PositionSearch.new(:team_ids => []).to_relation
      # Add a specific check for the commont formtastic + radio buttons case.
      PositionSearch.new(:team_ids => ['']).to_relation
    end
    
  end
  
end