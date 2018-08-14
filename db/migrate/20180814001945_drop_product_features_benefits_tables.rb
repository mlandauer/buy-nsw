class DropProductFeaturesBenefitsTables < ActiveRecord::Migration[5.1]
  def change
    drop_table :product_features do |t|
      t.integer :product_id, null: false
      t.string :feature
    end

    drop_table :product_benefits do |t|
      t.integer :product_id, null: false
      t.string :benefit
    end
  end
end
