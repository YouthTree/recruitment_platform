# General Teams
Team.create :name => 'Big Help Mob',   :website_url => 'http://bighelpmob.org/',   :description => 'Update this description'
Team.create :name => 'TEDxPerth',      :website_url => 'http://tedxperth.org/',    :description => 'Update this description'
Team.create :name => 'Youth Tree Inc', :website_url => 'http://youthtree.org.au/', :description => 'Update this description'

# Default Questions
Question.create :question => 'How did you hear about us?', :short_name => 'User origin', :editable_metadata => %w(A B C D), :question_type => 'select', :required_by_default => true

Content.create :key => 'position_landing_page', :content => 'This page is currently empty'
Content.create :key => 'meta.description', :content => 'There is currently no meta description'