class AddFieldsForSellerRecognition < ActiveRecord::Migration[5.1]
  def up
    change_table :seller_versions do |t|
      t.text :awards, array: true, default: []
      t.text :accreditations, array: true, default: []
      t.text :engagements, array: true, default: []
    end

    Seller.all.each do |seller|
      awards = return_values_for('seller_awards', seller.id, 'award')
      accreditations = return_values_for('seller_accreditations', seller.id, 'accreditation')
      engagements = return_values_for('seller_engagements', seller.id, 'engagement')

      seller.versions.each do |version|
        version.update_attributes!(
          awards: awards,
          accreditations: accreditations,
          engagements: engagements,
        )
      end
    end
  end

  def down
    remove_column :seller_versions, :awards
    remove_column :seller_versions, :accreditations
    remove_column :seller_versions, :engagements
  end

  def return_values_for(table, seller_id, key)
    sql = "SELECT * FROM #{table} WHERE seller_id = '#{seller_id}'"
    result = ActiveRecord::Base.connection.execute(sql)

    result.each.map { |row| row[key] }
  end
end
