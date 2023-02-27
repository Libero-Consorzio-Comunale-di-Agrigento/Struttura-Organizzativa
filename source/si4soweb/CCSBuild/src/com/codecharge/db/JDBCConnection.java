/******************************************************************************
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    05/02/2003 AO     Gestione CLOB come return delle function
 2    05/05/2003 AO     Gestione CLOB come return delle function per patch 2.0.6.11 CodeCharge
 3    30/12/2003 AO     Gestione CLOB come return delle function per CCS 2.2.3.57
 4    03/08/2004 AO     Gestione CLOB come return delle function per CCS 2.3.1.85
 5    25/08/2004 AO     Gestione CLOB come return delle function per CCS 2.3.2
 6    05/10/2005 AO     Gestione CLOB come return delle function per CCS 2.3.2.28
******************************************************************************/

//JDBCConnection @0-4AECBB5D
package com.codecharge.db;

import java.sql.*;
import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.components.*;
import com.codecharge.util.*;

/**
  * Auxilary class that wrapps work with pooled connections and provides handy methods to send queries to server.
  */
abstract public class JDBCConnection implements SqlFormatControl {

  final static public int INTEGER = 0;
  final static public int FLOAT = 1;
  final static public int NUMERIC = 1;
  final static public int DATE = 2;
  final static public int BOOLEAN = 3;
  final static public int TEXT = 4;
  final static public int MEMO = 5;

  final static public int LIMIT_NOT_SUPPORTED = 20;
  final static public int LIMIT_LIMIT_SYNTAX = 21;
  final static public int LIMIT_TOP_SYNTAX = 22;

  CCLogger logger;

  protected String poolName;
  protected Connection conn;
  protected boolean next;
  protected Vector errors;
  protected Format booleanFormat;
  protected Format dateFormat;

  protected String booleanFormatPattern;
  protected String dateFormatPattern;

  protected String leftDateDelimiter = "";
  protected String rightDateDelimiter = "";
  protected String dbType = "";
  protected boolean useUpperCase = false;
  protected CCSLocale ccsLocale;
  protected int driverJdbcVersion;
  
  /**
   * Indicate whether sql optimization should be used for this connection.
   * Sql optimization works for 'MySQL', 'PostgreSQL', 
   * 'MSAccess' or 'MSSQLServer' and uses LIMIT or TOP syntax to
   * limit number of returned records.
   */
  protected boolean optimizeSQL;

  public JDBCConnection(String name) {
    this(name,true);
  }

  public JDBCConnection(String name, boolean initConnection) {
    poolName = name;
    errors = new Vector();
    logger = CCLogger.getInstance();

    booleanFormat = (Format) ContextStorage.getInstance().getAttribute( poolName + "BooleanFormat" );
    dateFormat = (Format) ContextStorage.getInstance().getAttribute( poolName + "DateFormat" );

    Properties siteProps = (Properties) ContextStorage.getInstance().getAttribute(Names.SITE_PROPERTIES_KEY);
    dbType = siteProps.getProperty(poolName+".dbType");
    leftDateDelimiter = siteProps.getProperty(poolName+".dateLeftDelim");
    rightDateDelimiter = siteProps.getProperty(poolName+".dateRightDelim");
    String uuc = siteProps.getProperty(poolName+".dbNameUppercase");
    
    if (! "".equals(siteProps.getProperty(poolName+".optimizeSQL"))) {
        optimizeSQL = new Boolean(siteProps.getProperty(poolName+".optimizeSQL")).booleanValue();
    }
    if ( ! StringUtils.isEmpty(uuc) ) {
        useUpperCase = (new Boolean(uuc)).booleanValue();
    }
    if ( initConnection ) {
        getConnection();
    }
    Integer jdbcVer = (Integer) ContextStorage.getInstance().getAttribute(poolName + ".runtime.driverJdbcVersion");
    if (jdbcVer != null) {
        this.driverJdbcVersion = jdbcVer.intValue();
    }
    if (this.driverJdbcVersion < 1) {
        if (this.conn != null) {
            Statement stmt = null;
            try {
                stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                this.driverJdbcVersion = 2;
                try {
                    if (stmt != null) stmt.close();
                } catch (SQLException sqle_ignore) {}
            } catch (Throwable t) {
                this.driverJdbcVersion = 1;
            }
            ContextStorage.getInstance().setAttribute(poolName + ".runtime.driverJdbcVersion", new Integer(this.driverJdbcVersion));
        }
    }
  }

	public CCSLocale getCCSLocale() {
		return ccsLocale;
	}
    
    public boolean isOptimizeSQL() {
        return optimizeSQL;
    }
    
    public int getLimitSyntax() {
        int syntax = JDBCConnection.LIMIT_NOT_SUPPORTED;
        if (isOptimizeSQL()) {
            if ("MySQL".equalsIgnoreCase(dbType)) {
                syntax = JDBCConnection.LIMIT_LIMIT_SYNTAX;
            } else if("PostgreSQL".equals(dbType)) {
                syntax = JDBCConnection.LIMIT_LIMIT_SYNTAX;
            } else if("MSSQLServer".equals(dbType)) {
                syntax = JDBCConnection.LIMIT_TOP_SYNTAX;
            } else if("MSAccess".equals(dbType)) {
                syntax = JDBCConnection.LIMIT_TOP_SYNTAX;
            } 
        }
        return syntax;
    }

    public String getLimitClause(int startPos, int fetchSize) {
        String limitClause = "";
        if (isOptimizeSQL()) {
            if ("MySQL".equalsIgnoreCase(dbType)) {
                limitClause = " LIMIT "+(startPos < 1 ? 0 : startPos-1)+","+fetchSize;
            } else if("PostgreSQL".equals(dbType)) {
                limitClause = " LIMIT "+fetchSize+" OFFSET "+(startPos < 1 ? 0 : startPos-1);
            } else if("MSSQLServer".equals(dbType)) {
                limitClause = String.valueOf((startPos < 1 ? 0 : startPos-1)+fetchSize);
            } else if("MSAccess".equals(dbType)) {
                limitClause = String.valueOf((startPos < 1 ? 0 : startPos-1)+fetchSize);
            } 
        }
        return limitClause;
    }

  /** Get Pool name. This name corresponds with CCS Connection name.
    @return connection name */
  public String getPoolName() {
      return poolName;
  }

