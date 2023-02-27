//SqlCommand class @0-62C1B9C2
package com.codecharge.db;

import java.text.*;
import java.util.*;
import java.sql.*;
import com.codecharge.util.*;
import com.codecharge.db.*;
import com.codecharge.*;
import com.codecharge.components.*;

public class SqlCommand extends Command {

    private String sqlString;
    
    public SqlCommand(){}
    
    public SqlCommand( JDBCConnection conn ) {
        super( conn );
    }

    public void addParameter( Parameter param, Format format ) {
        if ( param != null ) {
            parameters.add( param );
            formats.add ( format );
        }
    }
    
    public void addParameter( SqlParameter param ) {
        if ( param != null ) {
            FieldOperation oper = param.getOperation();
            ControlType type = param.getType();
            if ( (type == ControlType.TEXT || type == ControlType.MEMO) && oper != null ) {
                try {
                    param.setValue( oper.getPrefix() + ((String) param.getValue()) + oper.getSuffix() );
                } catch ( java.text.ParseException ignore ){
                }
            }
            parameters.add( param );
            formats.add ( null );
        }
    }
    
    public void addRawParameter( SqlParameter param ) {
        addParameter( param );
    }
    
    public Enumeration getRows( int start, int rows ) {
        Enumeration result = null;
        PreparedStatement pstmt = prepareCommand();
        ResultSet rs = null;
        if ( pstmt == null ) 
            return result;
        try {    
            rs = pstmt.executeQuery();    
            result = conn.getRows( rs, start, rows );
            next = conn.isNext();
            rs.close();
            pstmt.close();
        } catch ( SQLException sqle ) {
            catchException( sqle );
            return result;
        }
        return result;
    }

    public Enumeration getRows() {
        Enumeration result = null;
        PreparedStatement pstmt = prepareCommand();
        ResultSet rs = null;
        if ( pstmt == null ) 
            return result;
        try {    
            rs = pstmt.executeQuery();    
            if ( fetchSize > 0 ) {
                result = conn.getRows( rs, startPos, fetchSize );
            } else {
                result = conn.getRows( rs );
            }
            next = conn.isNext();
            rs.close();
            pstmt.close();
        } catch ( SQLException sqle ) {
            catchException( sqle );
            return result;
        }
        return result;
    }

    public DbRow getOneRow() {
        DbRow result = null;
        PreparedStatement pstmt = prepareCommand();
        ResultSet rs = null;
        if ( pstmt == null ) 
            return result;
        try {    
            rs = pstmt.executeQuery();    
            result = conn.getOneRow( rs );
            rs.close();
            pstmt.close();
        } catch ( SQLException sqle ) {
            catchException( sqle );
            return result;
        }
        return result;
    }
    
    public int count() {
        int result = 0;
        PreparedStatement pstmt = prepareCommand();
        ResultSet rs = null;
        if ( pstmt == null ) 
            return result;
        try {    
            rs = pstmt.executeQuery();    
            if ( rs.next() )
                result = rs.getInt(1);
            rs.close();
            pstmt.close();
        } catch ( SQLException sqle ) {
            catchException( sqle );
            return result;
        }
        return result;
    }

    /**
      Check if query returns something. Number of records.
      @return 0 if query returns no records and 1 otherwise.
    **/
    public int nrecords() {
      int result = 0;
      PreparedStatement pstmt = prepareCommand();
      ResultSet rs = null;
      if (pstmt == null) return result;
      try {
        rs = pstmt.executeQuery();
        if (rs.next()) result = 1;
        rs.close();
        pstmt.close();
      } catch (SQLException sqle) {
        catchException(sqle);
        return result;
      }
      return result;
    }

    public int executeUpdate() {
        int result = 0;
        PreparedStatement pstmt = prepareCommand();
        if ( pstmt == null ) 
            return result;
        try {    
            result = pstmt.executeUpdate();    
        } catch ( SQLException sqle ) {
            catchException( sqle );
            return result;
        }
        return result;
    }
    
    /**
     * Returns true if collection of parameters doesn't contain null parameters
     */
    public boolean isSetAllParams() {
        boolean result = true;
        if ( ! (parameters == null || parameters.isEmpty()) ) {
            Iterator params = parameters.iterator();
            while ( params.hasNext() ) {
                Parameter param = (Parameter) params.next();
                if ( param == null ) {
                    result = false;
                }
            }
        }
        return result;
    }
    
