class AddUploadUri < ActiveRecord::Migration
  def up
    add_column :videos, :upload_uri, :string
  end

  def down
    remove_column :videos, :upload_uri
  end
end
