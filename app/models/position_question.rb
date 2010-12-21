class PositionQuestion < ActiveRecord::Base
  
  attr_accessible :question_id, :question, :order_position, :required
  
  belongs_to :position
  belongs_to :question
  
  validates_presence_of :position, :question
  
  before_save :automatically_order

  protected

  def automatically_order
    if order_position.blank?
      self.order_position = position.present? ? position.position_questions.next_order_position : 1
    end
  end

end