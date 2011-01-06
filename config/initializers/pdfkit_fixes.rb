PDFKit::Middleware.class_eval do
  
  def call_with_type_reset(env)
    call_without_type_reset env
  ensure
    @render_pdf = false
    @request    = nil
  end
  
  alias_method_chain :call, :type_reset
  
end