require 'spec_helper'

describe Search do
  
  class SearchMinusSetup < Search
    def setup; end
  end
  
  context 'acting like an activemodel object' do
    include ActiveModel::Lint::Tests
    
    before :each do
      @model = SearchMinusSetup.new
      def @model.build_relation() nil; end
    end
    
    it 'should correctly deal with to_key' do
      test_to_key
    end
    
    it 'should correctly deal with to_param' do
      test_to_param
    end
    
    it 'should correctly implement naming' do
      test_model_naming
    end
    
    it 'should correctly implement persisted?' do
      test_persisted?
    end

  end
  
  context 'getting a search objects attributes' do
    
    let(:search) do
      SearchMinusSetup.new :field_a => 'some field', :field_b => 42,
        :field_c => '', :field_d => nil
    end
    
    it 'should let you get the value of an attribute' do
      search.attr(:field_a).should == 'some field'
      search.attr(:field_b).should == 42
    end
    
    it 'should return nil for blank attributes' do
      search.attr(:field_c).should == nil
      search.attr(:field_d).should == nil
    end
    
    it 'should let you specify a default' do
      search.attr(:field_c, 'Hello').should == 'Hello'
      search.attr(:field_d, 200).should == 200
    end
    
    it 'should ignore the default with a present value' do
      search.attr(:field_a, 'another field').should == 'some field'
      search.attr(:field_b, 9001).should == 42
    end
    
    it 'should let you specify a default block' do
      search.attr(:field_c) { 'Oh Hai'}.should == 'Oh Hai'
      o = Object.new
      mock(o).name { 1000 }
      search.attr(:field_d) { o.name }.should == 1000
    end
    
    it 'should correctly symbolize the key' do
      search.attr('field_a').should == search.attr(:field_a)
      search.attr('field_b').should == search.attr(:field_b)
    end
    
  end
  
  context 'setting up a search' do
    
    it 'should call a setup method' do
      mock.instance_of(Search).setup
      Search.new({})
    end
    
    it 'should default to not being implemented' do
      expect { Search.new({}) }.to raise_error(NotImplementedError)
    end
    
    it 'should assign attributes correctly' do
      search = SearchMinusSetup.new :a => 1, :b => 2
      search.attributes.should == {:a => 1, :b => 2}
    end
  
    it 'should symbolize hash keys' do
      search = SearchMinusSetup.new 'a' => 1, 'b' => 2
      search.attributes.should == {:a => 1, :b => 2}
    end
  
    it 'should ignore non-hash arguments' do
      search = SearchMinusSetup.new %w(a b c)
      search.attributes.should == {}
    end
    
  end
  
  context 'using the relation' do
    
    let :search do
      SearchMinusSetup.new :a => 1, :b => 'something else'
    end
    
    it 'should have a to_relation method' do
      search.should respond_to(:to_relation)
    end
    
    it 'should have a build_relation method' do
      search.should respond_to(:build_relation)
    end
    
    it 'should default to not being implemented for build_relation' do
      expect { search.build_relation }.to raise_error(NotImplementedError)
    end
    
    it 'should use build_relation to set the to relation method' do
      relation = Object.new
      mock(search).build_relation { relation }
      search.to_relation.should == relation
    end
    
    it 'should not call build_relation if the relation is set' do
      search.relation = Object.new
      dont_allow(Search).build_relation
      search.to_relation.should == search.relation
    end
    
    context 'with build_relation implemented' do
      
      let(:relation) { Object.new }
      
      before :each do
        stub(search).build_relation.returns relation
      end
      
      it 'should proxy unknown methods to the relation' do
        result = Object.new
        mock(relation).find(1) { result }
        search.find(1).should == result
      end
      
      it 'should still raise exceptions correctly for unknown methods' do
        stub(relation).respond_to?(:blah_blah_blah) { false }
        expect { search.blah_blah_blah }.to raise_error(NoMethodError)
      end

      it 'should not call respond to on the relation if the method is defined locally' do
        pending # FIXME: rr proxying with respond_to etc
        dont_allow(relation).respond_to?.with_any_args
        search.respond_to? :setup
      end

      it 'should proxy respond to' do
        pending # FIXME: rr proxying with respond_to etc
        mock(relation).respond_to?(:test_method, false)
        search.respond_to? :test_method, false
      end

    end
    
  end
  
end
