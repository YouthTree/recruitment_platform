module AdminHelper

  def new_application_count
    @new_application_count ||= PositionApplication.since(current_user.last_sign_in_at).submitted.size
  end
  
  def clicky_meta_tags
    clicky = Settings.clicky
    extra_head_content(meta_tag("clicky-site-id", clicky.site_id))   if clicky.site_id?
    extra_head_content(meta_tag("clicky-site-key", clicky.site_key)) if clicky.site_key?
    nil
  end

end
