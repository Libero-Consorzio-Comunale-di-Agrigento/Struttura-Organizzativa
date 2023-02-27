//JDBCConnectionFactory @0-B647C33A
package com.codecharge.db;

import java.util.*;
import com.codecharge.*;
import com.codecharge.util.*;

/** This factory class get access to different JDBCConnection objects.
 *  Current implementation returns pooled connection or DataSource connection.
 */
public class JDBCConnectionFactory {

    static public JDBCConnection getJdbcConnection( String connectionName ) {
        return getJDBCConnection(connectionName,true);
    }

    static public JDBCConnection getJdbcConnection( String connectionName, boolean initConnection) {
        return getJDBCConnection(connectionName,initConnection);
    }

    /** 
     * Create new JDBCConnection by connection name.
     * @param connectionName the name of connection
     * @return the JDBCConnection of the given name or null if it is impossible
     */
    static public JDBCConnection getJDBCConnection( String connectionName ) {
        return getJDBCConnection(connectionName,true);
    }

    static public JDBCConnection getJDBCConnection( String connectionName, boolean initConnection ) {
        JDBCConnection conn = null;
        if ( StringUtils.isEmpty( connectionName ) ) {
            CCLogger.getInstance().error("JDBCConnectionFactory.getJDBCConnection: connectionName is empty");
        } else {

            try {
                Class.forName("com.codecharge.db.DataSourceJDBCConnection");
                conn = new com.codecharge.db.DataSourceJDBCConnection( connectionName, initConnection );
            } catch ( ClassNotFoundException cnfe ) {

                conn = new com.codecharge.db.PoolJDBCConnection( connectionName, initConnection );

            }

        }
        Properties siteProps = (Properties) ContextStorage.getInstance().getAttribute( Names.SITE_PROPERTIES_KEY );
        if ( conn != null && siteProps != null ) {
            conn.setLeftDateDelimiter( siteProps.getProperty( connectionName + ".dateLeftDelim" ) );
            conn.setRightDateDelimiter( siteProps.getProperty( connectionName + ".dateRightDelim" ) );
        }
        return conn;
    }

}

//End JDBCConnectionFactory

