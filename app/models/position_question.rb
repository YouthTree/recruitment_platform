class PositionQuestion < ActiveRecord::Base
  
  attr_accessible :question_id, :question, :order_position, :required
  
  belongs_to :position
  belongs_to :question
  
  validates_presence_of :position, :question
  
end
