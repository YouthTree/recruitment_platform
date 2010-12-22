require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery

  include TitleEstuary

  use_controller_exts :title_estuary, :translation
  
  alias require_user authenticate_user!
  
  rescue_from ActiveRecord::RecordNotFound do |e|
    render :file => Rails.root.join('public', '404.html'), :status => :not_found
  end

end
