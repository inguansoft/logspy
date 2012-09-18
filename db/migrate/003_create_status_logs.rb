class CreateStatusLogs < ActiveRecord::Migration
  def change
    Mariana.schema_based_on_model self, StatusLog
    
    create_table :members_status_logs, :id => false do |t|
      t.column :member_id  , :integer
      t.column :status_log_id, :integer
    end
    
  end

end
