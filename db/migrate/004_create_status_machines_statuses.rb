class CreateStatusMachinesStatuses < ActiveRecord::Migration
  def change
    Mariana.schema_based_on_model self, StatusMachinesStatus
  end
end
