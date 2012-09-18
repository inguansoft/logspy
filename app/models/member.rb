#Model:[IN IMPLEMENTATION]: Member
#Born: 20081102
#Author: Mauricio Inguanzo
#Description:
# Subscriber human been interacting as consumer and/or supplier inside menuCook environment
require 'bcrypt'

class Member < Mariana
  
  ##################################################
  #Model Constants
  SYSTEM_NAME    = 'Member'
  TABLE_NAME     = 'members'
  ENTITY_NAME    = 'member'
  READABLE_NAME  = 'Members'
  DB_DESCRIPTION = 'community member'
  DB_MIGRATION   = '010'
  DB_ID          = 10
  
  DEFAULT_MEMBER      = "inguan@menucook.com"
  DEFAULT_MAIL        = "inguansoft@gmail.com"
  DEFAULT_PASS        = "holamundo"
  DEFAULT_FIRST_NAME  = "Mauricio"
  DEFAULT_MIDDLE_NAME = ""
  DEFAULT_LAST_NAME   = "Inguanzo"
  
  FOOD_MEMBER      = "food_inguanzo@menucook.com"
  FOOD_MAIL        = "inguan@hotmail.com"
  FOOD_PASS        = "holamundo"
  FOOD_FIRST_NAME  = "Mauricio"
  FOOD_MIDDLE_NAME = "N"
  FOOD_LAST_NAME   = "Food"
  
  HEALTH_MEMBER      = "health_inguanzo@menucook.com"
  HEALTH_MAIL        = "inguan@yahoo.com"
  HEALTH_PASS        = "holamundo"
  HEALTH_FIRST_NAME  = "Mauricio"
  HEALTH_MIDDLE_NAME = "N."
  HEALTH_LAST_NAME   = "Health"
  
  DELIVERY_MEMBER      = "delivery_inguanzo@menucook.com"
  DELIVERY_MAIL        = "inguanzo@actomos.com"
  DELIVERY_PASS        = "holamundo"
  DELIVERY_FIRST_NAME  = "Mauricio"
  DELIVERY_MIDDLE_NAME = "Nic."
  DELIVERY_LAST_NAME   = "Delivery"

  TESTER_MEMBER      = "test_inguanzo@menucook.com"
  TESTER_MAIL        = "test@menucook.com"
  TESTER_PASS        = "holamundo"
  TESTER_FIRST_NAME  = "Julian"
  TESTER_MIDDLE_NAME = ""
  TESTER_LAST_NAME   = "Inguanzo"

  FAVORITES_SUPPLIERS_SYSTEM_NAME     = "favorite_suppliers"
  FAVORITES_DISHES_SYSTEM_NAME        = "dishes"
  FAVORITES_INGREDIENTS_SYSTEM_NAME   = "ingredients"
  FAVORITES_DIET_PROGRAMS_SYSTEM_NAME = "diet_programs"
  
  FAVORITES_SUPPLIERS_READABLE_NAME     = "Favorite suppliers"
  FAVORITES_DISHES_READABLE_NAME        = "Favorite dishes"
  FAVORITES_INGREDIENTS_READABLE_NAME   = "Favorite ingredients"
  FAVORITES_DIET_PROGRAMS_READABLE_NAME = "Favorite diet programs"
  
  FAVORITES = {
    FAVORITES_SUPPLIERS_SYSTEM_NAME     => FAVORITES_SUPPLIERS_READABLE_NAME     ,
    FAVORITES_DISHES_SYSTEM_NAME        => FAVORITES_DISHES_READABLE_NAME        ,
    FAVORITES_INGREDIENTS_SYSTEM_NAME   => FAVORITES_INGREDIENTS_READABLE_NAME   ,
    FAVORITES_DIET_PROGRAMS_SYSTEM_NAME => FAVORITES_DIET_PROGRAMS_READABLE_NAME 
  }
  
  ##################################################
  #Model associations

  belongs_to :status


  HUMANIZED_COLLUMNS = {
    :system_name                        => "e-mail",
    :encrypted_password                 => "password",
    :Email_collaborator__system_name     => "e-mail",
    :WebSite_collaborator__system_name   => "web site",
    :Phone_collaborator__system_name     => "phone",
    'Phone_collaborator__phone_type_id'  => "phone type",
    :Address_collaborator__readable_name => "address",
    'Address_collaborator__zip'          => "zip code",
    'Address_collaborator__city_id'      => "city",
    'terms_and_conditions'               => "Terms and Conditions",
    'membership_selected'                => "Membership",
    :first_name    => "First name",
    :last_name     => "Last name",
    #'Credit_collaborator__credit_type_id'=> "Credit card type",
    #'Credit_collaborator__number'        => "Credit card number",
    #'Credit_collaborator__address_id'    => "Credit card number",
    #'Credit_collaborator__ccvc'          => "Credit card verification number",
    #'months'                             => "months agreement"#,
    #'exp_month'                          => "Credit card month expiration",
    #'exp_year'                           => "Credit card year expiration"
  }

  ##################################################
  #Model fields
  FIELDS = { 
    :id                    => [ MysqlType::INTEGER],
    :system_name           => [ MysqlType::STRING ],
    :first_name            => [ MysqlType::STRING ],
    :middle_name           => [ MysqlType::STRING ],
    :last_name             => [ MysqlType::STRING ],
    :encrypted_password    => [ MysqlType::STRING ],
    :description           => [ MysqlType::TEXT   ],
    :balance_id            => [ MysqlType::INTEGER],
    :ranking               => [ MysqlType::INTEGER],
    :status_id             => [ MysqlType::INTEGER],
    :memberships_member_id => [ MysqlType::INTEGER]
  }

  FIELDS_REQUIRED = [
    'system_name',
    'first_name',
    'last_name',
    'encrypted_password'
  ]
  ##################################################
  #Model validations
  NAME_MIN_LENGTH = 2
  NAME_MAX_LENGTH = 120
  PASSWORD_MIN_LENGTH    = 4
  PASSWORD_MAX_LENGTH    = 40
  EMAIL_MAX_LENGTH = 200
  NAME_RANGE      = NAME_MIN_LENGTH..NAME_MAX_LENGTH
  PASSWORD_RANGE  = PASSWORD_MIN_LENGTH..PASSWORD_MAX_LENGTH
  # Text box sizes for display in the views
  NAME_SIZE       = 20
  PASSWORD_SIZE          = 10
  PASSWORD_FIELD_SIZE = 12

  ##################################################
  #Model default entries

  DEFAULT_VALUES = [
    {
      :system_name        => DEFAULT_MEMBER,
      :encrypted_password => BCrypt::Password.create(DEFAULT_PASS, :cost => 10),
      :first_name         => DEFAULT_FIRST_NAME,
      :middle_name        => DEFAULT_MIDDLE_NAME,
      :last_name          => DEFAULT_LAST_NAME },
    {
      :system_name        => FOOD_MEMBER,
      :encrypted_password => BCrypt::Password.create(FOOD_PASS, :cost => 10),
      :first_name         => FOOD_FIRST_NAME,
      :middle_name        => FOOD_MIDDLE_NAME,
      :last_name          => FOOD_LAST_NAME },
    {
      :system_name        => HEALTH_MEMBER,
      :encrypted_password => BCrypt::Password.create(HEALTH_PASS, :cost => 10),
      :first_name         => HEALTH_FIRST_NAME,
      :middle_name        => HEALTH_MIDDLE_NAME,
      :last_name          => HEALTH_LAST_NAME   },
    {
      :system_name        => DELIVERY_MEMBER,
      :encrypted_password => BCrypt::Password.create(DELIVERY_PASS, :cost => 10),
      :first_name         => DELIVERY_FIRST_NAME,
      :middle_name        => DELIVERY_MIDDLE_NAME,
      :last_name          => DELIVERY_LAST_NAME   },
    {
      :system_name        => TESTER_MEMBER,
      :encrypted_password => BCrypt::Password.create(TESTER_PASS, :cost => 10),
      :first_name         => TESTER_FIRST_NAME,
      :middle_name        => TESTER_MIDDLE_NAME,
      :last_name          => TESTER_LAST_NAME }
  ]
  
  ##################################################
  #Model methods

  # data model receives the read request coming from web service
  def self.web_read parameters, default_member=nil
    member_found = nil
    member_found = self.authenticate(parameters['name'], parameters['password']) if parameters
    return member_found
  end

  #Used to support sign in through the same read call on the web service
  def self.is_sign_granted? item
    if item.class.to_s == 'Member' && item.id > 0
      return true
    else
      return false
    end
  end

  #check sign in for pair +name+ and +entry_password+
  def self.authenticate(name, entry_password)
    if this_subscriber = self.get(name)
      current=BCrypt::Password.new(this_subscriber.encrypted_password)
      if current == entry_password
        return this_subscriber
      else
        return nil
      end
    end
    return nil
  end

  #---------------------------------------------------------------------------------------------
  # Constructor and Initialization functionality

  def initialization hashin=nil
    super hashin
    @is_guest = false
  end

  #---------------------------------------------------------------------------------------------
  # Generic functionality

  #create a new member
  def self.guest
    this_guest = Member.new
    this_guest.system_name = Mariana.generate_name
    this_guest.status=Status.guest

    if this_guest.save
      return this_guest
    else
      return nil
    end
  end

  def self.signed?(this_member)
    if this_member
      if DeploySettings.forced_member?
        if !this_member.is_guest?
          return true
        end
      else
        return true
      end
    end
    return false
  end

  #Generates a complete member name
  def full_name
    return "#{first_name}" + ((middle_name and middle_name!="")?" #{middle_name}":"") +
      ((last_name and last_name!="")?" #{last_name}":"")
  end

  #Generates a complete member name and override the readable name common menuCook method
  def readable_name
    self.full_name
  end

  #prepare field for collaborative display
  def prepare_for_collaboration_display
    super
    self.omit('balance_id')
    self.omit('membership_id')
    self.omit('memberships_member_id')
  end

  #prepare_collaborative_form_fields:
  def prepare_collaborative_form_fields
    super
    self.omit('balance_id')
    self.omit('status_id')
    self.omit('ranking')
    self.omit('membership_id')
    self.omit('memberships_member_id')
  end

  #prepare fields to be used for guest trying to submit data into menuCook DB
  def prepare_guest
    self.omit('system_name')
    self.omit('encrypted_password')
    self.omit('middle_name')
    self.omit('description')
    self.omit('ranking')
    self.omit('status_id')
    self.omit('balance_id')
    self.omit('membership_id')
    self.omit('memberships_member_id')
  end

  #provide a default administrator member use for generic updates where no member can be identified properly
  def self.admin
    return self.get(self::DEFAULT_MEMBER)
  end

  #provide a default administrator member use for generic updates where no member can be identified properly
  def self.tester
    return self.get(self::TESTER_MEMBER)
  end

  #get the first supplier associated to member or nil if no supplier is in place
  def supplier
    this_supplier = nil
    these_suppliers = self.suppliers
    if these_suppliers and these_suppliers.length > 0
      this_supplier = these_suppliers[0]
    end
    return this_supplier
  end

  #---------------------------------------------------------------------------------------------

  #---------------------------------------------------------------------------------------------
  # Load functionality

  #pre load default entries based on DEFAULT_VALUES Hash constant for fixtures used during testing
  def self.load_fixtures
    fixtures_string = ""
    self::DEFAULT_VALUES.each do |system_name, entries|
      fixtures_string=fixtures_string + "#{system_name}:\n"
      fixtures_string=fixtures_string + "  system_name: #{system_name}\n"
      fixtures_string=fixtures_string + "  encrypted_password: #{BCrypt::Password.create(entries[0], :cost => 10)}\n"
      fixtures_string=fixtures_string + "  first_name: #{entries[1]}\n"
      fixtures_string=fixtures_string + "  middle_name: #{entries[2]}\n"
      fixtures_string=fixtures_string + "  last_name: #{entries[3]}\n"
      fixtures_string=fixtures_string + "  emails: #{entries[4]}\n"
      fixtures_string=fixtures_string + "  balance: #{system_name}\n\n"
    end

    fixtures_string=fixtures_string + "crap_1:\n"
    fixtures_string=fixtures_string + "  system_name: crap_1\n"
    fixtures_string=fixtures_string + "  encrypted_password: #{BCrypt::Password.create("crap_1", :cost => 10)}\n"
    fixtures_string=fixtures_string + "  first_name: Crap\n"
    fixtures_string=fixtures_string + "  last_name: One\n"
    fixtures_string=fixtures_string + "  emails: crap_1\n"
    fixtures_string=fixtures_string + "  balance: crap_1\n\n"

    fixtures_string=fixtures_string + "crap_2:\n"
    fixtures_string=fixtures_string + "  system_name: crap_2\n"
    fixtures_string=fixtures_string + "  encrypted_password: #{BCrypt::Password.create("crap_2", :cost => 10)}\n"
    fixtures_string=fixtures_string + "  first_name: Crap\n"
    fixtures_string=fixtures_string + "  last_name: Two\n"
    fixtures_string=fixtures_string + "  emails: crap_2\n"
    fixtures_string=fixtures_string + "  balance: crap_2\n\n"
    return fixtures_string
  end
  
  #---------------------------------------------------------------------------------------------
  # Password functionality

  #encrypt password to be stored for the member
  def process_password
    password = BCrypt::Password.create(self.encrypted_password, :cost => 10)
    self.encrypted_password = password
  end

  #request this member to start process to reset its password
  def reset_password
    if self.status.id != Status.pending.id
      self.collaboration_case = false
      self.is_guest = true
      self.unencrypted_password=Mariana.generate_password
      this_encryption=BCrypt::Password.create(self.unencrypted_password, :cost => 10)
      self.encrypted_password=this_encryption
      StatusMachine.set_status_on(self, Status::RESET, self)
      if self.save
        begin
          MemberMailer.deliver_forgot(self)
        rescue StandardError => bang
          Mariana.debug("Critical error trying to send e-mail to #{self.system_name}:" + bang)
          #TODO:4: How do we mark an action item to resend password?
        end
        return true
      end
      Mariana.debug("Unexpected error at saving time:#{self.errors.full_messages}")
    else
      Mariana.debug("member[#{self.id}]:#{self.system_name} accound on pending state is not allowed to reset password")
    end
    return false
  end

  #re stablish password and recover member status
  def recover_password
    self.collaboration_case = false
    StatusMachine.set_status_on(self, Status::AVAILABLE, self)
    if self.save
      return true
    end
    Mariana.debug("Unexpected error at saving time:#{self.errors.full_messages}")
    return false
  end


  

  #static:session_member:
  def Member.session_member(member_id)
    member_found = nil
    if member_id and member_id > 0
      begin
        member_found=Member.find(member_id)
      rescue
        Mariana.debug("[RESCUE]Member not found: id=#{member_id}")
      end
    end
    return member_found
  end

  #Verifies if the +action_object+ is allowed by +self+ member on +entity_class+
  # +action_object+:: Action instance requested to be verified for permission on self member
  # +entity_class+:: menuCook Class to be evaluated on this verification
  # +returns+:: Boolean: <b>true</b> if permission is granted, <b>false</b> otherwise
  def allow_action_on_entity(action_object, entity_class)
    #TODO:4: implement security
    return true
  end

  #Verifies if the +action_object+ is allowed by +self+ member on +entry+ object
  # +action_object+:: Action instance requested to be verified for permission on self member
  # +entry+:: menuCook object to be evaluated for permission
  # +returns+:: Boolean: <b>true</b> if permission is grated, <b>false</b> otherwise
  def allow_action_on_entry(action_obj, entry)
    #TODO:4: implement security
    return true
  end

  #validate if member is allowed to edit this_object
  # +this_object+:: Instance evaluated for permissions to edit
  def is_authorized_to_edit(this_object)
    if self.is_guest?
      return false
    else
      return true
    end
  end

  # start a member object in the database to request access permission
  # +member_name+:: string to state the system_name and e-mail to set the new user
  # +return+:: new member instance requested
  def self.create_from_sign_up_request(member_name)
    new_member_request = self.new
    new_member_request.system_name = member_name
    new_member_request.is_guest = true
    new_member_request.collaboration_case = false
    new_member_request.unencrypted_password=Mariana.generate_password
    this_encryption=BCrypt::Password.create(new_member_request.unencrypted_password, :cost => 10)
    new_member_request.encrypted_password=this_encryption
    if new_member_request.save
      StatusMachine.set_status_on(new_member_request, Status::PENDING, new_member_request)
      return new_member_request
    else
      Mariana.debug "Error trying to create a member from a request access event"
      message = ""
      new_member_request.errors.each do | this_error |
        message = message + this_error[1]
      end
      return ((message == "")? nil : message)
    end
  end

  #---------------------------------------------------------------------------------------------

end
