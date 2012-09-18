#Model:[DONE]: MysqlType
#Born:  20081114
#Author: Mauricio Inguanzo
#Description:
# Define constants for mysql types
class MysqlType
  
  ##################################################
  #Model Constants
  SYSTEM_NAME    = 'MysqlType'
  TABLE_NAME     = 'mysql_types'
  ENTITY_NAME    = 'mysql_type'
  READABLE_NAME  = 'MySQL type'
  DB_DESCRIPTION = 'MySQL type'
  DB_MIGRATION   = ''
  DB_ID          = 0

  INTEGER = 'integer'
  REF     = 'ref'
  STRING  = 'string' 
  TEXT    = 'text'   
  DATE    = 'date'   
  BOOLEAN = 'boolean'
  FLOAT   = 'float'
  DOUBLE  = 'double'
  REAL    = 'real'
  DECIMAL = 'decimal'
  DATE_TIME = 'datetime'   

  ##################################################
  #Model associations

  ##################################################
  #Model attributes

  ##################################################
  #Model fields

  ##################################################
  #Model validations

  ##################################################
  #Model default entries

  ##################################################
  #Model methods

end
