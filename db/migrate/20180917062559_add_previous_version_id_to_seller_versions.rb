class AddPreviousVersionIdToSellerVersions < ActiveRecord::Migration[5.1]
  def change
    add_column :seller_versions, :previous_version_id, :integer
  end
end
