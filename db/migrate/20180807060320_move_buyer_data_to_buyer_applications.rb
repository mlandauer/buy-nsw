class MoveBuyerDataToBuyerApplications < ActiveRecord::Migration[5.1]
  FIELDS = [:name, :organisation, :employment_status, :user_id].freeze

  def up
    change_table :buyer_applications do |t|
      t.string :name
      t.string :organisation
      t.string :employment_status
      t.integer :user_id
    end
    add_foreign_key :buyer_applications, :users, column: :user_id

    all_buyers.each do |buyer|
      application = BuyerApplication.find_by_buyer_id(buyer['id'])

      application.update_attributes!(
        buyer.symbolize_keys.slice(*FIELDS)
      )

      puts "Updated: Buyer ##{buyer['id']} => BuyerApplication ##{application.id}"
    end
  end

  def down
    remove_foreign_key :buyer_applications, column: :user_id

    remove_column :buyer_applications, :name
    remove_column :buyer_applications, :organisation
    remove_column :buyer_applications, :employment_status
    remove_column :buyer_applications, :user_id
  end

  def all_buyers
    ActiveRecord::Base.connection.execute('SELECT * FROM buyers')
  end
end
