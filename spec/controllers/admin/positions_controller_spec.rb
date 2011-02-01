require 'spec_helper'

describe Admin::PositionsController do

  render_views
  
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

  describe '#reorder' do
    before :each do
      @user = User.make!
      sign_in @user
    end

    context 'no ids are supplied' do
      it 'wont call update_order' do
        dont_allow(Position).update_order
        put :reorder
      end
    end

    context 'ids are supplied' do
      it 'will call update_order' do
        mock(Position).update_order('1, 2')
        put :reorder, :position_ids => '1, 2'
      end
    end

    it 'redirects to admin_positions' do
      put :reorder
      response.should redirect_to(:admin_positions)
    end
  end

end
