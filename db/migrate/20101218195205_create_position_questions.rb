class CreatePositionQuestions < ActiveRecord::Migration
  def self.up
    create_table :position_questions do |t|
      t.belongs_to :position
      t.belongs_to :question
      t.integer :order_position
      t.boolean :required

      t.timestamps
    end
  end

  def self.down
    drop_table :position_questions
  end
end
