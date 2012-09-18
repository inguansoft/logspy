#Model:[IN IMPLEMENTATION]:StatusMachineStatus
#Born:   20090905
#Author: Mauricio Inguanzo
#Description
# Join model to glue StateMachine with its respective Status
class StatusMachinesStatus < Mariana

  ##################################################
  #Model Constants
  SYSTEM_NAME    = 'StatusMachinesStatus'
  TABLE_NAME     = 'status_machines_statuses'
  ENTITY_NAME    = 'status_machines_status'
  READABLE_NAME  = 'State machine ordered status composition'
  DB_DESCRIPTION = 'State machine ordered status composition'
  DB_MIGRATION   = '004'
  DB_ID          = 4

  COLOR_CODES = {
    1 => "F99696",
    2 => "F9BC96",
    3 => "F9C196",
    4 => "F9EA96",
    5 => "F2F996",
    6 => "DAF996",
    7 => "C0F996",
    8 => "9CF996",
    9 => "96F9AC",
    10 => "96F9C3",
    11 => "96F9DE",
    12 => "96F9F8",
    13 => "96D8F9",
    14 => "96BBF9",
    15 => "969CF9",
    16 => "A896F9",
    17 => "C996F9",
    18 => "EE96F9",
    19 => "F996F5",
    20 => "F996CC"
  }

  MAX_CODE = 20
  UNDEFINED = "6D7B8D"
  USEFUL_STATUS_UNDEFINED = "need schedule"
  FOOD_STATE_MACHINE = {
    1  => Status::CHOICE            ,
    2  => Status::PLACE             ,
    3  => Status::ORDER             ,
    4  => Status::SUPPLIERS_ACCEPT  ,
    5  => Status::MEMBER_ACCEPT     ,
    6  => Status::PREPARING         ,
    7  => Status::DELIVER           ,
    8  => Status::ENJOY             ,
    9  => Status::RATE              ,
    10 => Status::REVIEW 
  }

  USEFUL_STATUS_FOOD_STATE_MACHINE = {
    1  => "set location"  ,
    2  => "confirm"             ,
    3  => "waiting for suppliers"    ,
    4  => "waiting for suppliers"    ,
    5  => "ready"          ,
    6  => "cooking"                  ,
    7  => "delivering"               ,
    8  => "enjoying"                 ,
    9  => "rated"                    ,
    10 => "reviewed"
  }

  SIGN_UP_STATE_MACHINE = {
    1  => Status::ACCEPT ,
    2  => Status::BUYER  ,
    3  => Status::VERIFY
  }

  ##################################################
  #Model associations

  belongs_to :status
  belongs_to :status_machine
  has_and_belongs_to_many :thresholds

  ##################################################
  #Model attributes

  ##################################################
  #Model fields
  FIELDS = {
    :id                => [ MysqlType::INTEGER ],
    :status_machine_id => [ MysqlType::INTEGER ],
    :status_id         => [ MysqlType::INTEGER ],
    :step              => [ MysqlType::INTEGER ]
  }

  ##################################################
  #Model validations

  ##################################################
  #Model default entries

  ##################################################
  #Model methods

  #pre load default entries based on DEFAULT_VALUES Hash constant
  def self.prepopulate (migration_obj)
    this_status_machine = StatusMachine.find_by_system_name(StatusMachine::FOOD_IDEAL)
    StatusMachinesStatus::FOOD_STATE_MACHINE.each do |step, status_system_name|
      this_status = Status.get(status_system_name)
      migration_obj.execute "INSERT INTO status_machines_statuses (status_machine_id, status_id, step) VALUES ('#{this_status_machine.id}', '#{this_status.id}', '#{step}')"
    end    
  end

  # returns a color HTML code for the state spend in the workflow
  def step_color_code
    if self.step.to_i > 0 and self.step.to_i < MAX_CODE
      return COLOR_CODES[self.step]
    else
      return UNDEFINED
    end
  end

  #?
  def useful_status
    if self.step.to_i > 0 and self.step.to_i < MAX_CODE
      return USEFUL_STATUS_FOOD_STATE_MACHINE[self.step]
    else
      return USEFUL_STATUS_UNDEFINED
    end
  end

end