  /** Set Locale. This locale is used to format data before it is inserted, updated and when it is selected.
    @param locale locale with language and country settings */
  public void setLocale(Locale locale) {
    //Format dateFormat;
    //Format booleanFormat;
    Properties siteProps = new Properties();
    ccsLocale = new CCSLocale( locale );

    siteProps = (Properties)ContextStorage.getInstance().getAttribute(Names.SITE_PROPERTIES_KEY);
    Enumeration propNames = siteProps.propertyNames();
    dateFormatPattern = siteProps.getProperty(poolName + ".dateFormat");
    if ( ! StringUtils.isEmpty(dateFormatPattern) ) {
        if ( "GeneralDate".equalsIgnoreCase( dateFormatPattern ) ) {
            dateFormat = java.text.DateFormat.getDateTimeInstance(DateFormat.DEFAULT, DateFormat.DEFAULT, locale);
        } else if ( "LongDate".equalsIgnoreCase( dateFormatPattern ) ) {
            dateFormat = java.text.DateFormat.getDateInstance(java.text.DateFormat.LONG, locale);
        } else if ( "ShortDate".equalsIgnoreCase( dateFormatPattern ) ) {
            dateFormat = java.text.DateFormat.getDateInstance(java.text.DateFormat.SHORT, locale);
        } else if ( "LongTime".equalsIgnoreCase( dateFormatPattern ) ) {
            dateFormat = java.text.DateFormat.getTimeInstance(java.text.DateFormat.LONG, locale);
        } else if ( "ShortTime".equalsIgnoreCase( dateFormatPattern ) ) {
            dateFormat = java.text.DateFormat.getTimeInstance(java.text.DateFormat.SHORT, locale);
        } else {
            dateFormat = new java.text.SimpleDateFormat( dateFormatPattern, locale );
        }
    }
    booleanFormatPattern = siteProps.getProperty(poolName + ".booleanFormat");
    if ( ! StringUtils.isEmpty(booleanFormatPattern) ) {
      int pos = booleanFormatPattern.indexOf( ";" );
      int pos1 = booleanFormatPattern.indexOf( ";" , pos+1 );
      if ( pos > -1 ) {
        String trueValue = booleanFormatPattern.substring ( 0, pos );
        String falseValue = null;
        String defaultValue = null;
        if ( pos1 == -1 ) {
            falseValue = booleanFormatPattern.substring ( pos+1 );
        } else {
            falseValue = booleanFormatPattern.substring ( pos+1, pos1 );
            defaultValue = booleanFormatPattern.substring ( pos1+1 );
        }
        booleanFormat = new BooleanFormat( trueValue, falseValue, defaultValue, locale );
      }
    }
    if ( dateFormat != null )  ContextStorage.getInstance().setAttribute( poolName + "DateFormat", dateFormat );
    if ( booleanFormat != null )  ContextStorage.getInstance().setAttribute( poolName + "BooleanFormat", booleanFormat );
  }

  private class SimpleMetaData {
    private String[] columnName;
    private String[] tableName;
    private int columnCount;

    public SimpleMetaData( ResultSet rs ) {
        if ( rs == null ) {
          addError( "SimpleMetaData( ResultSet ) : ResultSet is null" ); 
          logger.error( "SimpleMetaData( ResultSet ) : ResultSet is null\n" ); 
        }
        else {
          try {
            java.sql.ResultSetMetaData metaData = rs.getMetaData();
            columnCount = metaData.getColumnCount();
            columnName = new String[columnCount];
            tableName = new String[columnCount];
            for(int j = 0; j < columnCount; j++) {
              columnName[j] = metaData.getColumnLabel(j+1);
              tableName[j] = metaData.getTableName(j+1);
            }
          } catch ( SQLException sqle ) {
            addError( "SimpleMetaData( ResultSet ) : Cannot get ResultSetMetaData" );  
            logger.error( "SimpleMetaData( ResultSet ) : Cannot get ResultSetMetaData\n" );  
          }
        }
    }

    public String getColumnName( int columnIndex ) {
      return columnName[columnIndex];
    }

    public String getTableName( int columnIndex ) {
      return tableName[columnIndex];
    }

    public String getFullColumnName( int columnIndex ) {
      return tableName[columnIndex] + "." + columnName[columnIndex];
    }

    public int getColumnCount() {
      return columnCount;
    }

  }

  /** Obtain connection from the pool. This method is used to obtain connection from pool of connections.
    New connection is created only if there is no free connections otherwise connections are reused.
    You should call closeConnection method when it as no more needed to return connection to the pool. */
  abstract public void getConnection();
  /** Return connection to the pool. This method doesn't really close connection but returns it to the
    pool of connections to be reused in future. */
  abstract public void closeConnection();

  public void setLeftDateDelimiter( String delimiter ) {
      if ( delimiter == null ) {
          leftDateDelimiter = "";
      } else {
          leftDateDelimiter = delimiter;
      }
  }

  public void setRightDateDelimiter( String delimiter ) {
      if ( delimiter == null ) {
          rightDateDelimiter = "";
      } else {
          rightDateDelimiter = delimiter;
      }
  }

  public String getDbType() {
      if ( StringUtils.isEmpty(dbType) ) {
          this.dbType = "ANSI";
      }
      return this.dbType;
  }

  public Format getBooleanFormat() {
    return ( (Format) booleanFormat );
  }

  public Format getDateFormat() {
    return ( (Format) dateFormat );
  }

  public void clearErrors() {
    errors.removeAllElements();
  }

/** Whether connection has errors.
 * @return true - if connection has errors; false otherwise
 */
  public boolean hasErrors() {
    return ( errors.size() > 0 );
  }

  /** Get Collection of errors.
   * @return the collection of errors
   */
  public Vector getErrors() {
    return errors;
  }

/** Get all errors represented as one string.
 * @return a String that represent of the all errors.
 */
public String getErrorsAsString() {
    StringBuffer sb = new StringBuffer();
    for ( int i = 0; i < errors.size(); i++ ) {
      sb.append( errors.get( i )+"\n" );
    }
    return sb.toString();
  }

  /** Add error message to errors collection.
   * @param error the error message
   */
  void addError( String error ) {
    errors.add( error );
  }

  /**
   * Execute INSERT/UPDATE/DELETE SQL-query.
   * @param sql SQL query string
   * @return either the row count for INSERT, UPDATE or DELETE statements,
   * or 0 for SQL statements that return nothing, or -1 if parameter is null
   */
  public int executeUpdate( String sql ) {
    int retVal = 0;
    java.sql.Statement stat = null;

    if ( ! isConnection ( conn ) ) {
      addError( "JDBCConnection.executeUpdate() : connection is null." );  
      logger.error( "JDBCConnection.executeUpdate() : connection is null.");  
      retVal = -1;
    }
    if ( StringUtils.isEmpty(sql) ) {
      addError( "JDBCConnection.executeUpdate() : SQL statement is empty or null." );  
      logger.error( "JDBCConnection.executeUpdate() : SQL statement is empty or is null."); 
      retVal = -1;
    }
    if ( retVal == 0 ) {
      try {
        stat = conn.createStatement();
        retVal = stat.executeUpdate ( sql );
        closeStatement(stat);
      }
      catch ( java.sql.SQLException sqle ) {
        retVal = -1;
        addError( "JDBCConnection.executeUpdate() : " + sqle.getMessage() ); 
        logger.error( "JDBCConnection.executeUpdate(\""+sql+"\") : ", sqle); 
      }
    }
    return retVal;
  }

  /**
   * Execute Stored Procedure.
   * @param cstmt callable statement object, created by createCallableStatement method
   * @return true if operation was successfull, false otherwise
   */
  public boolean execute ( CallableStatement cstmt ) {
    if ( cstmt == null ) {
      addError( "JDBCConnection.execute() : callable statement is null" ); 
      logger.error( "JDBCConnection.execute() : callable statement is null\n"); 
      return false;
    }
    try {
      return cstmt.execute();
    }
    catch ( java.sql.SQLException sqle ) {
      addError( "JDBCConnection.execute() " + sqle.getMessage() ); 
      logger.error( "JDBCConnection.execute() ", sqle ); 
      return false;
    }
  }

