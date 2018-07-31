class MigrateAddressesToSellerVersions < ActiveRecord::Migration[5.1]
  def up
    change_table :seller_versions do |t|
      t.jsonb :addresses, default: []
    end

    Seller.all.each do |seller|
      addresses = addresses_for(seller.id)

      seller.versions.each do |version|
        version.update_attributes!(
          addresses: addresses.map {|address|
            address.slice('address', 'suburb', 'postcode', 'state', 'country')
          }
        )
      end
    end
  end

  def down
    remove_column :seller_versions, :addresses
  end

  def addresses_for(seller_id)
    sql = "SELECT * FROM seller_addresses WHERE seller_id = '#{seller_id}'"
    ActiveRecord::Base.connection.execute(sql).each
  end
end
