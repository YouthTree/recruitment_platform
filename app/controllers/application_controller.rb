class ApplicationController < ActionController::Base
  protect_from_forgery

  include TitleEstuary

  use_controller_exts :title_estuary, :translation
  
end