  /*
    Count number of records
  */
  public int count(String sql) {
    int result = 0;
    if ( StringUtils.isEmpty(sql) ) {
      addError( "JDBCConnection.count( String ): SQL statement is empty." ); 
      logger.error("JDBCConnection.count( String ): SQL statement is empty."); 
      result = -1;
    }
    if ( ! isConnection ( conn ) ) {
      addError( "JDBCConnection.count( String ): connection is null." ); 
      logger.error("JDBCConnection.count( String ): connection is null."); 
      result = -1;
    }
    if ( result == 0 ) {
      java.sql.Statement stat = null;
      java.sql.ResultSet rs = null;
      try {
        stat = conn.createStatement();
        rs = stat.executeQuery(sql);
        if (rs.next()) {
          result = rs.getInt(1);
        }
      }
      catch ( java.sql.SQLException sqle ) {
        addError ( "JDBCConnection.count() fails"); 
        logger.error( "JDBCConnection.count(\""+sql+"\") fails", sqle); 
        result = -1;
      }
      finally {
        closeResultSet(rs);
        closeStatement(stat);
      }
    }
    return result;
  }

  public long getLong( String sql ) {
    long result = 0;
    if ( StringUtils.isEmpty(sql) ) {
      addError( "JDBCConnection.getLong( String ): SQL statement is empty." ); 
      logger.error("JDBCConnection.getLong( String ): SQL statement is empty."); 
      result = Long.MIN_VALUE;
    }
    if ( ! isConnection ( conn ) ) {
      addError( "JDBCConnection.getLong( String ): connection is null." ); 
      logger.error("JDBCConnection.getLong( String ): connection is null."); 
      result = Long.MIN_VALUE;
    }
    if ( result == 0 ) {
      java.sql.Statement stat = null;
      java.sql.ResultSet rs = null;
      try {
        stat = conn.createStatement();
        rs = stat.executeQuery(sql);
        if (rs.next()) {
          result = rs.getLong(1);
        }
      }
      catch ( java.sql.SQLException sqle ) {
        addError ( "JDBCConnection.getLong() fails"); 
        logger.error( "JDBCConnection.getLong(\""+sql+"\") fails", sqle); 
        result = Long.MIN_VALUE;
      }
      finally {
        closeResultSet(rs);
        closeStatement(stat);
      }
    }
    return result;
  }

  public double getDouble( String sql ) {
    double result = 0;
    if ( StringUtils.isEmpty(sql) ) {
      addError( "JDBCConnection.getDouble( String ): SQL statement is empty." ); 
      logger.error("JDBCConnection.getDouble( String ): SQL statement is empty."); 
      result = Double.MIN_VALUE;
    }
    if ( ! isConnection ( conn ) ) {
      addError( "JDBCConnection.getDouble( String ): connection is null." ); 
      logger.error("JDBCConnection.getDouble( String ): connection is null."); 
      result = Double.MIN_VALUE;
    }
    if ( result == 0 ) {
      java.sql.Statement stat = null;
      java.sql.ResultSet rs = null;
      try {
        stat = conn.createStatement();
        rs = stat.executeQuery(sql);
        if (rs.next()) {
          result = rs.getDouble(1);
        }
      }
      catch ( java.sql.SQLException sqle ) {
        addError ( "JDBCConnection.getDouble() fails"); 
        logger.error( "JDBCConnection.getDouble(\""+sql+"\") fails", sqle); 
        result = Double.MIN_VALUE;
      }
      finally {
        closeResultSet(rs);
        closeStatement(stat);
      }
    }
    return result;
  }

  public boolean getBoolean( String sql ) {
    boolean result = false;
    if ( StringUtils.isEmpty(sql) ) {
      addError( "JDBCConnection.getBoolean( String ): SQL statement is empty." ); 
      logger.error("JDBCConnection.getBoolean( String ): SQL statement is empty."); 
      return result;
    }
    if ( ! isConnection ( conn ) ) {
      addError( "JDBCConnection.getBoolean( String ): connection is null." ); 
      logger.error("JDBCConnection.getBoolean( String ): connection is null."); 
      return result;
    }
    java.sql.Statement stat = null;
    java.sql.ResultSet rs = null;
    try {
      stat = conn.createStatement();
      rs = stat.executeQuery(sql);
      if (rs.next()) {
        result = rs.getBoolean(1);
      }
    }
    catch ( java.sql.SQLException sqle ) {
      addError ( "JDBCConnection.getBoolean() fails"); 
      logger.error( "JDBCConnection.getBoolean(\""+sql+"\") fails", sqle); 
      result = false;
    }
    finally {
      closeResultSet(rs);
      closeStatement(stat);
    }
    return result;
  }

  public String getString( String sql ) {
    String result = null;
    if ( StringUtils.isEmpty(sql) ) {
      addError( "JDBCConnection.getString( String ): SQL statement is empty." ); 
      logger.error("JDBCConnection.getString( String ): SQL statement is empty."); 
      return result;
    }
    if ( ! isConnection ( conn ) ) {
      addError( "JDBCConnection.getString( String ): connection is null." ); 
      logger.error("JDBCConnection.getString( String ): connection is null."); 
      return result;
    }
    java.sql.Statement stat = null;
    java.sql.ResultSet rs = null;
    try {
      stat = conn.createStatement();
      rs = stat.executeQuery(sql);
      if (rs.next()) {
        result = rs.getString(1);
      }
    }
    catch ( java.sql.SQLException sqle ) {
      addError ( "JDBCConnection.getString() fails"); 
      logger.error( "JDBCConnection.getString(\""+sql+"\") fails", sqle); 
      result = null;
    }
    finally {
      closeResultSet(rs);
      closeStatement(stat);
    }
    return result;
  }

  /** Convert string value to sql expression by adding quotes and delimiters.
    @param value element of sql expression
    @param type type of the value, indicating which changes are needed
    @return converted (SQL safe) string */
  public String toSql( String value, int type ) {
      String result = "";
      if ( value == null ) {
        return "NULL";
      }
      switch ( type ) {
          case JDBCConnection.MEMO:
              result = value;
          	  break;
		  case JDBCConnection.TEXT:
              result = "'" + StringUtils.replace( value, "'", "''" ) + "'";
              if ( "MySQL".equals(dbType) ) {
                  result = StringUtils.replace( result, "\\", "\\\\" );
              }
              break;
          case JDBCConnection.BOOLEAN:

              boolean isQuot = true;
              try {
                  double ignore = Double.parseDouble( (String) value );
                  isQuot = false;
              } catch ( NumberFormatException nfe ) {
                  if ( "true".equalsIgnoreCase( (String) value ) || "false".equalsIgnoreCase( (String) value ) || "null".equalsIgnoreCase( (String) value ) ) {
                      isQuot = false;
                  }
              }
              if ( isQuot ) {
                  result = "'" + StringUtils.replace( value, "'", "''" ) + "'";
              } else {
                  result = StringUtils.replace( value, "'", "''" );
              }

              break;
          case JDBCConnection.INTEGER:
          case JDBCConnection.FLOAT:
              result = StringUtils.replace( value, ",", "." );
              try {
                  Double.parseDouble( result );
              } catch ( NumberFormatException nfe ) {
                  result = "NULL";
              }
              break;
          case JDBCConnection.DATE:
              result = leftDateDelimiter + StringUtils.replace( value, "'", "''" ) + rightDateDelimiter;
              break;
      }
      return result;
  }

