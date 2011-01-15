module ContentHelper

  def content_section(key)
    Content[key].try(:content_as_html) || ''
  end
  
end
