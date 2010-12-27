class AddRawAnswersToPositionApplications < ActiveRecord::Migration
  def self.up
    add_column :position_applications, :raw_answers, :text
  end

  def self.down
    remove_column :position_applications, :raw_answers
  end
end