  /** Convert string value to sql expression by adding quotes and delimiters.
    @param value element of sql expression
    @param type type of the value, indicating which changes are needed
    @return converted (SQL safe) string */
    public String toSql( String value, ControlType type ) {
        String toSql = "";
        if ( type == ControlType.TEXT ) {
            toSql = toSql( value, JDBCConnection.TEXT );
        } else if ( type == ControlType.MEMO ) {
            toSql = toSql( value, JDBCConnection.MEMO );
        } else if ( type == ControlType.BOOLEAN ) {
            toSql = toSql( value, JDBCConnection.BOOLEAN );
        } else if ( type == ControlType.INTEGER ) {
            toSql = toSql( value, JDBCConnection.INTEGER );
        } else if ( type == ControlType.FLOAT ) {
            toSql = toSql( value, JDBCConnection.FLOAT );
        } else if ( type == ControlType.DATE ) {
            toSql = toSql( value, JDBCConnection.DATE );
        }
        return toSql;
    }

  /** Convert boolean value to sql expression by adding quotes and delimiters.
    @param value element of sql expression
    @return converted (SQL safe) string */
  public String toSql( boolean value ) {
      String result = "";
      if ( this.booleanFormat == null ) {
        result = String.valueOf( value );
      } else {
        result = this.booleanFormat.format( new Boolean (value) );
      }
      return StringUtils.replace( result, "'", "''" );
  }

  /** Convert Boolean value to sql expression by adding quotes and delimiters.
    @param value element of sql expression
    @return converted (SQL safe) string */
  public String toSql( Boolean value ) {
      String result = "";
      if ( this.booleanFormat == null ) {
        result = String.valueOf( value );
      } else {
        result = this.booleanFormat.format( value );
      }
      return StringUtils.replace( result, "'", "''" );
  }

  /** Convert Date value to sql expression by adding quotes and delimiters.
    @param value element of sql expression
    @return converted (SQL safe) string */
  public String toSql( java.util.Date value ) {
      String result = "";
      if ( this.dateFormat == null ) {
        result = String.valueOf( value );
      } else {
        result = this.dateFormat.format( value );
      }
      return leftDateDelimiter + StringUtils.replace( result, "'", "''" ) + rightDateDelimiter;
  }

  /**
   * Returns Enumeration of DbRows representing records from the ResultSet
   *
   * @param sql static SQL SELECT statement
   * @param start position of first record to read
   * @param max maximum number of records to read
   * @return the data produced by the given query in form of Enumeration object
   */
  public Enumeration getRows(String sql, int start, int max) {
    if ( StringUtils.isEmpty(sql) ) {
      addError( "JDBCConnection.getRows( String, int, int ): SQL statement is empty." ); 
      logger.error("JDBCConnection.getRows( String, int, int ): SQL statement is empty." ); 
      return null;
    }
    java.util.Enumeration erows = null;
    if ( ! isConnection ( conn ) ) {
      addError( "JDBCConnection.getRows( String, int, int ): connection is null." ); 
      logger.error( "JDBCConnection.getRows( String, int, int ): connection is null." ); 
      return null;
    }
    else {
      java.sql.Statement stat = null;
      java.sql.ResultSet rs = null;
      int iCounter = 0;
      try {
        stat = createStatement();
        rs = stat.executeQuery(sql);
        erows = getRows ( rs, start, max );
      }
      catch ( java.sql.SQLException sqle ) {
        addError( "JDBCConnection.getRows() : " + sqle.getMessage() ); 
        logger.error( "JDBCConnection.getRows(\""+sql+"\","+max+","+start+") : ", sqle); 
        erows = null;
      }
      finally {
        closeResultSet(rs);
        closeStatement(stat);
      }
    }
    return erows;
  }

  public Enumeration getRows( java.sql.ResultSet rs, int start, int max) {
    java.util.Enumeration erows = null;
    if ( rs == null ) {
      addError( "JDBCConnection.getRows( ResultSet, int, int ) : ResultSet is null" ); 
      logger.error( "JDBCConnection.getRows( ResultSet, int, int ) : ResultSet is null\n" ); 
      return null;
    }
    else {
      int iCounter = 0;
      java.util.Vector rows = new java.util.Vector();
      try {
        if ( rs != null ) {
          if ( start < 1 ) { start = 1; }
          if ( max < 1 ) { max = 1; }
          boolean eof = absolute( rs, start );
          if ( ! eof ) {
            SimpleMetaData rsMetaData = new SimpleMetaData( rs );
        next = false;
            while ( rs.next() ) {
              if (iCounter++ >= max) {next = true; break;}
              rows.add(getRecordToHash ( rs, rsMetaData ));
            }
            //next = rs.next();
          }
          else {
            next = false;
          }
        }
        erows = rows.elements();
      }
      catch ( java.sql.SQLException sqle ) {
        addError( "JDBCConnection.getRows(\""+rs.toString()+"\","+max+","+start+") : " + sqle.getMessage() ); 
        logger.error( "JDBCConnection.getRows(\""+rs.toString()+"\","+max+","+start+") : ", sqle); 
        return null;
      }
    }
    return erows;
  }

// following getRows functions must be rewritten.
  public Enumeration getRows(String sql) {
    if ( StringUtils.isEmpty(sql) ) {
      addError( "JDBCConnection.getRows( String ): SQL statement is empty." ); 
      logger.error( "JDBCConnection.getRows( String ): SQL statement is empty." ); 
      return null;
    }
    if ( ! isConnection ( conn ) ) {
      addError( "JDBCConnection.getRows( String ): connection is null." ); 
      logger.error( "JDBCConnection.getRows( String ): connection is null." ); 
      return null;
    }

    java.util.Enumeration erows = null;

    java.sql.Statement stat = null;
    java.sql.ResultSet rs = null;
    int iCounter = 0;
    try {
      stat = createStatement();
      rs = stat.executeQuery(sql);
      erows = getRows ( rs );
    }
    catch ( java.sql.SQLException sqle ) {
      addError( "JDBCConnection.getRows() : " + sqle.getMessage() ); 
      logger.error( "JDBCConnection.getRows() : ", sqle); 
    }
    finally {
      closeResultSet(rs);
      closeStatement(stat);
    }

    return erows;
  }

  public Enumeration getRows( java.sql.ResultSet rs ) {
    java.util.Enumeration erows = null;
    if ( rs == null ) {
      addError( "JDBCConnection.getRows( ResultSet ) : ResultSet is null"); 
      logger.error( "JDBCConnection.getRows( ResultSet ) : ResultSet is null\n"); 
      return null;
    }
    int iCounter = 0;
    java.util.Vector rows = new java.util.Vector();
    try {
      if ( rs != null ) {
        SimpleMetaData rsMetaData = new SimpleMetaData( rs );
        while ( rs.next() ) {
          rows.add(getRecordToHash ( rs, rsMetaData ));
        }
        next = false;
      }
      erows = rows.elements();
    }
    catch ( java.sql.SQLException sqle ) {
      addError( "JDBCConnection.getRows(\""+rs.toString()+"\") : " + sqle.getMessage() ); 
      logger.error( "JDBCConnection.getRows(\""+rs.toString()+"\") : ", sqle ); 
    }
    return erows;
  }

