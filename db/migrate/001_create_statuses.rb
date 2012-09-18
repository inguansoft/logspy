class CreateStatuses < ActiveRecord::Migration
  def change
    Mariana.schema_based_on_model self, Status
  end 
end
