module AdminHelper

  def new_application_count
    PositionApplication.where(:created_at.gt => current_user.last_sign_in_at).count
  end

end
