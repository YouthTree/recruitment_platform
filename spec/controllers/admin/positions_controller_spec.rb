require 'spec_helper'

describe Admin::PositionsController do
  
  describe 'finding a resource' do
    
    let(:position) { Position.make! }
    let(:resource) { controller.send(:resource) }
    
    it 'should use the correct finder' do
      # This is kind of horrible, but afaik the cleanest way to mock it all out.
      mock(controller).end_of_association_chain.mock!.with_questions.mock!.find_using_slug!(position.to_param) { position }
      get :show, :id => position.to_param
      resource.should == position
    end
    
  end
  
  describe 'cloning a resource' do

    let(:position) { Position.make! }
    let(:resource) { controller.send(:build_resource_for_cloning) }

    it 'should correctly initialize the object' do
      object = position.clone_for_editing
      stub(controller).end_of_association_chain.mock!.with_questions.mock!.find_using_slug!(position.to_param) { position }
      mock(position).clone_for_editing { object }
      get :clone_position, :id => position.to_param
      resource.should equal object
    end

  end

end