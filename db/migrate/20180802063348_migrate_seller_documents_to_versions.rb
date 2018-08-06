class MigrateSellerDocumentsToVersions < ActiveRecord::Migration[5.1]
  def up
    add_column :seller_versions, :financial_statement_id, :integer
    add_column :seller_versions, :professional_indemnity_certificate_id, :integer
    add_column :seller_versions, :workers_compensation_certificate_id, :integer
    add_column :seller_versions, :product_liability_certificate_id, :integer

    all_documents.each do |document|
      kind = document['kind']
      seller = Seller.find_by_id(document['documentable_id'])

      if seller.present?
        seller.versions.update_all({
          "#{kind}_id" => document['id']
        })
        puts "Doc ##{document['id']} => seller versions update: #{seller.versions.map(&:id).join(', ')}"
      end
    end

    add_foreign_key :seller_versions, :documents, column: :financial_statement_id
    add_foreign_key :seller_versions, :documents, column: :professional_indemnity_certificate_id
    add_foreign_key :seller_versions, :documents, column: :workers_compensation_certificate_id
    add_foreign_key :seller_versions, :documents, column: :product_liability_certificate_id
  end

  def down
    remove_foreign_key :seller_versions, column: :financial_statement_id
    remove_foreign_key :seller_versions, column: :professional_indemnity_certificate_id
    remove_foreign_key :seller_versions, column: :workers_compensation_certificate_id
    remove_foreign_key :seller_versions, column: :product_liability_certificate_id

    remove_column :seller_versions, :financial_statement_id
    remove_column :seller_versions, :professional_indemnity_certificate_id
    remove_column :seller_versions, :workers_compensation_certificate_id
    remove_column :seller_versions, :product_liability_certificate_id
  end

  def all_documents
    sql = "SELECT * FROM documents WHERE documentable_type='Seller' AND
      kind IN ('financial_statement', 'professional_indemnity_certificate', 'workers_compensation_certificate', 'product_liability_certificate')"
    ActiveRecord::Base.connection.execute(sql)
  end
end
