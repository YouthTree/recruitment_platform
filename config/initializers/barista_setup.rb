Barista.configure do |c|
  c.bare!
  c.change_output_prefix! 'shuriken',        'vendor/shuriken'
  c.change_output_prefix! 'youthtree',       'vendor/youthtree'
  c.js_path = Rails.root.join('public', 'javascripts', 'vendor', 'coffee-script.js').to_s
end