require 'spec_helper'

describe PositionsController do

  render_views
  
  cleanup_after_models! Team, Position
  dataset :positions

  describe 'the index page' do
    
    it 'should only fetch published positions' do
      get :index
      assigns[:positions].should be_present
      assigns[:positions].flatten.uniq.should =~ [positions(:published_1), positions(:published_2), positions(:published_3), positions(:published_4), positions(:mixed_published_1)]
    end
    
    it 'should assign the search object' do
      get :index
      assigns[:search].should be_present
    end

    it 'should let you filter the positions' do
      get :index, :position_search => {:team_ids => [teams(:published).id]}
      assigns[:positions].map(&:team).uniq.should =~ [teams(:published)]
      assigns[:positions].should =~ [positions(:published_1), positions(:published_2), positions(:published_3), positions(:published_4)]
    end
    
    it 'should fetch positions with teams present' do
      get :index
      assigns[:positions].map(&:team).uniq.should =~ [teams(:published), teams(:mixed)]
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
    
    shared_examples_for 'a known position' do

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
    
    context 'with a published position' do

      let(:position) { positions(:published_1) }

      it_should_behave_like 'a known position'

    end

    context 'with a non-existent position' do
      
      let(:position) { Position.make!.tap { |p| p.destroy } }
      
      it_should_behave_like 'an unknown position'
      
    end
    
    context 'when not signed in' do

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
    
    context 'when signed in' do
      
      before :each do
        stub(controller).user_signed_in? { true }
      end
      
      context 'with an expired position' do

        let(:position) { positions(:expired_1) }

        it_should_behave_like 'a known position'

      end

      context 'with a drafted position' do

        let(:position) { positions(:draft_1) }

        it_should_behave_like 'a known position'

      end

      context 'with an unpublished position' do

        let(:position) { positions(:unpublished_1) }

        it_should_behave_like 'a known position'

      end
      
    end
    
  end

  shared_examples_for 'viewing the apply page' do

    it 'should assign the position' do
      assigns[:position].should be_present
      assigns[:position].should == position
    end

    it 'should assign the team' do
      assigns[:team].should be_present
      assigns[:team].should == teams(:published)
    end

    it 'should assign the position application' do
      assigns[:position_application].should be_present
      assigns[:position_application].should be_kind_of(PositionApplication)
    end

    it 'should have a new position application record' do
      assigns[:position_application].should be_new_record
      assigns[:position_application].position.should == position
    end

    it 'should render the apply template' do
      response.should render_template(:apply)
    end

    it 'should be successfuly' do
      response.should be_successful
    end

  end

  describe 'the apply page' do

    let(:position) { positions(:published_1) }

    before(:each) { get :apply, :id => position.to_param }

    it_should_behave_like 'viewing the apply page'

  end

  describe 'applying for a position' do

    let(:position) { positions(:published_1) }

    before :each do
      stub.instance_of(PositionApplication).save { save_result }
      post :apply, :id => position.to_param
    end

    context 'when successfully applying' do

      let(:save_result) { true }

      it 'should redirect to root' do
        response.should be_redirect
        response.should redirect_to [:applied, position]
      end

    end

    context 'when unsucessfully applying' do

      let(:save_result) { false }

      it_should_behave_like 'viewing the apply page'

    end

  end

end
