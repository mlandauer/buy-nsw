class MigrateFeaturesBenefitsToProducts < ActiveRecord::Migration[5.1]
  def up
    change_table :products do |t|
      t.text :features, array: true, default: []
      t.text :benefits, array: true, default: []
    end

    Product.all.each do |product|
      features = return_values_for('product_features', product.id, 'feature')
      benefits = return_values_for('product_benefits', product.id, 'benefit')

      product.update_columns(
        features: features,
        benefits: benefits,
      )
    end
  end

  def down
    remove_column :products, :features
    remove_column :products, :benefits
  end

  def return_values_for(table, product_id, key)
    sql = "SELECT * FROM #{table} WHERE product_id = '#{product_id}'"
    result = ActiveRecord::Base.connection.execute(sql)

    result.each.map { |row| row[key] }
  end
end
