module Products
  class BackupRecoveryForm < BaseForm
    property :backup_capability
    property :backup_scheduling_type
    property :backup_recovery_type

    validation :default, inherit: true do
      required(:backup_capability).filled(in_list?: Product.backup_capability.values)
      required(:backup_scheduling_type).filled(in_list?: Product.backup_scheduling_type.values)
      required(:backup_recovery_type).filled(in_list?: Product.backup_recovery_type.values)
    end
  end
end
