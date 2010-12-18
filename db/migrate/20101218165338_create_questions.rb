class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.string  :question
      t.string  :short_name
      t.text    :hint
      t.text    :metadata
      t.string  :question_type
      t.string  :default_value
      t.boolean :required_by_default

      t.timestamps
    end
  end

  def self.down
    drop_table :questions
  end
end
