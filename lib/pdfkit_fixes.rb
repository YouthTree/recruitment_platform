PDFKit::Middleware.class_eval do
  
  def call_with_type_reset(env)
    call_without_type_reset env
  ensure
    reset_env_vars!
  end
  
  def reset_env_vars!
    @render_pdf = false
    @request    = nil
  end
  
  alias_method_chain :call, :type_reset
  
end