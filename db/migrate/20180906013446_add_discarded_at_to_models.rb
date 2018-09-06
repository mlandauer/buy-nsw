class AddDiscardedAtToModels < ActiveRecord::Migration[5.1]
  def change
    add_column :sellers, :discarded_at, :datetime
    add_column :seller_versions, :discarded_at, :datetime
    add_column :products, :discarded_at, :datetime
    add_column :buyer_applications, :discarded_at, :datetime
    add_index :sellers, :discarded_at
    add_index :seller_versions, :discarded_at
    add_index :products, :discarded_at
    add_index :buyer_applications, :discarded_at
  end
end
