//DBTools class @0-94545029
package com.codecharge.db;

import java.util.*;
import com.codecharge.util.*;

public class DBTools {

    public static Object dLookUp( String expression, String domain, String criteria, String connectionName ) {
        Object result = null;
        if ( ! StringUtils.isEmpty(expression) ) {
            JDBCConnection connection = JDBCConnectionFactory.getJDBCConnection(connectionName);
            StringBuffer query = new StringBuffer("SELECT ").append(expression);
            if ( ! StringUtils.isEmpty(domain) ) {
                query.append(" FROM ").append(domain);
            }
            if ( ! StringUtils.isEmpty(criteria) ) {
                query.append(" WHERE ").append(criteria);
            }
            Enumeration rows = connection.getRows(query.toString());
            connection.closeConnection();
            if ( rows != null && rows.hasMoreElements() ) {
                DbRow row = (DbRow) rows.nextElement();
                result = row.get(new Integer(0));
            }
        }
        return result;
    }
    
    public static Boolean convertToBoolean(Object value, String connectionName, CCSLocale ccsLocale) {
        Boolean result = null;
        if ( value != null ) {
            JDBCConnection connection = JDBCConnectionFactory.getJDBCConnection(connectionName,false);
            if ( ccsLocale != null ) {
                connection.setLocale(ccsLocale.getLocale());
            } else {
                connection.setLocale(Locale.getDefault());
            }
            result = (Boolean) connection.parse(value,new BooleanField());
        }
        return result;
    }
    
    public static Date convertToDate(Object value, String connectionName, CCSLocale ccsLocale) {
        Date result = null;
        if ( value != null ) {
            JDBCConnection connection = JDBCConnectionFactory.getJDBCConnection(connectionName,false);
            if ( ccsLocale != null ) {
                connection.setLocale(ccsLocale.getLocale());
            } else {
                connection.setLocale(Locale.getDefault());
            }
            result = (Date) connection.parse(value,new DateField());
        }
        return result;
    }
    
    public static Long convertToLong(Object value, String connectionName, CCSLocale ccsLocale) {
        Long result = null;
        if ( value != null ) {
            JDBCConnection connection = JDBCConnectionFactory.getJDBCConnection(connectionName,false);
            if ( ccsLocale != null ) {
                connection.setLocale(ccsLocale.getLocale());
            } else {
                connection.setLocale(Locale.getDefault());
            }
            result = new Long(((Number) connection.parse(value,new LongField())).longValue());
        }
        return result;
    }
    
    public static Double convertToDouble(Object value, String connectionName, CCSLocale ccsLocale) {
        Double result = null;
        if ( value != null ) {
            JDBCConnection connection = JDBCConnectionFactory.getJDBCConnection(connectionName,false);
            if ( ccsLocale != null ) {
                connection.setLocale(ccsLocale.getLocale());
            } else {
                connection.setLocale(Locale.getDefault());
            }
            result = new Double(((Number) connection.parse(value,new DoubleField())).doubleValue());
        }
        return result;
    }
    
    public static String convertToString(Object value, String connectionName, CCSLocale ccsLocale) {
        String result = null;
        if ( value != null ) {
            JDBCConnection connection = JDBCConnectionFactory.getJDBCConnection(connectionName,false);
            if ( ccsLocale != null ) {
                connection.setLocale(ccsLocale.getLocale());
            } else {
                connection.setLocale(Locale.getDefault());
            }
            result = (String) connection.parse(value,new TextField());
        }
        return result;
    }
    
    /**
     * Execute SQL-query for INSERT/UPDATE/DELETE query.
     * @param sql is a String object contains SQL-query
     * @param connectionName is a name of DB connection
     * @return either the row count for INSERT, UPDATE or DELETE statements, 
     * or 0 for SQL statements that return nothing, or -1 if parameter is null
     */
    public static void executeUpdate( String sql, String connectionName ) {
        if ( ! StringUtils.isEmpty(sql) ) {
            JDBCConnection connection = JDBCConnectionFactory.getJDBCConnection(connectionName);
            connection.executeUpdate(sql);
            connection.closeConnection();
        }
    }
    
    /**
     * Returns collection ( Enumeration for JDK 1.1 ) of Hashtables representing
     * records from the ResultSet
     * 
     * @param sql is a static SQL <code>SELECT</code> statement
     * @param connectionName is a name of DB connection
     * @return a <code>Enumeration</code> object that contains the data produced by the
     * given query; 
     */
    public static Enumeration getRows( String sql, String connectionName ) {
        Enumeration rows = null;
        if ( ! StringUtils.isEmpty(sql) ) {
            JDBCConnection connection = JDBCConnectionFactory.getJDBCConnection(connectionName);
            rows = connection.getRows(sql);
            connection.closeConnection();
        }
        return rows;
    }
    
    /**
     * Returns collection ( Enumeration for JDK 1.1 ) of Hashtables representing
     * records from the ResultSet
     * 
     * @param sql is a static SQL <code>SELECT</code> statement
     * @param start is a position for first reading record
     * @param max is a number record which will be reading into collection
     * @param connectionName is a name of DB connection
     * @return a <code>Enumeration</code> object that contains the data produced by the
     * given query; 
     */
    public static Enumeration getRows( String sql, int start, int max, String connectionName ) {
        Enumeration rows = null;
        if ( ! StringUtils.isEmpty(sql) ) {
            JDBCConnection connection = JDBCConnectionFactory.getJDBCConnection(connectionName);
            rows = connection.getRows(sql, start, max);
            connection.closeConnection();
        }
        return rows;
    }
    
    /**
     * Get one row from SQL query result.
     * 
     * @param sql SQL query string
     * @param connectionName is a name of DB connection
     * @return Hashtable representation of first recordset or null if recordset is empty.
     */
    public static DbRow getOneRow(String sql, String connectionName) {
        DbRow row = null;
        if ( ! StringUtils.isEmpty(sql) ) {
            JDBCConnection connection = JDBCConnectionFactory.getJDBCConnection(connectionName);
            row = connection.getOneRow(sql);
            connection.closeConnection();
        }
        return row;
    }

    public static long getLong(String sql, String connectionName) {
        long result = Long.MIN_VALUE;
        if ( ! StringUtils.isEmpty(sql) ) {
            JDBCConnection connection = JDBCConnectionFactory.getJDBCConnection(connectionName);
            result = connection.getLong(sql);
            connection.closeConnection();
        }
        return result;
    }
    
    public static String toSql(String value, int type, String connectionName) {
        if (StringUtils.isEmpty(value)) return "";
        JDBCConnection connection = JDBCConnectionFactory.getJDBCConnection(connectionName, false);
        return connection.toSql(value, type);
    }

    public static String toSql(boolean value, String connectionName) {
        return JDBCConnectionFactory.getJDBCConnection(connectionName, false).toSql(value);
    }

    public static String toSql(Boolean value, String connectionName) {
        return JDBCConnectionFactory.getJDBCConnection(connectionName, false).toSql(value);
    }

    public static String toSql(java.util.Date value, String connectionName) {
        return JDBCConnectionFactory.getJDBCConnection(connectionName, false).toSql(value);
    }

}

//End DBTools class

