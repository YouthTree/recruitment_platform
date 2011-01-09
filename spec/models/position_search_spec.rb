require 'spec_helper'

describe PositionSearch do
  
  let(:viewable) do
    Object.new.tap { |i| stub(Position).viewable { i } }
  end
  let(:base) { viewable }

  it 'should be a search sub class' do
    PositionSearch.should < Search
  end
  
  context 'setting up attributes' do
    
    it 'should correctly deal with no team id' do
      PositionSearch.new(base).team_ids.should == []
    end
    
    it 'should correctly deal with a blank team id' do
      PositionSearch.new(base, :team_ids => '').team_ids.should == []
    end
    
    it 'should correctly deal with a single team id' do
      PositionSearch.new(base, :team_ids => '1').team_ids.should =~ [1]
    end
    
    it 'should correctly deal with a multiple team ids' do
      PositionSearch.new(base, :team_ids => [1, 2, 3]).team_ids.should =~ [1, 2, 3]
    end
    
    it 'should correctly deal with team ids as strings' do
      PositionSearch.new(base, :team_ids => %w(1 2 3)).team_ids.should =~ [1, 2, 3]
    end
    
    it 'should correctly deal with team ids with blanks' do
      PositionSearch.new(base, :team_ids => ['', 1, '', '4']).team_ids.should =~ [1, 4]
    end
    
    it 'should correctly deal with team ids with duplicates of the same type' do
      PositionSearch.new(base, :team_ids => [1, 4, 1, 2]).team_ids.should =~ [1, 2, 4]
    end
    
    it 'should correctly deal with team ids with duplicates of different types' do
      PositionSearch.new(base, :team_ids => [1, 4, '1', 2]).team_ids.should =~ [1, 2, 4]
    end
    
    it 'should correctly deal with the tags with strings' do
      PositionSearch.new(base, :tags => ['a', 'b', 'c']).tags.should =~ %w(a b c)
    end

    it 'should correctly deal with the tags with blanks' do
      PositionSearch.new(base, :tags => ['a', 'b', '', 'c']).tags.should =~ %w(a b c)
    end

    it 'should correctly deal with the tags with a single string' do
      PositionSearch.new(base, :tags => 'b').tags.should =~ %w(b)
    end

    it 'should correctly deal with the tags with duplicate strings' do
      PositionSearch.new(base, :tags => ['a', 'b', 'b']).tags.should =~ %w(a b)
    end

    it 'should correctly set the query if present' do
      PositionSearch.new(base, :query => 'x').query.should == 'x'
    end
    
    it 'should correctly set the query if blank' do
      PositionSearch.new(base, :query => '').query.should be_nil
    end
    
    it 'should correctly set the query if absent' do
      PositionSearch.new(base).query.should be_nil
    end
    
  end
  
  context 'building the relationship' do
    
    let(:relation) { viewable }
    
    it 'should use the given base' do
      PositionSearch.new(base).to_relation.should == base
    end
    
    it 'should use use with_query if a query is given' do
      mock(relation).with_query('my query') { relation }
      PositionSearch.new(base, :query => 'my query').to_relation
    end
    
    it 'should not use with_query without a query' do
      dont_allow(relation).with_query.with_any_args
      PositionSearch.new(base, :query => '').to_relation
    end
    
    it 'should use tagged with when tags are present' do
      mock(relation).tagged_with(%w(a b c)) { relation }
      PositionSearch.new(base, :tags => %w(a b c)).to_relation
    end

    it 'should not use tagged with without tags' do
      dont_allow(relation).tagged_with.with_any_args
      PositionSearch.new(base, :tags => '').to_relation
      PositionSearch.new(base).to_relation
      PositionSearch.new(base, :tags => ['']).to_relation
      PositionSearch.new(base, :tags => ['  ']).to_relation
    end

    it 'should add team ids if present' do
      mock(relation).where(:team_id => [1, 2, 3]) { relation }
      PositionSearch.new(base, :team_ids => [1, 2, 3]).to_relation
    end
    
    it 'should not add team ids with an empty team ids list' do
      dont_allow(relation).where(:team_id => anything)
      PositionSearch.new(base, :team_ids => []).to_relation
      # Add a specific check for the commont formtastic + radio buttons case.
      PositionSearch.new(base, :team_ids => ['']).to_relation
    end
    
  end
  
end