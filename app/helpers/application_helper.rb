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

  def position_expiry_time(position)
    return if position.expires_at.blank?
    time = distance_of_time_in_words position.expires_at, Time.now
    content_tag :span, tu(:position_expiry, :distance => time), :class => 'expiry-time tag'
  end

  def auto_link_options(options, *autolink_fields)
    new_options = options.dup
    autolink_fields.each do |field|
      next unless new_options.has_key?(field)
      new_options[field] = auto_link(new_options[field].to_s)
    end
    new_options
  end

  protected

  def normalized_content_scope(key, scope = nil)
    (Array(scope) + key.to_s.split(".")).flatten.join(".")
  end

  def options_with_class_merged(o, n)
    css_klass = [o[:class], n[:class]].join(" ").strip.squeeze(" ")
    o.merge(n).merge(:class => css_klass)
  end

end
