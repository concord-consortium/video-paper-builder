class ChangeSectionContentToTypeText < ActiveRecord::Migration[5.1]
  def self.up
    change_column :sections, :content, :text
  end

  def self.down
    change_column :sections, :content, :text
  end
end
