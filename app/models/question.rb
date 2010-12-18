class Question < ActiveRecord::Base
  
  VALID_TYPES = %w(date_time short_text text multiple_choice check_boxes select scale)
  
end

# == Schema Information
#
# Table name: questions
#
#  id                  :integer         not null, primary key
#  question            :string(255)
#  short_name          :string(255)
#  hint                :text
#  metadata            :text
#  question_type       :string(255)
#  default_value       :string(255)
#  required_by_default :boolean
#  created_at          :datetime
#  updated_at          :datetime
#

