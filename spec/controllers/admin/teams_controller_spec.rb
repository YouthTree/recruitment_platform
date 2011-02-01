require 'spec_helper'

describe Admin::TeamsController do

  render_views

  describe '#reorder' do
    before :each do
      @user = User.make!
      sign_in @user
    end

    context 'no ids are supplied' do
      it 'wont call update_order' do
        dont_allow(Team).update_order
        put :reorder
      end
    end

    context 'ids are supplied' do
      it 'will call update_order' do
        mock(Team).update_order('1, 2')
        put :reorder, :team_ids => '1, 2'
      end
    end

    it 'redirects to admin_teams' do
      put :reorder
      response.should redirect_to(:admin_teams)
    end
  end
end
