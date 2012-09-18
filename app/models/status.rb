#Model:[IN IMPLEMENTATION]:  Status
#Born:   20090301
#Author: Mauricio Inguanzo
#Description:
# Global generic status model
class Status < Mariana

  ##################################################
  #Model Constants
  SYSTEM_NAME    = 'Status'
  TABLE_NAME     = 'statuses'
  ENTITY_NAME    = 'status'
  READABLE_NAME  = 'Status'
  DB_DESCRIPTION = 'status'
  DB_MIGRATION   = '001'
  DB_ID          = 1

  ACCEPT           = "accepted"
  AVAILABLE        = "available"
  BOOKED           = "booked"
  BUYER            = "buyer"
  CANCEL           = "cancel"
  CHANGE           = "change"
  CHOICE           = "choice"
  COLLECTING       = "collecting"
  DELIVER          = "deliver"
  EMAIL_FAIL       = "email_fail"
  EMAIL_SENT       = "email_sent"
  ENJOY            = "enjoy"
  EXEC             = "exec"
  FORCED           = "forced"
  GUEST            = "guest"
  INIT             = "init"
  IN_THE_WAY       = "in_the_way"
  MEMBER_ACCEPT    = "member_accept"
  NEW              = "new"
  NOTIFY           = "notified"
  OPEN             = "open"
  ORDER            = "order"
  PENDING          = "pending"
  PICKEDUP         = "pickedup"
  PLACE            = "place"
  PREPARING        = "preparing"
  PRESENTIAL       = "presential"
  RATE             = "rate"
  REJECT           = "reject"
  REMOVED          = "removed"
  REPRICED         = "repriced"
  REPROMOTION      = "repromotion"
  RESCHEDULE       = "reschedule"
  RESET            = "reset"
  REVIEW           = "review"
  SKIP             = "skip"
  SUPPLIERS_ACCEPT = "suppliers_accept"
  UNAVAILABLE      = "unavailable"
  VERIFY           = "verified"
  UPDATED          = "updated"

  ##################################################
  #Model associations
  has_many :members

  has_many :status_machines_statuses
  has_many :status_machines,
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
  DEFAULT_VALUES = [
    { :system_name => ACCEPT           , :readable_name => "Accepted"         , :description => "Terms and conditions accepted"                },
    { :system_name => AVAILABLE        , :readable_name => "Available"        , :description => "Available"                                    },
    { :system_name => BOOKED           , :readable_name => "Booked"           , :description => "Booked"                                       },
    { :system_name => BUYER            , :readable_name => "Buyer"            , :description => "entity performed at least one transaction"    },
    { :system_name => CANCEL           , :readable_name => "Canceled"         , :description => "operation canceled"                           },
    { :system_name => CHANGE           , :readable_name => "Change"           , :description => "Change"                                       },
    { :system_name => CHOICE           , :readable_name => "Choice"           , :description => "Product selected and scheduled"               },
    { :system_name => COLLECTING       , :readable_name => "Collecting"       , :description => "Collecting"                                   },
    { :system_name => DELIVER          , :readable_name => "Deliver"          , :description => "Deliver"                                      },
    { :system_name => EMAIL_FAIL       , :readable_name => "Email failure"    , :description => "The e-mail was not sent"                      },
    { :system_name => EMAIL_SENT       , :readable_name => "Email was sent"   , :description => "The e-mail was sent"                          },
    { :system_name => ENJOY            , :readable_name => "Enjoy"            , :description => "Enjoy"                                        },
    { :system_name => EXEC             , :readable_name => "Execited"         , :description => "operation executed"                           },
    { :system_name => FORCED           , :readable_name => "Forced"           , :description => "situation forced"                             },
    { :system_name => GUEST            , :readable_name => "Guest"            , :description => "Guest"                                        },
    { :system_name => INIT             , :readable_name => "Init"             , :description => "Init"                                         },
    { :system_name => IN_THE_WAY       , :readable_name => "food in its way"  , :description => "food in its way"                              },
    { :system_name => MEMBER_ACCEPT    , :readable_name => "Member accept"    , :description => "Member accept"                                },
    { :system_name => NEW              , :readable_name => "New"              , :description => "New"                                          },
    { :system_name => NOTIFY           , :readable_name => "Notified"         , :description => "Open notification delivered, no reply needed" },
    { :system_name => OPEN             , :readable_name => "Open"             , :description => "Open"                                         },
    { :system_name => ORDER            , :readable_name => "Order"            , :description => "Order"                                        },
    { :system_name => PENDING          , :readable_name => "Pending"          , :description => "something is holding the completion"          },
    { :system_name => PICKEDUP         , :readable_name => "to be picked up"  , :description => "to be picked up"                              },
    { :system_name => PLACE            , :readable_name => "Place"            , :description => "Place"                                        },
    { :system_name => PREPARING        , :readable_name => "Preparing"        , :description => "Preparing"                                    },
    { :system_name => PRESENTIAL       , :readable_name => "Visit supplier"   , :description => "Member will eat at suppliers place"           },
    { :system_name => RATE             , :readable_name => "Rate"             , :description => "Rate"                                         },
    { :system_name => REJECT           , :readable_name => "Rejected"         , :description => "operation rejected"                           },
    { :system_name => REMOVED          , :readable_name => "Removed"          , :description => "Removed"                                      },
    { :system_name => REPRICED         , :readable_name => "Repriced"         , :description => "Repriced"                                     },
    { :system_name => REPROMOTION      , :readable_name => "Repromotion"      , :description => "Repromotion"                                  },
    { :system_name => RESCHEDULE       , :readable_name => "Reschedule"       , :description => "Reschedule"                                   },
    { :system_name => RESET            , :readable_name => "Reset"            , :description => "reset critical attribute"                     },
    { :system_name => REVIEW           , :readable_name => "Review"           , :description => "Review"                                       },
    { :system_name => SKIP             , :readable_name => "Skiped"           , :description => "operation not executed"                       },
    { :system_name => SUPPLIERS_ACCEPT , :readable_name => "Suppliers accept" , :description => "Suppliers accept"                             },
    { :system_name => UNAVAILABLE      , :readable_name => "Not available"    , :description => "Not available"                                },
    { :system_name => VERIFY           , :readable_name => "Verified"         , :description => "Verified"                                     },
    { :system_name => UPDATED          , :readable_name => "Updated"          , :description => "Value was updated"                            }
  ]
  
  ##################################################
  #Model methods

  #get Status object on initial state
  def self.init
    return Status.find_by_system_name(Status::INIT)
  end

  #get Status object on guest
  def self.guest
    return Status.find_by_system_name(Status::GUEST)
  end

  #get Status object on open state
  def self.open
    return Status.find_by_system_name(Status::OPEN)
  end

  #get Status object on available state
  def self.available
    return Status.find_by_system_name(Status::AVAILABLE)
  end

  #get Status object on available state
  def self.pending
    return Status.find_by_system_name(Status::PENDING)
  end

end
