class DropOldSellerRelationTables < ActiveRecord::Migration[5.1]
  def up
    remove_foreign_key :seller_accreditations, :sellers
    remove_foreign_key :seller_awards, :sellers
    remove_foreign_key :seller_engagements, :sellers

    drop_table :seller_accreditations
    drop_table :seller_addresses
    drop_table :seller_awards
    drop_table :seller_engagements
  end

  def down
    create_table :seller_accreditations do |t|
      t.integer :seller_id, null: false
      t.string :accreditation

      t.timestamps
    end

    create_table :seller_addresses do |t|
      t.integer :seller_id, null: false
      t.string :address
      t.string :suburb
      t.string :state
      t.string :postcode
      t.string :country

      t.timestamps
    end

    create_table :seller_awards do |t|
      t.integer :seller_id, null: false
      t.string :award

      t.timestamps
    end

    create_table :seller_engagements do |t|
      t.integer :seller_id, null: false
      t.string :engagement

      t.timestamps
    end

    add_foreign_key :seller_accreditations, :sellers
    add_foreign_key :seller_awards, :sellers
    add_foreign_key :seller_engagements, :sellers
  end
end
