module ApplicationHelper
  
  def ie_html(attrs={}, &block)
    name = :html
    attrs.symbolize_keys!
    haml_concat("<!--[if lt IE 7 ]> #{ tag(name, css_class('ie6', attrs), true) } <![endif]-->".html_safe)
    haml_concat("<!--[if IE 7 ]>    #{ tag(name, css_class('ie7', attrs), true) } <![endif]-->".html_safe)
    haml_concat("<!--[if IE 8 ]>    #{ tag(name, css_class('ie8', attrs), true) } <![endif]-->".html_safe)
    haml_concat("<!--[if IE 9 ]>    #{ tag(name, css_class('ie9', attrs), true) } <![endif]-->".html_safe)
    haml_concat("<!--[if (gt IE 9)|!(IE)]><!-->".html_safe)
    haml_tag name, attrs do
      haml_concat("<!--<![endif]-->".html_safe)
      block.call
    end
  end
  
  def css_class(klass, options)
    options.merge :class => [options[:class], klass].join(' ').strip
  end
  
  def render_nested_form(form, association, partial_name)
    object = form.object
    child = object.class.reflect_on_association(association).klass.new
    form.fields_for(association, child, :child_index => 'NEW_IDX') do |child_form|
      render :partial => partial_name, :object => child_form
    end
  end
  
  def from_radiant(name)
    RadiantContent[name]
  end
  
  def email_for(position, options = {})
    email_address = position.contact_emails.first
    if email_address.present?
      address = email_address.email
      mail_to address, nil, options
    end
  end

end
