require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery

  include TitleEstuary

  use_controller_exts :title_estuary, :translation
  
end
