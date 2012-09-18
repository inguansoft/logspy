#Model:[IN IMPLEMENTATION]: StatusLog
#Born:   20090903
#Author: Mauricio Inguanzo
#Description:
# Keep log of all status transitions from all the system
class StatusLog < Mariana

  ##################################################
  #Model Constants
  SYSTEM_NAME    = 'StatusLog'
  TABLE_NAME     = 'status_logs'
  ENTITY_NAME    = 'status_log'
  READABLE_NAME  = 'Logs'
  DB_DESCRIPTION = 'Keep log of all status transitions from all the system'
  DB_MIGRATION   = '003'
  DB_ID          = 3

  ##################################################
  #Model associations
  belongs_to :status
  belongs_to :member

  has_and_belongs_to_many :members

  belongs_to :new_status,
    :class_name  => "Status",
    :foreign_key => "new_status_id"

  ##################################################
  #Model attributes

  ##################################################
  #Model fields
  FIELDS = { 
    :id            => [ MysqlType::INTEGER  ],
    :status_id     => [ MysqlType::INTEGER  ],
    :member_id     => [ MysqlType::INTEGER  ],
    :new_status_id => [ MysqlType::INTEGER  ],
    :description   => [ MysqlType::TEXT     ]
  }
  
  ##################################################
  #Model validations

  ##################################################
  #Model default entries

  ##################################################
  #Model methods

  #---------------------------------------------------------------------------------------------
  # Get statistics functionality
  

  #---------------------------------------------------------------------------------------------


  #---------------------------------------------------------------------------------------------
  # Write state transitions functionality

  #register a log for this_object performed by this_member
  def self.register(this_object, this_member, this_description)
    return self.reg(this_object, this_member, Status::EXEC, this_description)
  end

  #Write state event as forced into the log history
  def self.register_forced(this_object, this_member, this_description)
    return self.reg(this_object, this_member, Status::FORCED, this_description)
  end

  #Write step requested to be skipped
  def self.register_skip(this_object, this_member, this_description)
    return self.reg(this_object, this_member, Status::SKIP, this_description)
  end

  private
  #generic private write log register to process all state changes from the system
  def self.reg(this_object, this_member, status_system_name, this_description)
    result=false
    if this_object and this_member and this_object.status
      new_reg=self.new(
        :member_id     => this_member.id,
        :new_status_id => this_object.status.id,
        :description   => this_description)
      new_reg.status = Status.get(status_system_name)
      if new_reg.save
        this_object.send("status_logs") << new_reg
        result=true
      else
        MenuCook.log_error("Unexpected error at saving time #{this_object}/#{this_object.presentation_id}:#{this_member}/#{this_member.presentation_id}")
      end
    else
      MenuCook.log_error("Required parameters missed #{this_object}/#{this_object.presentation_id}:#{this_member}/#{this_member.presentation_id}")
    end
    return result
  end
  public
  #---------------------------------------------------------------------------------------------

end
