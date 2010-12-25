require 'spec_helper'

describe PositionsController do

  render_views
  
  cleanup_after_models! Team, Position
  dataset :positions

  describe 'the index page' do
    
    it 'should only fetch published positions' do
      get :index
      assigns[:teams].should be_present
      assigns[:teams].map(&:positions).flatten.uniq.should =~ [positions(:published_1), positions(:published_2), positions(:published_3), positions(:published_4), positions(:mixed_published_1)]
    end
    
    it 'should assign the search object' do
      get :index
      assigns[:search].should be_present
    end

    it 'should let you filter the positions' do
      get :index, :position_search => {:team_ids => [teams(:published).id]}
      assigns[:teams].should =~ [teams(:published)]
      assigns[:teams].map(&:positions).flatten.uniq.should =~ [positions(:published_1), positions(:published_2), positions(:published_3), positions(:published_4)]
    end
    
    it 'should fetch teams with positions present' do
      get :index
      assigns[:teams].should =~ [teams(:published), teams(:mixed)]
    end
    
    it 'should render the index template' do
      get :index
      response.should render_template(:index)
    end
    
    it 'should render correctly' do
      get :index
      response.should be_successful
    end
    
  end
  
  describe 'the show page' do
    
    context 'with a published position' do
    
      let(:position) { positions(:published_1) }
    
      before :each do
        get :show, :id => position.to_param
      end
    
      it 'should assign the position' do
        assigns[:position].should == position
      end
    
      it 'should have the team assigned' do
        assigns[:team].should == position.team
      end
    
      it 'should render the show template' do
        response.should render_template(:show)
      end
    
      it 'should render correctly' do
        response.should be_successful
      end

    end
    
    shared_examples_for 'an unknown position' do
      
      before :each do
        get :show, :id => position.to_param
      end
      
      it 'should be not found' do
        response.status.should == 404
      end
      
      it 'should not render the template' do
        response.should_not render_template(:show)
      end
      
    end
    
    context 'with a non-existent position' do
      
      let(:position) { Position.make!.tap { |p| p.destroy } }
      
      it_should_behave_like 'an unknown position'
      
    end
    
    context 'with an expired position' do
      
      let(:position) { positions(:expired_1) }
      
      it_should_behave_like 'an unknown position'
      
    end
    
    context 'with a drafted position' do
      
      let(:position) { positions(:draft_1) }
      
      it_should_behave_like 'an unknown position'
      
    end
    
    context 'with an unpublished position' do
      
      let(:position) { positions(:unpublished_1) }
      
      it_should_behave_like 'an unknown position'
      
    end
    
  end

end