  /**
     Get one row from SQL query result.
     @param sql SQL query string
     @return DbRow containing result or null if recordset is empty.
  **/
  public DbRow getOneRow(String sql) {
    DbRow rsHash = null;
    if ( StringUtils.isEmpty(sql) ) {
      addError( "JDBCConnection.getOneRow ( String ): SQL statement is empty." ); 
      logger.error( "JDBCConnection.getOneRow ( String ): SQL statement is empty." ); 
      return null;
    }
    if ( ! isConnection ( conn ) ) {
      addError( "JDBCConnection.getOneRow ( String ): connection is null." ); 
      logger.error( "JDBCConnection.getOneRow ( String ): connection is null." ); 
    } else {
      java.sql.Statement stat = null;
      java.sql.ResultSet rs = null;
      // rsHash = new java.util.Hashtable();
      try {
        stat = conn.createStatement();
        rs = stat.executeQuery(sql);
        rsHash = getOneRow ( rs );
      }
      catch (java.sql.SQLException sqle) {
        addError( "JDBCConnection.getOneRow () : " + sqle.getMessage() ); 
        logger.error( "JDBCConnection.getOneRow (\""+sql+"\") : ", sqle ); 
      }
      finally {
        closeResultSet(rs);
        closeStatement(stat);
      }
    }
    return rsHash;
  }

  public DbRow getOneRow( java.sql.ResultSet rs ) {
    DbRow rsHash = null;
    if ( rs == null ) {
      addError( "JDBCConnection.getOneRow( ResultSet ) : ResultSet is null" ); 
      logger.error( "JDBCConnection.getOneRow( ResultSet ) : ResultSet is null\n" ); 
    } else {
      try {
        if (rs.next()) {
          SimpleMetaData rsMetaData = new SimpleMetaData( rs );
          rsHash = getRecordToHash ( rs, rsMetaData );
          this.next = true;
        } else {
          this.next = false;
        }
      } catch (java.sql.SQLException sqle) {
        addError( "JDBCConnection.getOneRow( ResultSet ) : " + sqle.getMessage() ); 
        logger.error( "JDBCConnection.getOneRow( ResultSet ) : ", sqle ); 
      }
    }
    return rsHash;
  }

  /**
   * Returns array of String object are present name columns from ResultSet object
   * @param rs is a ResultSet object
   * @return array of String. never null.
   * @exception SQLException if a database access error occurs
   */
  private String[] getFieldsName ( java.sql.ResultSet rs ) throws java.sql.SQLException {
    if ( rs == null ) {
      addError( "JDBCConnection.getFieldsName ( ResultSet ) : ResultSet is null" ); 
      logger.error( "JDBCConnection.getFieldsName ( ResultSet ) : ResultSet is null\n" ); 
      return null;
    }
    else {
      java.sql.ResultSetMetaData metaData = rs.getMetaData();
      int count = metaData.getColumnCount();
      String[] aFields = new String[count];
      for(int j = 0; j < count; j++) {
        aFields[j] = metaData.getColumnLabel(j+1);
      }
      return aFields;
    }
  }

  /**
   * Returns Hashtable object contains one record from ResultSet
   * @param rs is a ResultSet object with data
   * @param rsMetaData is a SimpleMetaData of resultSet
   * @return Hashtable
   */
  private DbRow getRecordToHash(java.sql.ResultSet rs,
        SimpleMetaData rsMetaData ) throws java.sql.SQLException {
    DbRow rsHash = null;
    if ( rsMetaData == null ) {
      addError( "JDBCConnection.getRecordToHash : rsMetaData is null" ); 
      logger.error( "JDBCConnection.getRecordToHash : rsMetaData is null\n" ); 
    } else if ( rs == null ) {
      addError( "JDBCConnection.getRecordToHash : ResultSet is null" ); 
      logger.error( "JDBCConnection.getRecordToHash : ResultSet is null\n" ); 
    } else {
      //rsHash = new java.util.Hashtable();
      rsHash = new DbRow();
      rsHash.setUseUpperCase(useUpperCase);
      for ( int iF = 0; iF < rsMetaData.getColumnCount(); iF++ ) {
        try {
          if ( rsHash.get(new Integer(iF)) == null ) {
            //Object val = rs.getObject(iF+1);
            Object val;
            try { // workaround for Access
              val = rs.getObject(iF+1);
            } catch (java.sql.SQLException sqle) {
              val = null;
            }
            val = (val == null) ? "" : val;
// Rev.6 : Gestione CLOB custom AFC
            if (val.getClass().getName().equals("oracle.sql.CLOB")) 
            {
              Clob clob = (Clob) val;
              val = clob.getSubString(1, (int) clob.length());
            }
// Rev.6 : fine gestione CLOB
            
            String key = rsMetaData.getColumnName(iF);
            if ( ! StringUtils.isEmpty(key) ) {
                rsHash.put( key, val);
            }
            key = rsMetaData.getFullColumnName(iF);
            if ( ! StringUtils.isEmpty(key) ) {
                rsHash.put( key, val);
            }
            rsHash.put( new Integer(iF), val);
          }
        } catch ( NullPointerException npe ) {
          StringBuffer error = new StringBuffer();
          error.append( "=== NullPointerException =============\n" +
                  "'" + rsMetaData.getColumnName(iF) + "' Field is not found in query result\n"); 
          System.out.println(error.toString());
        }

      }
    }
    return rsHash;
  }

  /**
   * Rewind recordset
   * @param rs  - recordset
   * @param row - number of target row
   * return boolean - if (End of recordset) then true
   *                  else false
   */
  private boolean absolute( java.sql.ResultSet rs, int row) throws java.sql.SQLException {
    boolean result = false;
    if (this.driverJdbcVersion > 1 && row > 1) {
        result = ! rs.absolute(row-1); 
    } else {
        for( int x=1; x<row; x++ ) {
          result = !rs.next();
          if ( result ) break;
        }
    }
    return result;
  }

  public boolean isNext() {
    return next;
  }

  public void setBooleanFormat( Format format ) {
    booleanFormat = format;
  }

  public void setDateFormat( Format format ) {
    dateFormat = format;
  }

  /** Create CallableStatement by preparing procedure call provided by callString parameter.
     @param callString query that calls stored procedure
     @return callable statement object */
  public CallableStatement createCallableStatement( String callString ) {
    try {
        CallableStatement cstmt = null;
        if (this.driverJdbcVersion > 1) {
            cstmt = conn.prepareCall(callString, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        } else {
            cstmt = conn.prepareCall(callString);
        }
        return cstmt;
    }
    catch (SQLException sqle) {
      logger.error( "createCallableStatement :" + sqle.getMessage() ); 
      logger.error( "JDBCConnection.createCallableStatement :", sqle ); 
      return null;
    }
  }

  /** Create PreparedStatement from sql indicated by sql parameter. PreparedStatement differes from ordinary
    Statement by that you can use question marks in place of query parameters.
    @param sql SQL query with parameters
    @return prepared statement object */
  public PreparedStatement createPreparedStatement( String sql ) {
    try {
        PreparedStatement pstmt = null;
        if (this.driverJdbcVersion > 1) {
            pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY); 
        } else {
            pstmt = conn.prepareStatement(sql); 
        }
        return pstmt;
    }
    catch (SQLException sqle) {
      logger.error( "createPreparedStatement :" + sqle.getMessage() ); 
      logger.error( "JDBCConnection.createPreparedStatement :", sqle ); 
      return null;
    }
  }

  public PreparedStatement createPreparedStatementForUpdate( String sql ) {
      try {
          return conn.prepareStatement(sql);
      }
      catch (SQLException sqle) {
        logger.error( "createPreparedStatementForUpdate :" + sqle.getMessage() ); 
        logger.error( "JDBCConnection.createPreparedStatementForUpdate :", sqle ); 
        return null;
      }
  }