    private PreparedStatement prepareCommand() {
        PreparedStatement pstmt = null;
        sqlString = sql;
        sqlString += StringUtils.isEmpty(where) ? "" : " WHERE "+where;
        sqlString += StringUtils.isEmpty(order) ? "" : " ORDER BY "+order;
        if ( conn == null ) {
        } else if ( StringUtils.isEmpty( sqlString ) ) {
        } else {
            
            rebuildSql();
            if ( (pstmt = conn.createPreparedStatement( sqlString )) == null ) {
                return pstmt;
            }
            if ( ! (parameters == null || parameters.isEmpty()) ) {
                Format dateFormat = conn.getDateFormat();
                Format booleanFormat = conn.getBooleanFormat();
                Iterator params = parameters.iterator();
                Iterator formatParams = formats.iterator();
                int countParams = 1;
                boolean applyFormat = false;
                ControlType type = null;
                while ( params.hasNext() ) {
                    applyFormat = false;
                    type = null;
                    Parameter param = (Parameter) params.next();

                    Format format = (Format) formatParams.next();
                    if ( format == null ) {
                        format = param.getDbFormat();
                    }
                    Object value = null;
                    if ( param != null ) {
                        value = param.getObjectValue();
                        if ( param instanceof Field ) {
//                          format = ((Field) param).getFormat();
                        } else if ( param instanceof Control ) {
//                          format = ((Control) param).getDbFormat();
                          type = ((Control) param).getType();
                        } else if ( param instanceof SqlParameter ) {
//                          format = ((SqlParameter) param).getDbFormat();
                          type = ((SqlParameter) param).getType();
                        }
                        if ( param instanceof DateField ) {
                          if ( format != null || dateFormat != null ) {
                            applyFormat = true;
                            if ( format == null ) {
                              format = dateFormat;
                            }
                          }
                        } else if ( param instanceof BooleanField ) {
                          if ( format != null || booleanFormat != null ) {
                            applyFormat = true;
                            if ( format == null ) {
                              format = booleanFormat;
                            }
                          }
                        } else if ( type != null && type == ControlType.DATE ) {
                          if ( format != null || dateFormat != null ) {
                            applyFormat = true;
                            if ( format == null ) {
                              format = dateFormat;
                            }
                          }
                        } else if ( type != null && type == ControlType.BOOLEAN ) {
                          if ( format != null || booleanFormat != null ) {
                            applyFormat = true;
                            if ( format == null ) {
                              format = booleanFormat;
                            }
                          }
                        }
                        if ( ! (applyFormat && (param instanceof BooleanField || type == ControlType.BOOLEAN)) ) {
                            value = jdbcOdbcWorkaround( param, value );
                            if ( value != null && applyFormat ) {
                              value = format.format( value );
                            }
                            if ( param instanceof TextField || param instanceof LongTextField || type == ControlType.TEXT || type == ControlType.MEMO ) {
                              if ( value instanceof String && StringUtils.isEmpty( (String) value ) ) {
                                value = null;
                              }
                            }
                            try {    
                                if ( value != null ) {
                                  if ( value instanceof java.util.Date ) {
                                    pstmt.setObject( countParams, new java.sql.Date( ((java.util.Date) value).getTime() ));
                                  } else if ( param instanceof TextField || type == ControlType.TEXT || type == ControlType.MEMO) {
                                    pstmt.setObject( countParams, value, java.sql.Types.LONGVARCHAR );
                                  } else {
                                    pstmt.setObject( countParams, value );
                                  }
                                } else if ( param instanceof TextField || type == ControlType.TEXT || type == ControlType.MEMO) {
                                  pstmt.setNull( countParams, java.sql.Types.LONGVARCHAR );
                                } else if ( param instanceof DoubleField || type == ControlType.FLOAT) {
                                  pstmt.setNull( countParams, java.sql.Types.REAL );
                                } else if ( param instanceof LongField || type == ControlType.INTEGER) {
                                  pstmt.setNull( countParams, java.sql.Types.INTEGER );
                                } else if ( param instanceof DateField || type == ControlType.DATE) {
                                  pstmt.setNull( countParams, java.sql.Types.DATE );
                                } else if ( param instanceof BooleanField || type == ControlType.BOOLEAN) {
                                  pstmt.setNull( countParams, java.sql.Types.BIT );
                                }
                            } catch ( SQLException sqle ) {
                                catchException( sqle );
                                return null;
                            }
                        }
                    }
                    countParams++;
                }
            }
        }
        return pstmt;
    }

