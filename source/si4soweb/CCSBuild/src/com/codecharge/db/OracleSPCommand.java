/******************************************************************************
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
  1    05/02/2003 AO     Gestione parametri di output delle procedure
******************************************************************************/
//OracleSPCommand class @0-85051CD6
package com.codecharge.db;

import java.text.*;
import java.util.*;
import java.sql.*;
import com.codecharge.util.*;
import com.codecharge.db.*;
import com.codecharge.components.*;

public class OracleSPCommand extends SPCommand {

    public static final int ORACLE_CURSOR = -10;
    private int numCursorParam;

    public OracleSPCommand(){}
    
    public OracleSPCommand( JDBCConnection conn ) {
        super( conn );
    }

    public void addParameter( String paramName, Parameter param, int sqlType, int scale, int direction ) {
        if ( param != null ) {
            Format dateFormat = conn.getDateFormat();
            Format booleanFormat = conn.getBooleanFormat();
            boolean applyFormat = false;
            ControlType type = null;
            Format format = null;
            Object value = null;
            value = param.getObjectValue();
            if ( param instanceof Field ) {
              format = ((Field) param).getFormat();
            } else if ( param instanceof Control ) {
              format = ((Control) param).getDbFormat();
              type = ((Control) param).getType();
            } else if ( param instanceof SqlParameter ) {
              format = ((SqlParameter) param).getDbFormat();
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
            applyFormat = false;
            if ( value != null && applyFormat ) {
              value = format.format( value );
            }
            if ( value instanceof Long && sqlType == java.sql.Types.INTEGER ) {
                value = new Integer( (int) ((Long) value).longValue() );
            }
            SPParameter sp = new SPParameter( value, sqlType, scale, direction );
            parameters.add( sp );
        } else {
            SPParameter sp = new SPParameter( null, sqlType, scale, direction );
            parameters.add( sp );
        }
        names.add(paramName);
    }

    public void addParameter( Parameter param, int sqlType, int scale, int direction ) {
        addParameter( "", param, sqlType, scale, direction );
    }
    
    public Collection getParameters() {
        return parameters;
    }
    
    public Object getOutParameter( int index ) {
        if ( parameters == null || index < 1 || index > parameters.size() ) return null;
        
        Object value = null;
        SPParameter param = (SPParameter) parameters.get( index );
        if ( param.getDirection() != SPParameter.INPUT_PARAMETER ) {
            value = param.getValue();
        } else {
            // maybe?
            // throw new SQLException( "it's INPUT parameter" );
        }
        return value;
    }
    
    public Enumeration getRows( int start, int rows ) {
        Enumeration result = null;
        CallableStatement cstmt = prepareCommand();
        ResultSet rs = null;
        if ( cstmt == null ) 
            return result;
        try {    
            cstmt.executeQuery();    
            rs = (ResultSet) cstmt.getObject( numCursorParam );
            result = conn.getRows( rs, start, rows );
            getSPParameters( cstmt );
            next = conn.isNext();
            rs.close();
            cstmt.close();
        } catch ( SQLException sqle ) {
            catchException( sqle );
        } finally {
            try {
                if (rs != null) rs.close();
            } catch (SQLException sqle) { catchException( sqle ); }
            try {
                if (cstmt != null) cstmt.close();
            } catch (SQLException sqle) { catchException( sqle ); }
        }
		return result;
    }

    public Enumeration getRows() {
        Enumeration result = null;
        CallableStatement cstmt = prepareCommand();
        ResultSet rs = null;
        if ( cstmt == null ) 
            return result;
        try {    
            cstmt.executeQuery();    
            rs = (ResultSet) cstmt.getObject( numCursorParam );
            if ( fetchSize > 0 ) {
                result = conn.getRows( rs, startPos, fetchSize );
            } else {
                result = conn.getRows( rs );
            }
            getSPParameters( cstmt );
            next = conn.isNext();
            rs.close();
            cstmt.close();
        } catch ( SQLException sqle ) {
            catchException( sqle );
        } finally {
            try {
                if (rs != null) rs.close();
            } catch (SQLException sqle) { catchException( sqle ); }
            try {
                if (cstmt != null) cstmt.close();
            } catch (SQLException sqle) { catchException( sqle ); }
        }
		return result;
    }

    public DbRow getOneRow() {
        DbRow result = null;
        CallableStatement cstmt = prepareCommand();
        ResultSet rs = null;
        if ( cstmt == null ) 
            return result;
        try {    
            cstmt.executeQuery();    
            rs = (ResultSet) cstmt.getObject( numCursorParam );
            result = conn.getOneRow( rs );
            getSPParameters( cstmt );
            rs.close();
            cstmt.close();
        } catch ( SQLException sqle ) {
            catchException( sqle );
        } finally {
            try {
                if (rs != null) rs.close();
            } catch (SQLException sqle) { catchException( sqle ); }
            try {
                if (cstmt != null) cstmt.close();
            } catch (SQLException sqle) { catchException( sqle ); }
        }
		return result;
    }
    
    public int executeUpdate() {
        int result = 0;
        CallableStatement cstmt = prepareCommand();
        if ( cstmt == null ) 
            return result;
        try {    
            result = cstmt.executeUpdate();    
            getSPParameters( cstmt );
        } catch ( SQLException sqle ) {
            catchException( sqle );
        } finally {
            try {
                if (cstmt != null) cstmt.close();
            } catch (SQLException sqle) { catchException( sqle ); }
        }
		return result;
    }
    
    private void getSPParameters( CallableStatement cstmt ) {
// Rev.1 : gestione parametri output delle procedure, il resto era commentato custom AFC 
        //return;
    
        if ( cstmt == null ) return;
        
        if ( ! (parameters == null || parameters.isEmpty()) ) {
            Iterator params = parameters.iterator();
            int countParams = 1;
            while ( params.hasNext() ) {
                SPParameter param = (SPParameter) params.next();
                if ( param != null ) {
                        switch ( param.getDirection() ) {
                            case SPParameter.OUTPUT_PARAMETER:
                                try {    
                                    param.setValue( cstmt.getObject( countParams ) );
                                    break;
//                                } catch ( SQLException sqle ) {
                                } catch ( Exception sqle ) {
                                    conn.addError( "Exception by cstmt.getObject(" + countParams + ") :"+ sqle.getMessage() + "<br>" );
                                    return;
                                }
                            case SPParameter.INPUT_OUTPUT_PARAMETER:
                                try {    
                                    param.setValue( cstmt.getObject( countParams ) );
                                    break;
//                                } catch ( SQLException sqle ) {
                                } catch ( Exception sqle ) {
                                    conn.addError( "Exception by cstmt.getObject(" + countParams + ") :"+ sqle.getMessage() + "<br>" );
                                    return;
                                }
                        }
                }
                countParams++;
            }
        }
        
    }
// Rev.1 : Fine    
    
    private CallableStatement prepareCommand() {
        CallableStatement cstmt = null;
        if ( conn == null ) {
        } else if ( StringUtils.isEmpty( sql ) ) {
        } else {
            if ( (cstmt = conn.createCallableStatement( sql )) == null ) {
                return cstmt;
            }
            if ( ! (parameters == null || parameters.isEmpty()) ) {
                Iterator params = parameters.iterator();
                int countParams = 1;
                while ( params.hasNext() ) {
                    SPParameter param = (SPParameter) params.next();
                    Format format = null;
                    Object value = null;
                    if ( param != null ) {
                        value = param.getValue();
                        if ( param.getSPType() == ORACLE_CURSOR && numCursorParam == 0 ) {
                          numCursorParam = countParams;
                        }
                        try {    
                            if ( value != null ) {
                                switch ( param.getDirection() ) {
                                    case SPParameter.INPUT_PARAMETER:
                                        cstmt.setObject( countParams, param.getValue(), param.getSPType(), param.getScale() );                              
                                        break;
                                    case SPParameter.OUTPUT_PARAMETER:
                                        cstmt.registerOutParameter( countParams, param.getSPType() );
                                        break;
                                    case SPParameter.INPUT_OUTPUT_PARAMETER:
                                        cstmt.registerOutParameter( countParams, param.getSPType() );
                                        cstmt.setObject( countParams, param.getValue(), param.getSPType(), param.getScale() );                              
                                        break;
                                }
                            } else {
                                switch ( param.getDirection() ) {
                                    case SPParameter.INPUT_PARAMETER:
                                        cstmt.setNull( countParams, param.getSPType() );
                                        break;
                                    case SPParameter.OUTPUT_PARAMETER:
                                        cstmt.registerOutParameter( countParams, param.getSPType() );
                                        break;
                                    case SPParameter.INPUT_OUTPUT_PARAMETER:
                                        cstmt.setNull( countParams, param.getSPType() );
                                        cstmt.registerOutParameter( countParams, param.getSPType() );
                                        break;
                                }
                            }
                        } catch ( SQLException sqle ) {
                            catchException( sqle );
                            return null;
                        }
                    }
                    countParams++;
                }
            }
        }
        return cstmt;
    }

    public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append("SPCommand sql='"+sql+"'\n");
        sb.append("     startPos='"+startPos+"'\n");
        sb.append("    fetchSize='"+fetchSize+"'\n");
        sb.append("   connection='"+conn.getPoolName()+"'\n");
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
                SPParameter param = (SPParameter) params.next();
                if ( param == null ) {
                    sb.append( " : parameter is null\n" );
                } else {
                    Object value = param.getValue();
                    if ( value == null ) {
                        sb.append( " : value is null  type: " + 
                                getSqlTypeName( param.getSPType() ) + " scale: " + 
                                String.valueOf( param.getScale() ) + "\n" );
                    } else {
                        sb.append( " : " + value.toString() + 
                                " type: " + getSqlTypeName( param.getSPType() ) + 
                                " vtype: " + value.getClass().getName() + 
                                " scale: " + String.valueOf( param.getScale() ) + 
                                "\n" );
                    }
                }
            }
        }
        return sb.toString();
    }

}
//End OracleSPCommand class

