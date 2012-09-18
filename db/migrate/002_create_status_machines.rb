class CreateStatusMachines < ActiveRecord::Migration
  def change
    Mariana.schema_based_on_model self, StatusMachine
  end
end
