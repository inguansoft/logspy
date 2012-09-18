#Model:[IN IMPLEMENTATION]:StatusMachine
#Born:   20090903
#Author: Mauricio Inguanzo
#Description
# Model storing the work flows and helpers to support them
class StatusMachine < Mariana
  ##################################################
  #Model Constants
  SYSTEM_NAME    = 'StatusMachine'
  TABLE_NAME     = 'status_machines'
  ENTITY_NAME    = 'status_machine'
  READABLE_NAME  = 'Status machine'
  DB_DESCRIPTION = 'State machine to control processes'
  DB_MIGRATION   = '002'
  DB_ID          = 2

  FOOD_IDEAL       = "food_ideal"
  HEALTH_IDEAL     = "health_ideal"
  SIGN_UP          = "sign_up"
  NON_FREE_SIGN_UP = "non_free_sign_up"
  EMAIL_VERIFY     = "email_verify"
  DEPOSIT          = "deposit"
  UNMANAGED        = "unmanaged"
  
  ##################################################
  #Model associations

  has_many :status_machines_statuses
  has_many :statuses,
    :through => :status_machines_statuses

  ##################################################
  #Model attributes

  ##################################################
  #Model fields
  FIELDS = {
    :id            => [ MysqlType::INTEGER ],
    :system_name   => [ MysqlType::STRING  ],
    :readable_name => [ MysqlType::STRING  ],
    :description   => [ MysqlType::TEXT    ]
  }
  ##################################################
  #Model validations

  ##################################################
  #Model default entries
  DEFAULT_VALUES = {
    FOOD_IDEAL       => ["Food"               , "The status workflow to process a perfect food delivery"                      ],
    HEALTH_IDEAL     => ["Health"             , "Ideal health delegation to select food comsuption from suppliers to members" ],
    SIGN_UP          => ["Sign up"            , "The entity accepted terms and conditions and introduced all the required information to start menuCook membership" ],
    NON_FREE_SIGN_UP => ["non-free Sign up"   , "The entity accepted terms and conditions, introduced all the required information to start a non free menuCook membership" ],
    EMAIL_VERIFY     => ["E-mail verification", "Verification that e-mail is autjorized by owner"                 ],
    DEPOSIT          => ["Deposit"            , "Deposit credits to your account"                                             ],
    UNMANAGED        => ["Unmanaged"          , "No state machine associated, single change from state A to state B"        ]
  }

  ##################################################
  #Model methods

  #static method used to set a status and log the change from +this_object+
  #no changes will be applied if the status is the same as the current status of +this_object+
  # +this_object+:: instance to be affected
  # +status_system_name+:: status system name coming from Status class to be set on +this_object+
  # +this_member+:: member submitting change on +this_object+ status
  # +this_description+:: notes to be attached to the log registering event transition
  # +returns+:: Boolean: <b>true</b> if transition was set and log written, <b>false</b> otherwise
  def self.set_status_on(this_object, status_system_name, this_member, this_description="Update generate from menuCook app")
    result = false
    if this_object and this_member and status_system_name and status_system_name != ""
      this_status = Status.get(status_system_name)
      if this_status
        object_status = this_object.status
        if object_status and (this_status.system_name == object_status.system_name)
          log_error "redundant status tried to be performed, no changes nor log was performed: #{object_status.system_name}"
        else
          this_object.status = this_status
          if this_object.save
            result = StatusLog.register(this_object, this_member, this_description)
          else
            MenuCook.log_error("Unexpected error at saving time for #{this_object.class}[#{this_object.id}]#{this_object.class::SYSTEM_NAME}")
          end
        end
      else
        MenuCook.log_error("Object not found on Status class")
      end
    else
      MenuCook.log_error("Unexpected missed argument")
    end
    return result
  end

  #begin state machine from the first step
  def init this_object, this_member
    this_state_machine_step = self.status_machines_statuses.find_by_step('1')
    this_status             = this_state_machine_step.status
    if this_status
      this_object.status = this_status
      if this_object.save
        StatusLog.register(this_object, this_member,this_state_machine_step)
      else
        MenuCook.log_error("Unexpected exception, Saving failure")
      end
    end
  end

  #progress one step on the status based on the state machine current status of the object
  def next_step this_object, this_member
    this_target_join = self.get_step_moving_from_current(1,this_object.status)
    if this_target_join
      this_object.status = this_target_join.status
      if this_object.save
        StatusLog.register(this_object, this_member, this_target_join)
      end
    end
  end

  
  #skip one step and progress one step on the status based on the state machine current status of the object
  def skip_next_step this_object, this_member
    this_target_join = self.get_step_moving_from_current(2,this_object.status)
    if this_target_join
      this_skiped_join = self.get_step_moving_from_current(1,this_object.status)
      StatusLog.register_skip(this_object, this_member, this_skiped_join)
      this_object.status = this_target_join.status
      if this_object.save
        StatusLog.register(this_object, this_member, this_target_join)
      end
    end

  end

  #force the status to this_status requested
  def set this_object, this_member, this_status
    failure_message = nil
    this_step=self.status_machines_statuses.find_by_status_id(this_status.id)
    if this_step
      this_object.status = this_status
      if this_object.save
        StatusLog.register_forced(this_object, this_member, this_step)
      else
        failure_message="Unexpected error found - not able to update status"
        MenuCook.log_error(failure_message)
      end
    else
      failure_message="Status not valid for this process"
      MenuCook.log_error(failure_message)
    end
    return failure_message
  end

  #register the generic state init to initialize any potential process
  def self.init this_object, this_member
    this_object.status = Status.init
    if this_object.save
      StatusLog.register(this_object, this_member, nil,this_object.status)
    end
  end

  #check if the status allows to remove the entry from the DB
  def can_remove_at(this_status)
    result = false
    if this_status
      if this_status.system_name == Status::PENDING
        result = true
      else
        this_process = self.status_machines_statuses
        current_step=this_process.find_by_status_id(this_status.id)
        if current_step
          this_threshold_step = Threshold.get(Threshold::SOLD).status_machines_statuses.find_by_status_machine_id(self.id)
          if this_threshold_step
            if this_threshold_step.step > current_step.step
              result = true
            end
          end
        else
          result = true
        end
      end
    end
    return result
  end

  # get the color that corresponds to the status
  # +this_status+:: Status object looking for its color
  # +return+:: String with HTML color, black if status is unknown
  def step_color_code_at(this_status)
    color_code = StatusMachinesStatus::UNDEFINED
    if this_status
      this_step = self.status_machines_statuses.find_by_status_id(this_status.id)
      if this_step
        color_code = this_step.step_color_code
      end
    end
    return color_code
  end

  # Get a recommendation based on the current status
  # +this_status+:: Status instance to get the recommendation
  # +return+:: String that represents the recommendation
  def useful_status this_status
    status_string = StatusMachinesStatus::USEFUL_STATUS_UNDEFINED
    this_step = self.status_machines_statuses.find_by_status_id(this_status.id)
    if this_step
      status_string = this_step.useful_status
    end
    return status_string
  end

  def get_step_moving_from_current steps, this_current_status
    this_target_join = nil
    these_selves = self.status_machines_statuses
    this_current_self = these_selves.find(:first, :conditons => "status_id = '#{this_current_status.id}'")
    if this_current_self
      new_step = this_current_self.step + steps
      this_target_join = these_selves.find(:first, :conditons => "step = '#{new_step}'")
    end
    return this_target_join
  end

end