  /** Create Statement. Statement object then can be used to actually query database with SQL (executeQuery).
    @return statement object. */
  public Statement createStatement() {
    try {
        Statement stmt = null;
        if (this.driverJdbcVersion > 1) {
            stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY); 
        } else {
            stmt = conn.createStatement(); 
        }
        return stmt;
    }
    catch (SQLException sqle) {
      addError( "JDBCConnection.createStatement :" + sqle.getMessage() ); 
      logger.error( "JDBCConnection.createStatement :", sqle ); 
      return null;
    }
  }

  public void closeResultSet(ResultSet result) {
    try {
      if (result != null) result.close();
    }
    catch(SQLException sqle) {
      addError( "JDBCConnection.closeResultSet :" + sqle.getMessage() ); 
      logger.error( "JDBCConnection.closeResultSet :", sqle); 
    }
  }

  /** Free Statement object when it is not needed any more.
    @param cstmt callable statement object to free. */
  public void closeStatement(CallableStatement cstmt) {
    try {
      if (cstmt != null) cstmt.close();
    }
    catch(SQLException sqle) {
      addError( "JDBCConnection.closeStatement (CallableStatement) :" + sqle.getMessage() ); 
      logger.error( "JDBCConnection.closeStatement (CallableStatement) :", sqle ); 
    }
  }

  /** Free Statement object when it is not needed any more.
    @param stmt callable statement object to free. */
  public void closeStatement(Statement stmt) {
    try {
      if (stmt != null) stmt.close();
    }
    catch(SQLException sqle) {
      addError( "JDBCConnection.closeStatement (Statement) :" + sqle.getMessage() ); 
      logger.error( "JDBCConnection.closeStatement (Statement) :", sqle ); 
    }
  }

  public boolean isConnection ( Connection conn ) {
    if ( conn == null ) {
        getConnection();
    }
    if ( conn == null ) { return false; }
    else { return true; }
  }

    public String format( ReadOnlyControl control ) throws IllegalArgumentException {
        String result = null;
        if ( control != null ) {
            if ( control.getType() == ControlType.DATE ) {
                result = formatDate( control );
            } else if ( control.getType() == ControlType.INTEGER ) {
                result = formatNumber( control );
            } else if ( control.getType() == ControlType.FLOAT ) {
                result = formatNumber( control );
            } else if ( control.getType() == ControlType.BOOLEAN ) {
                result = formatBoolean( control );
            } else if ( (control.getType() == ControlType.TEXT)
                    || (control.getType() == ControlType.MEMO) ) {
                result = formatText( control );
            } else {
                throw new IllegalArgumentException( this.getClass().getName() + ".format() : Unsupported type => " + control.getType() );  
            }
        } else {
            logger.error( "JDBCConnection.format( ReadOnlyControl ) => parameter is null" ); 
            addError( "JDBCConnection.format( ReadOnlyControl ) => parameter is null" ); 
        }
        return result;
    }

    private String formatDate( ReadOnlyControl control ) throws IllegalArgumentException {
        String result = null;
        if ( control.getType() != ControlType.DATE ) {
            throw new IllegalArgumentException( this.getClass().getName() + ".formatDate() : Unsupported type" );  
        } else {
            java.util.Date value = (java.util.Date) control.getValue();
            if ( value != null ) {
                Format format = control.getDbFormat();
                if ( format == null ) {
                    format = dateFormat;
                }
                if ( format == null ) {
                    result = value.toString();
                } else {
                    result = format.format( value );
                }
            }
        }
        return result;
    }

    private String formatText( ReadOnlyControl control ) throws IllegalArgumentException {
        String result = null;
        if ( ! ( (control.getType() == ControlType.TEXT)
                || (control.getType() == ControlType.MEMO) ) ) {
            throw new IllegalArgumentException( this.getClass().getName() + ".formatText() : Unsupported type" );  
        } else {
            String value = (String) control.getValue();
            if ( value != null ) {
                result = value;
            }
        }
        return result;
    }

    private String formatBoolean( ReadOnlyControl control ) throws IllegalArgumentException {
        String result = null;
        if ( control.getType() != ControlType.BOOLEAN ) {
            throw new IllegalArgumentException( this.getClass().getName() + ".formatBoolean() : Unsupported type" );  
        } else {
            Boolean value = (Boolean) control.getValue();
            Format format = control.getDbFormat();
            if ( format == null ) {
                format = booleanFormat;
            }
            if ( format == null ) {
                result = value.toString();
            } else {
                result = format.format( value );
            }
        }
        return result;
    }

    private String formatNumber( ReadOnlyControl control ) throws IllegalArgumentException {
        String result = null;
        if ( ! ( (control.getType() == ControlType.INTEGER)
                || (control.getType() == ControlType.FLOAT) ) ) {
            throw new IllegalArgumentException( this.getClass().getName() + ".formatNumber() : Unsupported type" );  
        } else {
            Object value = control.getValue();
            if ( value != null ) {
                Format format = control.getDbFormat();
                if ( format == null ) {
                    result = value.toString();
                } else {
                    result = format.format( value );
                }
            }
        }
        return result;
    }

    public Object parse( String source, ReadOnlyControl control ) {
      Object result = null;
      try {
        result = parseString( source, control );
      } catch ( ParseException pe ) {
        String message = null;
        if ( control != null ) {
          message = this.getClass().getName() + ".parse(): Invalid " + control.getCaption() +" value format";  
        } else {
          message = this.getClass().getName() + ".parse(): parameter is null"; 
        }
        logger.error( message );
        addError( message );
      }
      return result;
    }

    public Object parseString( String source, ReadOnlyControl control )
            throws ParseException, IllegalArgumentException {
        Object result = null;
        if ( control != null ) {
            if ( control.getType() == ControlType.DATE ) {
                result = parseDate( source, control );
            }
            else if ( control.getType() == ControlType.INTEGER ) {
                result = parseNumber( source, control );
            }
            else if ( control.getType() == ControlType.FLOAT ) {
                result = parseNumber( source, control );
            }
            else if ( control.getType() == ControlType.BOOLEAN ) {
                 result = parseBoolean( source, control );
            }
            else if ( (control.getType() == ControlType.TEXT)
                    || (control.getType() == ControlType.MEMO) ) {
                result = source;
            } else {
                throw new IllegalArgumentException( this.getClass().getName() + ".format() : Unsupported type => " + control.getType() );  
            }
        } else {
            logger.error( "JDBCConnection.parse( ReadOnlyControl ) => parameter is null" ); 
            addError( "JDBCConnection.parse( ReadOnlyControl ) => parameter is null" ); 
        }
        return result;
    }

    private Object parseDate( String source, ReadOnlyControl control )
            throws ParseException, IllegalArgumentException {
        if ( source == null || source.length() == 0 ) return null;
        Object result = null;
        if ( control.getType() != ControlType.DATE ) {
            throw new IllegalArgumentException( this.getClass().getName() + ".parseDate() : Unsupported type =>" + control.getType() );
        } else {
            Format format = control.getDbFormat();
            if ( format == null ) {
                format = dateFormat;
            }
            if ( format == null ) {
                format = new SimpleDateFormat();
            }
            result = format.parseObject( source );
        }
        return result;
    }

    private Object parseNumber( String source, ReadOnlyControl control )
            throws ParseException, IllegalArgumentException {
        if ( source == null || source.length() == 0 ) return null;
        Object result = null;
        if ( ! ( (control.getType() == ControlType.INTEGER)
                || (control.getType() == ControlType.FLOAT) ) ) {
            throw new IllegalArgumentException( this.getClass().getName() + ".parseNumber() : Unsupported type" + control.getType() );  
        } else {
            Format format = control.getDbFormat();
            if ( format == null ) {
                format = new DecimalFormat();
            }
            result = format.parseObject( source );
        }
        return result;
    }

    private Object parseBoolean( String source, ReadOnlyControl control )
            throws ParseException, IllegalArgumentException {
        Object result = null;
        if ( control.getType() != ControlType.BOOLEAN) {
            throw new IllegalArgumentException( this.getClass().getName() + ".parseBoolean() : Unsupported type" + control.getType() );  
        } else {
            Format format = control.getDbFormat();
            if ( format == null ) {
                format = booleanFormat;
            }
            if ( format == null ) {
                format = new BooleanFormat();
            }
            result = format.parseObject( source );
        }
        return result;
    }

    public String format( Object value, Format format ) throws IllegalArgumentException {
        String result = null;
        if ( value != null ) {
			if ( value instanceof LongTextField ) {
				((LongTextField) value).setFormat( format );
				result = format( (ReadOnlyField) value );
			} else if ( value instanceof TextField ) {
				((TextField) value).setFormat( format );
				result = format( (ReadOnlyField) value );
            } else if ( value instanceof LongField ) {
                ((LongField) value).setFormat( format );
                result = format( (ReadOnlyField) value );
            } else if ( value instanceof DoubleField ) {
                ((DoubleField) value).setFormat( format );
                result = format( (ReadOnlyField) value );
            } else if ( value instanceof BooleanField ) {
                ((BooleanField) value).setFormat( format );
                result = format( (ReadOnlyField) value );
            } else if ( value instanceof DateField ) {
                ((DateField) value).setFormat( format );
                result = format( (ReadOnlyField) value );
            } else if ( value instanceof CachedColumn ) {
                CachedColumn c = (CachedColumn) value;
                if (c.getType()==ControlType.INTEGER) {
                    LongField field = new LongField();
                    field.setValue( c.getValue() );
                    field.setFormat( format );
                    result = format( field );
                } else if (c.getType()==ControlType.FLOAT) {
                    DoubleField field = new DoubleField();
                    field.setValue( c.getValue() );
                    field.setFormat( format );
                    result = format( field );
                } else if (c.getType()==ControlType.BOOLEAN) {
                    BooleanField field = new BooleanField();
                    field.setValue( c.getValue() );
                    field.setFormat( format );
                    result = format( field );
                } else if (c.getType()==ControlType.DATE) {
                    DateField field = new DateField();
                    field.setValue( c.getValue() );
                    field.setFormat( format );
                    result = format( field );
				} else if (c.getType()==ControlType.MEMO) {
					LongTextField field = new LongTextField();
					field.setValue( c.getValue() );
					field.setFormat( format );
					result = format( field );
                } else {
                    TextField field = new TextField();
                    field.setValue( c.getValue() );
                    field.setFormat( format );
                    result = format( field );
                }
            } else if ( value instanceof Long ) {
                LongField field = new LongField();
                field.setValue( (Long) value );
                field.setFormat( format );
                result = format( field );
            } else if ( value instanceof Double ) {
                DoubleField field = new DoubleField();
                field.setValue( (Double) value );
                field.setFormat( format );
                result = format( field );
            } else if ( value instanceof java.util.Date ) {
                DateField field = new DateField();
                field.setValue( (java.util.Date) value );
                field.setFormat( format );
                result = format( field );
            } else if ( value instanceof Boolean ) {
                BooleanField field = new BooleanField();
                field.setValue( (Boolean) value );
                field.setFormat( format );
                result = format( field );
            } else if ( value instanceof String ) {
                TextField field = new TextField();
                field.setValue( (String) value );
                field.setFormat( format );
                result = format( field );
            } else {
                throw new IllegalArgumentException( this.getClass().getName() +
                        ".format() : Unsupported type " + value.getClass().getName() );
            }
        }
        return result;
    }

    public String format( ReadOnlyField field ) throws IllegalArgumentException {
        String result = null;
        if ( field != null ) {
            if ( field instanceof DateField ) {
                result = formatDate( field );
            } else if ( field instanceof LongField ) {
                result = formatLong( field );
            } else if ( field instanceof DoubleField ) {
                result = formatDouble( field );
            } else if ( field instanceof BooleanField ) {
                result = formatBoolean( field );
            } else if ( field instanceof TextField ) {
                result = formatText( field );
			} else if ( field instanceof LongTextField ) {
				result = formatText( field );
            } else {
                throw new IllegalArgumentException( this.getClass().getName() + ".format() : Unsupported type" );
            }
        } else {
            logger.error( "Parameter is null while calling format( ReadOnlyField )" ); 
            addError( "Parameter is null while calling format( ReadOnlyField )" ); 
        }
        return result;
    }

    private String formatDate( ReadOnlyField field ) throws IllegalArgumentException {
        String result = null;
        if ( ! (field instanceof DateField) ) {
            throw new IllegalArgumentException( this.getClass().getName() + ".formatDate() : Unsupported type" );  
        } else {
            java.util.Date value = (java.util.Date) field.getObjectValue();
            if ( value != null ) {
                Format format = field.getFormat();
                if ( format == null ) {
                    format = dateFormat;
                }
                if ( format == null ) {
                    result = value.toString();
                } else {
                    result = format.format( value );
                }
            }
        }
        return result;
    }

    private String formatText( ReadOnlyField field ) throws IllegalArgumentException {
        String result = null;
        if ( ! ( field instanceof TextField || field instanceof LongTextField) ) {
            throw new IllegalArgumentException( this.getClass().getName() + ".formatText() : Unsupported type" );  
        } else {
            String value = (String) field.getObjectValue();
            if ( value != null ) {
                result = value;
            }
        }
        return result;
    }

    private String formatBoolean( ReadOnlyField field ) throws IllegalArgumentException {
        String result = null;
        if ( ! ( field instanceof BooleanField ) ) {
            throw new IllegalArgumentException( this.getClass().getName() + ".formatBoolean() : Unsupported type" );  
        } else {
            Boolean value = (Boolean) field.getObjectValue();
            Format format = field.getFormat();
            if ( format == null ) {
                format = booleanFormat;
            }
            if ( format == null ) {
                result = ( value == null ) ? "NULL" : value.toString();
            } else {
                result = format.format( value );
            }
        }
        return result;
    }

    private String formatDouble( ReadOnlyField field ) throws IllegalArgumentException {
        String result = null;
        if ( ! ( field instanceof DoubleField ) ) {
            throw new IllegalArgumentException( this.getClass().getName() + ".formatNumber() : Unsupported type" );  
        } else {
            Double value = (Double) field.getObjectValue();
            if ( value != null ) {
                Format format = field.getFormat();
                if ( format == null ) {
                    result = value.toString();
                } else {
                    result = format.format( value );
                }
            }
        }
        return result;
    }

    private String formatLong( ReadOnlyField field ) throws IllegalArgumentException {
        String result = null;
        if ( ! ( field instanceof LongField ) ) {
            throw new IllegalArgumentException( this.getClass().getName() + ".formatNumber() : Unsupported type" );  
        } else {
            Long value = (Long) field.getObjectValue();
            if ( value != null ) {
                Format format = field.getFormat();
                if ( format == null ) {
                    result = value.toString();
                } else {
                    result = format.format( value );
                }
            }
        }
        return result;
    }

    public Object parse( String source, ReadOnlyField field ) {
      Object result = null;
      try {
        result = parseString( source, field );
      } catch ( ParseException pe ) {
        String message = null;
        if ( field != null ) {
          message = this.getClass().getName() + ".parse(): Invalid "+field.getName()+" value format "; 
        } else {
          message = this.getClass().getName() + ".parse(): parameter is null"; 
        }
        logger.error( message );
        addError( message );
      }
      return result;
    }

    public Object parse( Object source, ReadOnlyField field ) {
      Object result = null;
      try {
        result = parseObject( source, field );
      } catch ( ParseException pe ) {
        String message = null;
        if ( field != null ) {
          message = this.getClass().getName() + ".parse(): Invalid format of value " + field.getName(); 
        } else {
          message = this.getClass().getName() + ".parse(): parameter is null"; 
        }
        logger.error( message );
        addError( message );
      }
      return result;
    }

    public Object parseString( String source, ReadOnlyField field )
            throws ParseException, IllegalArgumentException {
        Object result = null;
        if ( field != null ) {
            if ( field instanceof DateField ) {
                result = parseDate( source, field );
            } else if ( field instanceof LongField
                    || field instanceof DoubleField  ) {
                result = parseNumber( source, field );
            } else if ( field instanceof BooleanField ) {
                 result = parseBoolean( source, field );
            } else if ( field instanceof LongTextField ) {
                result = source;
			      } else if ( field instanceof TextField ) {
				        result = source;
            } else {
                throw new IllegalArgumentException( this.getClass().getName() + ".parseString() : Unsupported type" + (field==null? "" : ": " + field.getClass().getName()) );  
            }
        } else {
            logger.error( "Parameter is null while calling parseString( ReadOnlyField )" ); 
            addError( "Parameter is null while calling parseString( ReadOnlyField )" ); 
        }
        return result;
    }

    public Object parseObject( Object source, ReadOnlyField field )
            throws ParseException, IllegalArgumentException {
        Object result = null;
        if ( field != null ) {
            if ( field instanceof DateField ) {
                result = parseDate( source, field );
            } else if ( field instanceof DoubleField
                    || field instanceof LongField ) {
                result = parseNumber( source, field );
            } else if ( field instanceof BooleanField ) {
                 result = parseBoolean( source, field );
            } else if (field instanceof TextField || field instanceof LongTextField) {
                if (source != null) {
                    result = source.toString();
                }
            } else {
                throw new IllegalArgumentException( this.getClass().getName() + ".parseString() : Unsupported type" );  
            }
        } else {
            logger.error( "Parameter is null while calling parseObject( ReadOnlyField )" ); 
            addError( "Parameter is null while calling parseObject( ReadOnlyField )" ); 
        }
        return result;
    }

    private Object parseDate( String source, ReadOnlyField field )
            throws ParseException, IllegalArgumentException {
        if ( source == null || source.length() == 0 ) return null;
        Object result = null;
        if ( ! ( field instanceof DateField ) ) {
            throw new IllegalArgumentException( this.getClass().getName() + ".parseDate() : Unsupported type " );  
        } else {
            String fmtPattern = field.getDbFormatPattern() == null ? dateFormatPattern : field.getDbFormatPattern();
            Format format = ccsLocale.getDateFormat(fmtPattern);
            if ( format == null ) {
                format = dateFormat;
            }
            if ( format == null ) {
                format = new SimpleDateFormat();
            }
            result = format.parseObject( source );
        }
        return result;
    }

    private Object parseDate( Object source, ReadOnlyField field )
            throws ParseException, IllegalArgumentException {
        if ( source == null ) return null;
        Object result = null;
        if ( ! ( field instanceof DateField ) ) {
            throw new IllegalArgumentException( this.getClass().getName() + ".parseDate() : Unsupported type " );  
        } else {
            if ( source instanceof String ) {
                result = parseDate( (String) source, field );
            }
            else {
                if ( source instanceof java.util.Date ) {
                    result = source;
                }
                else {
                    throw new IllegalArgumentException(
                            this.getClass().getName() +
                            ".parseDate( Object, ReadOnlyField ) : Unsupported source type " +
                            source.getClass().getName() );
                }
            }
        }
        return result;
    }

    private Object parseNumber( String source, ReadOnlyField field )
            throws ParseException, IllegalArgumentException {
        if ( source == null || source.length() == 0 ) return null;
        Object result = null;
        if ( ! ( field instanceof LongField
                || field instanceof DoubleField  ) ) {
            throw new IllegalArgumentException( this.getClass().getName() + ".parseNumber() : Unsupported type" );  
        } else {
            Format format = null;
            if ( field instanceof LongField ) {
                format = ccsLocale.getLongFormat(field.getDbFormatPattern());
            } else {
                format = ccsLocale.getDoubleFormat(field.getDbFormatPattern());
            }
            if ( format == null ) {
                format = new DecimalFormat();
            }
            result = format.parseObject( source );
        }
        return result;
    }

    private Object parseNumber( Object source, ReadOnlyField field )
            throws ParseException, IllegalArgumentException {
        if ( source == null ) return null;
        Object result = null;
        if ( ! ( field instanceof LongField || field instanceof DoubleField ) ) {
            throw new IllegalArgumentException( this.getClass().getName() +
                    ".parseDate() : Unsupported type " );  
        } else {
            if ( source instanceof String ) {
                result = parseNumber( (String) source, field );
            }
            else {
                if ( source instanceof java.lang.Number ) {
                    result = source;
                }
                else {
                    throw new IllegalArgumentException(
                            this.getClass().getName() +
                            ".parseDate( Object, ReadOnlyField ) : Unsupported source type " +  
                            source.getClass().getName() );
                }
            }
        }
        return result;
    }

    private Object parseBoolean( String source, ReadOnlyField field )
            throws ParseException, IllegalArgumentException {
        Object result = null;
        if ( ! ( field instanceof BooleanField ) ) {
            throw new IllegalArgumentException( this.getClass().getName() + ".parseBoolean() : Unsupported type" );  
        } else {
            String fmtPattern = field.getDbFormatPattern() == null ? booleanFormatPattern : field.getDbFormatPattern();
            Format format = ccsLocale.getBooleanFormat(fmtPattern);
            if ( format == null ) {
                format = booleanFormat;
            }
            if ( format == null ) {
                format = new BooleanFormat();
            }
            result = format.parseObject( source );
        }
        return result;
    }

    private Object parseBoolean( Object source, ReadOnlyField field )
            throws ParseException, IllegalArgumentException {
        if ( source == null ) return null;
        Object result = null;
        if ( ! ( field instanceof BooleanField ) ) {
            throw new IllegalArgumentException( this.getClass().getName() + ".parseBoolean() : Unsupported type" );  
        } else {
        	if (source instanceof Boolean) {
        		result = source;
        	} else {
				result = parseBoolean( source.toString(), field );
        	}
        }
        return result;
    }


}
//End JDBCConnection

