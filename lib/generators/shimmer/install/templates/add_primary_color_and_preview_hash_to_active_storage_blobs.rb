class AddPrimaryColorAndPreviewHashToActiveStorageBlobs < ActiveRecord::Migration[6.0]
  def change
    add_column :active_storage_blobs, :primary_color, :string
    add_column :active_storage_blobs, :preview_hash, :string
  end
end
