# General Teams
Team.create :name => 'Big Help Mob',   :website_url => 'http://bighelpmob.org/',   :description => 'Update this description'
Team.create :name => 'TEDxPerth',      :website_url => 'http://tedxperth.org/',    :description => 'Update this description'
Team.create :name => 'Youth Tree Inc', :website_url => 'http://youthtree.org.au/', :description => 'Update this description'

# Default Questions
Question.create :question => 'How did you hear about us?', :short_name => 'User origin', :editable_metadata => %w(A B C D), :question_type => 'select', :required_by_default => true

#  question            :string(255)
#  short_name          :string(255)
#  hint                :text
#  metadata            :text
#  question_type       :string(255)
#  default_value       :string(255)