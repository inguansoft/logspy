#Model: Mariana
#Born: 20081129
#Author: Mauricio Inguanzo
#Description:
# Framework to support common generic functionality
class Mariana < ActiveRecord::Base
  self.abstract_class = true
  
  ##################################################
  #Model Constants
  SYSTEM_NAME    = 'Mariana'

  PASSWORD_LENGTH = 8
  NAME_LENGTH = 20
  
  MIN_NAME        = 4
  MIN_DESCRIPTION = 15

  MAXIMUM_SPONSORS_BY_SECTION = 8
  MAXIMUM_DISPLAY_BY_SECTION = 30
  MAXIMUM_DISPLAY            = 60

  SEARCH_LEVEL = "2"

  
  ##################################################
  #Model associations

  ##################################################
  #Model attributes

  ##################################################
  #Model fields
  
  ##################################################
  #Model validations
  
  ##################################################
  #Model methods

  ##################################################
  # Web Services functionality

  # web service receiver for reading CRUD request
  def self.web_read parameters, default_member=nil
    results = Array.new
    if parameters
      if parameters['pattern'] and parameters['pattern'].length > 0
        results = self.find_with_ferret(parameters['pattern'])
      else
        if parameters['ids']
          if parameters['ids'].class.to_s == 'Array'
            parameters['ids'].each do |this_id|
              item = self.find(this_id)
              results.push(item) if item
            end
          else
            item = self.find(parameters['ids'])
            results.push(item) if item
          end
        else
          results = self.find(:all)
        end
      end
    end
    return results
  end

  # web service receiver for reading CRUD request
  def self.web_delete parameters, default_member=nil
    results = self.web_read parameters, default_member
    #TODO: verify permissions!
    if results
      results.each do |this_item|
        self.delete(this_item)
      end
    end
    return results
  end

  # web service receiver for reading CRUD request
  def self.web_update parameters, default_member=nil
    results = Array.new
    if parameters and parameters['id'] and default_member
      item = self.find(parameters['id'])
      if item
        parameters.each do |this_param, this_value|
          item.send(this_param + "=", this_value) if (this_param != 'id')
        end
        if item.save
          results.push(item)
        end
      end
    else
      results = self.web_create parameters, default_member
    end
    return results
  end

  # web service receiver for create CRUD request
  def self.web_create parameters, default_member=nil
  end

  # prepare JSON stream to return to client through web services
  def self.json_stream this_instance
    json_stream = "{ \"entity\" : \"" + self::ENTITY_NAME + "\", \"result\" : ["
    if this_instance
      if this_instance.class.to_s == 'Array'
        if this_instance.length > 0
          substring = ""
          this_instance.each do |this_subitem|
            substring = substring + "," if substring != ""
            substring = substring + this_subitem.json_details
          end
          json_stream = json_stream + substring
        end
      else
        json_stream = json_stream + this_instance.json_details
      end
    end
    json_stream = json_stream + "] }"
    return json_stream
  end

  # retrieve the details about a specific supplier
  def json_details
    return ("{ " + to_json + " }")
  end

  #convert a model instance into a JSON stream
  def to_json
    results = ""
    (self.class::FIELDS.sort_by { |field, attrs| attrs[2] }).each do |this_field, these_attributes|
      if this_field !~ /_id$/ and these_attributes[1] != DefaultFormField::PASSWORD
        (results = results + ", ") if results != ""
        content = self.send(this_field.to_s).to_s.gsub(/\n/, "<br/>").gsub(/"/, '\\"')
        results = results + " \"" + this_field.to_s + "\" : \"" + content + "\""
      end
    end
    return results
  end
  
  # Load functionality
  #pre load default entries based on DEFAULT_VALUES Hash constant
  def self.load_fixtures
    fixtures_string = ""
    if self.const_defined?('DEFAULT_VALUES')
      self::DEFAULT_VALUES.each do |entry|
        fixtures_string=fixtures_string + "#{entry[:system_name]}:\n"
        fixtures_string=fixtures_string + "  system_name: #{entry[:system_name]}\n"
        fixtures_string=fixtures_string + "  readable_name: #{entry[:readable_name]}\n"
        fixtures_string=fixtures_string + "  description: #{entry[:description]}\n\n"
      end
    end
    return fixtures_string
  end

  #cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
  #   Mayor.create(:name => 'Daley', :city => cities.first)
  #pre load default entries based on DEFAULT_VALUES Hash constant
  def self.prepopulate
    if self.const_defined?('DEFAULT_VALUES')
      self.create(self::DEFAULT_VALUES)
    end
  end

  #static method used to define models fields in the model app and get the configuration on the DB migration automatically
  def self.schema_based_on_model(migration_obj, entity_class, explicit_id=false)
    if explicit_id
      # schema implementation with explicit ID declaration
      migration_obj.create_table entity_class::TABLE_NAME, :id => false do |t|
        entity_class::FIELDS.each do |this_field, these_attributes|
          t.column this_field, these_attributes[0]
        end
        t.timestamps
      end
      # end of schema implementation
    else
      # schema implementation with implicit ID declaration
      migration_obj.create_table entity_class::TABLE_NAME do |t|
        entity_class::FIELDS.each do |this_field, these_attributes|
          if this_field.to_s != 'id'
            t.column this_field, these_attributes[0]
          end
        end
        t.timestamps
      end
      # end of schema implementation
    end

  end
  #---------------------------------------------------------------------------------------------

  #---------------------------------------------------------------------------------------------
  # Framework helpers

  def self.build_path path_to_evaluate
    unless File.directory?(path_to_evaluate)
      array_of_dirs = path_to_evaluate.split "/"
      subdir = ""
      array_of_dirs.each do | this_dir |
        subdir = subdir + "/" + this_dir
        Dir.mkdir(subdir) unless File.directory?(subdir)
      end
    end
  end

  #generate password
  def self.generate_password
    chars = ('a' .. 'z').to_a + ('A' .. 'Z').to_a + ('1' .. '9').to_a + '%_$?@!'.split(//)
    Array.new(PASSWORD_LENGTH, '').collect { chars[rand(chars.size)] }.join
  end

  #generate name
  def self.generate_name
    chars = ('a' .. 'z').to_a + ('A' .. 'Z').to_a + ('1' .. '9').to_a
    Array.new(NAME_LENGTH, '').collect { chars[rand(chars.size)] }.join
  end

  #generate name
  def self.generate_safe_name
    chars = ('a' .. 'z').to_a
    Array.new(5, '').collect { chars[rand(chars.size)] }.join
  end

  #method to emulate readable_name entity per entity
  def self.readable_name(association)
    if (association.class.to_s == Supplier::SYSTEM_NAME)
      return self::READABLE_NAME_SUPPLIER
    else
      return self::READABLE_NAME
    end
  end
    
  #---------------------------------------------------------------------------------------------
  # Logging methods

  #Write out into the log as a debug comment
  def self.debug comment=""
    logger.info "<MARIANA>#{comment}</MARIANA>"
  end

  #---------------------------------------------------------------------------------------------
  # Status related functionality

  #set and logs init status on self
  def init(this_member)
    return StatusMachine.set_status_on(self, Status::INIT, this_member)
  end

  #set and logs available status on self
  def available(this_member)
    return StatusMachine.set_status_on(self, Status::AVAILABLE, this_member)
  end

  #set and logs verify status on self
  def verify(this_member)
    return StatusMachine.set_status_on(self, Status::VERIFY, this_member)
  end

  #set and logs pending status on self
  def pending(this_member)
    return StatusMachine.set_status_on(self, Status::PENDING, this_member)
  end

  #return the latest state_log set in self object
  def latest_status_log
    return self.status_logs.sort_by { |obj| obj.created_at }[-1]
  end

  #---------------------------------------------------------------------------------------------

  #---------------------------------------------------------------------------------------------
  # Test helpers

  #new an object with valid values for the model
  def self.create_a_valid_test_instance
    return self.new(
      :system_name   => "mauricioInguanzo",
      :readable_name => "Mauricio inguanzo",
      :description   => "This is the programmer and creator of Mariana!")
  end

  #take an object from the class and make crap out of it
  def self.get_a_valid_test_instance
    return self.get(get_a_valid_test_instance_system_name)
  end

  #take another object from the class and make crap out of it
  def self.get_second_valid_test_instance
    return self.get(get_second_valid_test_instance_system_name)
  end

  #provide the system name requested by this class
  def self.get_a_valid_test_instance_system_name
    return "crap_1"
  end

  #provide the second system name requested by this class
  def self.get_second_valid_test_instance_system_name
    return "crap_2"
  end
  
  #---------------------------------------------------------------------------------------------


  ##################################################
  #Model default entries  
  # SYSTEM_NAME  => CLASS
  DEFAULT_VALUES = {

  }

  # NAME  => CLASS
  DEFAULT_ENTITIES = {

  }

  #TABLE_NAME => CLASS
  DEFAULT_TABLES = {

  }

  #DB_MIGRATION => CLASS
  DEFAULT_MIGRATION_IDS = {

  }

  #ENTITY_NAME => CLASS
  WEB_SERVICES_CLASSES = {

  }
  ##################################################
  #Model methods

  # static method to generate the class based on +this_target+
  # +this_target+:: variable to look up menuCook clas that could be the class migration, class name, class table or class entity
  # +returns+:: Array: of actions allowed by +user_obj+ or +nil+ if there is any conflict on parameters provided
  def self.get_class_obj_for_webservices(this_target)
    if WEB_SERVICES_CLASSES[this_target]
      return WEB_SERVICES_CLASSES[this_target]
    else
      return nil
    end
  end

  # static method to generate the class based on +this_target+
  # +this_target+:: variable to look up menuCook clas that could be the class migration, class name, class table or class entity
  # +returns+:: Array: of actions allowed by +user_obj+ or +nil+ if there is any conflict on parameters provided
  def self.get_class_obj(this_target)
    if this_target != nil and this_target != ""
      target = this_target.to_s
      return DEFAULT_MIGRATION_IDS[target] if DEFAULT_MIGRATION_IDS[target]
      return DEFAULT_VALUES[target] if DEFAULT_VALUES[target]
      return DEFAULT_TABLES[target] if DEFAULT_TABLES[target]
      return DEFAULT_ENTITIES[target] if DEFAULT_ENTITIES[target]
      possible_integer = target.to_i
      if possible_integer and possible_integer > 0
        target = sprintf("%03d", target.to_i)
        return DEFAULT_MIGRATION_IDS[target] if DEFAULT_MIGRATION_IDS[target]
      end
    end
    return nil
  end
  
  #Static method to generate the object based on the DBID and the obj id
  def self.get_obj(this_dbid, this_id=nil)
    this_object = nil
    if this_dbid and this_dbid.to_i > 0
      this_class=MenucookEntity.get_class_obj(this_dbid)
      if this_class
        if this_id
          this_object = this_class.find(this_id.to_i)
        else
          this_object = this_class.new
        end
      end
    end
    return this_object
  end




end
