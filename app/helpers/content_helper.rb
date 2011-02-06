module ContentHelper

  def content_section(key, options = {})
    content = Content[normalized_content_scope(key, options.delete(:scope))]
    div_options = options_with_class_merged(options, :class => "embedded-content #{key.to_s.gsub(".", "-")}")
    content_tag(:div, content.try(:content_as_html).to_s, div_options)
  end

  alias cs content_section
  
  def meta_content(name)
    cs = Content["meta.#{name}"]
    if cs.present?
      tag :meta, :name => name.to_s, :content => cs.content
    end
  end

end