    private void rebuildSql() {
        if ( ! (parameters == null || parameters.isEmpty()) ) {
            Format booleanFormat = conn.getBooleanFormat();
            Iterator params = parameters.iterator();
            Iterator formatParams = formats.iterator();
            int countParams = 1;
            boolean applyFormat = false;
            ControlType type = null;
            while ( params.hasNext() ) {
                applyFormat = false;
                type = null;
                Parameter param = (Parameter) params.next();

                Format format = (Format) formatParams.next();
                if ( format == null ) {
                    format = param.getDbFormat();
                }
                Object value = null;
                if ( param != null ) {
                    value = param.getObjectValue();
                    if ( param instanceof Control ) {
                        type = ((Control) param).getType();
                    } else if ( param instanceof SqlParameter ) {
                        type = ((SqlParameter) param).getType();
                    }
                    if ( param instanceof BooleanField || type == ControlType.BOOLEAN ) {
                        if ( format != null || booleanFormat != null ) {
                            applyFormat = true;
                            if ( format == null ) {
                                format = booleanFormat;
                            }
                        }
                        if ( value != null && applyFormat ) {
                            value = format.format( value );
                            boolean isQuot = true;
                            try {
                                double ignore = Double.parseDouble( (String) value );
                                isQuot = false;
                            } catch ( NumberFormatException nfe ) {
                                if ( "true".equalsIgnoreCase( (String) value ) || "false".equalsIgnoreCase( (String) value ) ) {
                                    isQuot = false;
                                }
                            }
                            value = conn.toSql( (String) value, JDBCConnection.BOOLEAN );
                            if ( isQuot ) {
                              value = "'" + value + "'";
                            }
                            int posParam = -1;
                            for ( int i = 0; i < countParams; i++ ) {
                                if ( posParam > -1 ) {
                                    posParam = sqlString.indexOf( '?', posParam + 1 );
                                } else {
                                    posParam = sqlString.indexOf( '?' );
                                }
                                if ( posParam == sqlString.length() && (i < countParams - 1) ) {
                                    posParam = -1;
                                    break;
                                }
                            }
                            if ( posParam > -1 ) {
                                sqlString = sqlString.substring( 0, posParam ) + value + sqlString.substring( posParam + 1 );
                            }
                        }
                    }

                }
                countParams++;
            }
        }
    }

    public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append("SQLCommand sql='"+sql+"'\n");
        sb.append("         where='"+where+"'\n");
        sb.append("         order='"+order+"'\n");
        sb.append("      startPos='"+startPos+"'\n");
        sb.append("     fetchSize='"+fetchSize+"'\n");
        sb.append("    connection='"+conn.getPoolName()+"'\n");
        sb.append("Parameters:");
        if ( parameters == null || parameters.isEmpty() ) {
            sb.append("none\n");
        } else {
            sb.append("\n");
            Iterator params = parameters.iterator();
            int countParam = 1;
            while ( params.hasNext() ) {
                sb.append( "param" );
                sb.append( countParam++ );
                Parameter param = (Parameter) params.next();
                if ( param == null ) {
                  sb.append( " : parameter is null\n" );
                } else {
                  Object value = param.getObjectValue();
                  if ( value == null ) {
                    sb.append( " : value is null\n" );
                  } else {
                    sb.append( " : " + value.toString() + " type: " + value.getClass().getName() + "\n" );
                  }
                }
            }
        }
        return sb.toString();
    }

    public Object jdbcOdbcWorkaround( Parameter param, Object value ) {
        Object val = value;
        if ( param == null || param.getObjectValue() == null ) return val;
        ControlType type = null;
        if ( param instanceof Control) type = ((Control) param).getType();
        if ( param instanceof SqlParameter) type = ((SqlParameter) param).getType();
        if ( param instanceof LongField || type == ControlType.INTEGER ) {
            String pool = conn.getPoolName();
            Properties props = (Properties) ContextStorage.getInstance().getAttribute(Names.SITE_PROPERTIES_KEY);
            String dbUrl = null;
            if ( props != null ) {
                dbUrl = (String) props.get( pool + ".url" );
            }
            if ( dbUrl != null && dbUrl.startsWith("jdbc:odbc:") ) {
                val = new Integer((int) ((Number) param.getObjectValue()).longValue());
            }
        } else { 
            val = value;
        }
        return val;
    }
}
//End SqlCommand class

