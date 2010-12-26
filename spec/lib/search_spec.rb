require 'spec_helper'

describe Search do
  
  class SearchMinusSetup < Search
    def setup; end

    public :value_to_array, :value_to_boolean

  end
  
  context 'passing in the base scope' do

    it 'should accept the base_relation as the first argument' do
      base_relation = Object.new
      SearchMinusSetup.new(base_relation).base_relation.should == base_relation
    end

    it 'should require the base_relation' do
      expect { SearchMinusSetup.new }.to raise_error(ArgumentError)
    end

  end

  context 'acting like an activemodel object' do
    include ActiveModel::Lint::Tests
    
    before :each do
      @model = SearchMinusSetup.new nil
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
      SearchMinusSetup.new Object.new, :field_a => 'some field', :field_b => 42,
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
      Search.new(Object.new, {})
    end
    
    it 'should default to not being implemented' do
      expect { Search.new(Object.new, {}) }.to raise_error(NotImplementedError)
    end
    
    it 'should assign attributes correctly' do
      search = SearchMinusSetup.new Object.new, :a => 1, :b => 2
      search.attributes.should == {:a => 1, :b => 2}
    end
  
    it 'should symbolize hash keys' do
      search = SearchMinusSetup.new Object.new, 'a' => 1, 'b' => 2
      search.attributes.should == {:a => 1, :b => 2}
    end
  
    it 'should ignore non-hash arguments' do
      search = SearchMinusSetup.new Object.new, %w(a b c)
      search.attributes.should == {}
    end
    
  end
  
  context 'using the relation' do
    
    let :search do
      SearchMinusSetup.new Object.new, :a => 1, :b => 'something else'
    end
    
    it 'should have a to_relation method' do
      search.should respond_to(:to_relation)
    end
    
    it 'should have a build_relation method' do
      search.should respond_to(:build_relation)
    end
    
    it 'should default to returning the base relation for build_relation' do
      search.build_relation.should == search.base_relation
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
        def relation.respond_to?(method, include_private = false)
          raise StandardError, 'should not be true' if method == :setup
          super
        end
        search.respond_to? :setup
      end

      it 'should proxy respond to' do
        def relation.respond_to?(method, include_private = false)
          return true if method == :test_method_two
          false
        end
        search.should respond_to(:test_method_two)
      end

    end
    
  end
  
  context 'normalising search arguments' do

    let(:search) { SearchMinusSetup.new(nil) }

    describe 'the value_to_boolean' do

      it 'should use the built in ActiveRecord type convertors' do
        mock(ActiveRecord::ConnectionAdapters::Column).value_to_boolean anything
        search.value_to_boolean 1
      end

      it 'should return the correct values to get true' do
        [1, "1", "true", true].each do |value|
          search.value_to_boolean(value).should == true
        end
      end

      it 'should return the correct values to get false' do
        [0, "0", false, "false", nil].each do |value|
          search.value_to_boolean(value).should == false
        end
      end

      it 'should return the correct values to get nil' do
        ['', "   "].each do |value|
          search.value_to_boolean(value).should == nil
        end
      end

    end

    describe 'the value_to_array method' do

      it 'should take an optional type convertor block' do
        array = %w(a b c)
        array.each { |i| mock(i).to_something.returns rand(1000) }
        search.value_to_array(array) { |i| i.to_something }
      end

      it 'should return a flattened array' do
        search.value_to_array([1, [2, [3]]]).should == [1, 2, 3]
      end

      it 'should uniqify the array' do
        search.value_to_array([1, 2, 1, 4]).should == [1, 2, 4]
      end

      it 'should remove blank values' do
        search.value_to_array([1, '', 2, nil]).should == [1, 2]
      end

      it 'should correctly convert nil' do
        search.value_to_array(nil).should == []
      end

      it 'should correctly convert an existing array' do
        search.value_to_array([1, 2]).should == [1, 2]
      end

      it 'should correctly convert blank attributes' do
        search.value_to_array('').should == []
      end

    end

  end

end
