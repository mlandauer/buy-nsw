class RemoveBuyersTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :buyers do |t|
      t.integer :user_id
      t.string :organisation
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.string :state, null: false
      t.string :name
      t.string :employment_status
    end
  end
end
