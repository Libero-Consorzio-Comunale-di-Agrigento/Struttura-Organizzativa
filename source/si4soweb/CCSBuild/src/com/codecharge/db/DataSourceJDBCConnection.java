//DataSourceJDBCConnection class @0-02E2EED2
package com.codecharge.db;

import com.codecharge.*;
import com.codecharge.util.*;
import java.sql.*;
import java.util.Properties;
import javax.sql.*;
import javax.naming.*;  

public class DataSourceJDBCConnection extends JDBCConnection {

  public DataSourceJDBCConnection(String name) {
    this(name,true);
  }

  public DataSourceJDBCConnection(String name, boolean initConnection) {
    super(name,initConnection);
  }

  public void getConnection() {
    if ( this.conn == null ) {
        try {
          Properties siteProps = (Properties) ContextStorage.getInstance().getAttribute( Names.SITE_PROPERTIES_KEY );
          String jndiName = siteProps.getProperty( this.poolName +".url" );
          String user = siteProps.getProperty( this.poolName + ".user" );
          String password = siteProps.getProperty( this.poolName + ".password" );
          Context ctx = new InitialContext();
          DataSource ds = (DataSource)ctx.lookup( jndiName );
          if (StringUtils.isEmpty(user)) {
              this.conn = ds.getConnection();
          } else {
              this.conn = ds.getConnection( user, password );
          }
          if ( this.conn == null ) {
              throw new RuntimeException( "Unable create connection '" + this.poolName + "' to database."  );
          }
        } 
        catch (NamingException ne) {
          addError( "Naming Exception: " + ne.getMessage() );
          logger.error( "Naming Exception: ", ne );
        } 
        catch (SQLException sqle) {
          addError( "SQL Exception: " + sqle.getMessage() );
          logger.error( "SQL Exception: ", sqle );
        }
    }
  }

  public void closeConnection() {
    try {
      if (this.conn != null && ( ! this.conn.isClosed()) ) conn.close();
    } 
    catch (SQLException sqle) {
      addError( "SQL Exception: " + sqle.getMessage() );
      logger.error( "SQL Exception: ", sqle );
    } finally {
        this.conn = null;
    }
  }
}
//End DataSourceJDBCConnection class

