class CreateMembers < ActiveRecord::Migration

  def change
    Mariana.schema_based_on_model self, Member
  end    
  
end
