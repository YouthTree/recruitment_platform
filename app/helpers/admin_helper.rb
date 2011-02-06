module AdminHelper

  def new_application_count
    @new_application_count ||= PositionApplication.since(current_user.last_sign_in_at).submitted.size
  end

end
