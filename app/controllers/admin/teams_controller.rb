class Admin::TeamsController < Admin::BaseController
  
  use_controller_exts :slugged_resource

  def reorder
    Team.update_order(params[:team_ids]) if params[:team_ids]
    redirect_to :admin_teams
  end

  protected

  def end_of_association_chain
    super.in_order
  end
  
end
