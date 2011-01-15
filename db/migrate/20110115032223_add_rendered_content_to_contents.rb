class AddRenderedContentToContents < ActiveRecord::Migration
  def self.up
    add_column :contents, :rendered_content, :text
  end

  def self.down
    remove_column :contents, :rendered_content
  end
end
