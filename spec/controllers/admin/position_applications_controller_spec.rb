require 'spec_helper'

describe Admin::PositionApplicationsController do
  
  describe 'the association chain' do
    
    let(:application) { PositionApplication.make! }
    let(:position)    { application.position }
    let(:resource)    { controller.send(:resource) }
    
    it 'should have the correct association chain' do
      mock(Position).find_using_slug!(position.to_param) { position }
      mock(position).applications.mock!.includes(:email_address).mock!.submitted.mock!.from_searchable_identifier!(application.to_param) { application }
      get :show, :position_id => position.to_param, :id => application.to_param
      resource.should == application
    end
    
  end
  
end