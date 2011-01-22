require 'spec_helper'

describe PositionApplicationsController do

  render_views
  cleanup_after_models! Team, Position
  dataset               :positions

  shared_examples_for 'viewing the edit application page' do

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

    it 'should have a position application record' do
      assigns[:position_application].should_not be_new_record
      assigns[:position_application].position.should == position
    end

    it 'should render the apply template' do
      response.should render_template(:edit)
    end

    it 'should be successfuly' do
      response.should be_successful
    end

  end

  let(:position) { positions(:published_1) }

  describe 'the start application page' do

    it 'should create a new position application' do
      expect do
        post :create, :position_id => position.to_param
      end.to change(PositionApplication, :count).by(1)
      PositionApplication.last.position.should == position
    end

    it 'should redirect to the edit page' do
      post :create, :position_id => position.to_param
      response.should be_redirect
      response.should redirect_to edit_position_position_application_path(position, PositionApplication.last)
    end

  end


  context 'with an application' do

    let(:position_application) { position.applications.create }
    let(:valid_attributes)     { {:full_name => "Bob Smith", :email_address_attributes => {:email => 'test@example.com'}, :phone => '0000000000'} }
    let(:invalid_attributes)   { {:full_name => "" } }

    describe 'getting an application' do

      context 'when the application has been submitted' do

        before(:each) { position_application.update_attribute :state, 'submitted' }

        it 'should redirect to the applied page' do
          get :show, :position_id => position.id, :id => position_application.to_param
          response.should be_redirect
          response.should redirect_to(applied_position_position_application_path(position, position_application))
        end

      end

      context 'when the application is created' do

        it 'should redirect to the edit page' do
          get :show, :position_id => position.id, :id => position_application.to_param
          response.should be_redirect
          response.should redirect_to(edit_position_position_application_path(position, position_application))
        end

      end

    end

    describe 'editing an application' do

      context 'when the application has been submitted' do

        before(:each) { position_application.update_attribute :state, 'submitted' }

        it 'should redirect to the applied page' do
          get :edit, :position_id => position.id, :id => position_application.to_param
          response.should be_redirect
          response.should redirect_to(applied_position_position_application_path(position, position_application))
        end

      end

      context 'when the application is created' do

        before(:each) do
          get :edit, :position_id => position.id, :id => position_application.to_param
        end

        it_should_behave_like 'viewing the edit application page'

      end

    end

    describe 'saving an application' do

      context 'when the application has been submitted' do

        before(:each) { position_application.update_attribute :state, 'submitted' }

        it 'should redirect to the applied page' do
          put :update, :position_id => position.id, :id => position_application.to_param
          response.should be_redirect
          response.should redirect_to(applied_position_position_application_path(position, position_application))
        end

      end

      context 'when the application successfully saves' do

        before :each do
          put :update, :position_id => position.id, :id => position_application.to_param, :position_application => valid_attributes
        end

        it_should_behave_like 'viewing the edit application page'


        it 'should not be submitted' do
          PositionApplication.find(position_application.id).should_not be_submitted
        end
      end

      context 'when the application is invalid' do

        before :each do
          put :update, :position_id => position.id, :id => position_application.to_param, :position_application => invalid_attributes
        end

        it_should_behave_like 'viewing the edit application page'

        it 'should not be submitted' do
          PositionApplication.find(position_application.id).should_not be_submitted
        end

      end

    end

    describe 'submitting an application' do

      let(:event_attributes) { {:state_event => 'submit'} }

      context 'when the application has been submitted' do

        before(:each) { position_application.update_attribute :state, 'submitted' }

        it 'should redirect to the applied page' do
          put :update, :position_id => position.id, :id => position_application.to_param, :position_application => event_attributes
          response.should be_redirect
          response.should redirect_to(applied_position_position_application_path(position, position_application))
        end

      end

      context 'when the application successfully saves' do

        before :each do
          put :update, :position_id => position.id, :id => position_application.to_param, :position_application => event_attributes.merge(valid_attributes)
        end

        it 'should redirect successfully' do
          response.should be_redirect
          response.should redirect_to(applied_position_position_application_path(position, position_application))
        end

        it 'should be submitted' do
          PositionApplication.find(position_application.id).should be_submitted
        end

      end

      context 'when the application is invalid' do

        before :each do
          put :update, :position_id => position.id, :id => position_application.to_param, :position_application => event_attributes.merge(invalid_attributes)
        end

        it_should_behave_like 'viewing the edit application page'

        it 'should not be submitted' do
          PositionApplication.find(position_application.id).should_not be_submitted
        end

      end

    end

  end

  describe 'viewing the applied page'

  # describe 'applying for a position' do
  #
  #     let(:position) { positions(:published_1) }
  #
  #     before :each do
  #       stub.instance_of(PositionApplication).save { save_result }
  #       post :apply, :id => position.to_param
  #     end
  #
  #     context 'when successfully applying' do
  #
  #       let(:save_result) { true }
  #
  #       it 'should redirect to root' do
  #         response.should be_redirect
  #         response.should redirect_to [:applied, position]
  #       end
  #
  #     end
  #
  #     context 'when unsucessfully applying' do
  #
  #       let(:save_result) { false }
  #
  #       it_should_behave_like 'viewing the apply page'
  #
  #     end
  #
  #   end


end
