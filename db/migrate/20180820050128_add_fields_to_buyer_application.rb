class AddFieldsToBuyerApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :buyer_applications, :cloud_purchase, :string
    add_column :buyer_applications, :contactable, :string
    add_column :buyer_applications, :contact_number, :string
  end
end
