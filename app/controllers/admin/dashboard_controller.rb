class Admin::DashboardController < AdminController
  
  def index
    @since_last_visit = base_app_scope.since(current_user.last_sign_in_at).all
    @most_recent      = base_app_scope.all
  end

  def base_app_scope
    PositionApplication.ordered.limit(5).submitted.includes(:position => :team)
  end
  
end
