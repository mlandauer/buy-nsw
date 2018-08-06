class RemoveKindAndDocumentableFromDocuments < ActiveRecord::Migration[5.1]
  def change
    remove_column :documents, :documentable_id, :integer, null: false
    remove_column :documents, :documentable_type, :string, null: false
    remove_column :documents, :kind, :string, null: false
  end
end
