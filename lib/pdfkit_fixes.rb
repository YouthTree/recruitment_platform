PDFKit::Middleware.class_eval do
  
  def call_with_ivar_safety(env)
    dup.call_without_ivar_safety env
  end
  
  alias_method_chain :call, :ivar_safety
  
end