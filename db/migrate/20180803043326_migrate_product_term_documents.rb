class MigrateProductTermDocuments < ActiveRecord::Migration[5.1]
  def up
    add_column :products, :terms_id, :integer

    all_documents.each do |document|
      product = Product.find_by_id(document['documentable_id'])

      if product.present?
        product.update_attribute(:terms_id, document['id'])
        puts "Doc ##{document['id']} => product update: #{product.id}"
      end
    end

    add_foreign_key :products, :documents, column: :terms_id
  end

  def down
    remove_foreign_key :products, column: :terms_id
    remove_column :products, :terms_id
  end

  def all_documents
    sql = "SELECT * FROM documents WHERE documentable_type='Product' AND kind IN ('terms')"
    ActiveRecord::Base.connection.execute(sql)
  end
end
