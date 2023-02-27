/******************************************************************************
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    04/02/2003 AO     Gestione messaggi di errore
 2    09/06/2003 AO     Gestione messaggio di errore che contiene "ORA-" nella descrizione
 3    19/09/2003 AO     Correzione su gestione messaggi di errore in cui stringa "ORA-" 
			compaia una sola volta (violazione foreign key, etc.)
******************************************************************************/
//Command class @0-1BCE867D
package com.codecharge.db;

import java.util.*;
import java.text.Format;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.util.StringUtils;

abstract public class Command {
    protected String sql;
    protected String countSql;
    protected String where;
    protected String order;
    protected Vector parameters = new Vector();
    protected Vector formats = new Vector();
    protected Vector names = new Vector();
    protected boolean cmdExecution = true;

    protected JDBCConnection conn;
    protected int startPos;
    protected int fetchSize;
    protected boolean next;
    /** Custom SQL doesn't need quotes.
      But table datasource will need them sometimes.
      Indicate when it needs them, with this property.
     **/
    protected boolean needQuotes;

    protected static int COUNT_SQL = 1;
    protected static int SQL = 0;
    
    public Command() {}
    
    public Command( JDBCConnection conn ) {
        this.conn = conn;
    }

    abstract public Enumeration getRows( int start, int rows );
    abstract public Enumeration getRows();
    abstract public DbRow getOneRow();
    abstract public int executeUpdate();
    abstract public int nrecords();

    public String getSql() {
        return sql;
    }

    public void setSql( String sql ) {
        this.sql = sql;
    }

    public void setSql( StringBuffer sql ) {
        if ( sql == null ) {
            this.sql = null;
        } else {
            this.sql = sql.toString();
        }
    }

    public String getCountSql() {
        return countSql;
    }

    public void setCountSql( String countSql ) {
        this.countSql = countSql;
    }

    public void setCountSql( StringBuffer countSql ) {
        if ( countSql == null ) {
            this.countSql = null;
        } else {
            this.countSql = countSql.toString();
        }
    }

    public String getWhere() {
        return where;
    }

    public void setWhere( String where ) {
        this.where = where;
    }

    public void setWhere( StringBuffer where ) {
        if ( where == null ) {
            this.where = null;
        } else {
            this.where = where.toString();
        }
    }

    public String getOrder() {
        return order;
    }

    public void setOrder( String order ) {
        this.order = order;
    }

    public void setOrder( StringBuffer order ) {
        if ( order == null ) {
            this.order = null;
        } else {
            this.order = order.toString();
        }
    }

    public boolean isNext() {
        return next;
    }
    
    public boolean isCmdExecution() {
        return cmdExecution;
    }
    
    public void setCmdExecution(boolean exec) {
        cmdExecution = exec;
    }
    
    public void setJdbcConnection( JDBCConnection conn ) {
        this.conn = conn;
    }

    public void setJDBCConnection( JDBCConnection conn ) {
        this.conn = conn;
    }

    public JDBCConnection getJdbcConnection() {
        return conn;
    }

    public JDBCConnection getJDBCConnection() {
        return conn;
    }

    public int getStartPos() {
        return startPos;
    }

    public void setStartPos( int start ) {
        startPos = start;
    }

    public int getFetchSize() {
        return fetchSize;
    }

    public void setFetchSize( int size ) {
        fetchSize = size;
    }

    public void setNeedQuotes(boolean f) {
      needQuotes = f;
    }
    public static String getSqlTypeName( int type ) {
        String typeName = null;
        switch ( type ) {
            case java.sql.Types.ARRAY: 
                typeName = "ARRAY";
                break;
            case java.sql.Types.BIGINT: 
                typeName = "BIGINT";
                break;
            case java.sql.Types.BINARY :
                typeName = "BINARY";
                break;
            case java.sql.Types.BIT :
                typeName = "BIT";
                break;
            case java.sql.Types.BLOB :
                typeName = "BLOB";
                break;
            case java.sql.Types.CHAR :
                typeName = "CHAR";
                break;
            case java.sql.Types.CLOB :
                typeName = "CLOB";
                break;
            case java.sql.Types.DATE :
                typeName = "DATE";
                break;
            case java.sql.Types.DECIMAL: 
                typeName = "DECIMAL";
                break;
            case java.sql.Types.DISTINCT: 
                typeName = "DISTINCT";
                break;
            case java.sql.Types.DOUBLE :
                typeName = "DOUBLE";
                break;
            case java.sql.Types.FLOAT :
                typeName = "FLOAT";
                break;
            case java.sql.Types.INTEGER: 
                typeName = "INTEGER";
                break;
            case java.sql.Types.JAVA_OBJECT: 
                typeName = "JAVA_OBJECT";
                break;
            case java.sql.Types.LONGVARBINARY: 
                typeName = "LONGVARBINARY";
                break;
            case java.sql.Types.LONGVARCHAR :
                typeName = "LONGVARCHAR";
                break;
            case java.sql.Types.NULL :
                typeName = "NULL";
                break;
            case java.sql.Types.NUMERIC: 
                typeName = "NUMERIC";
                break;
            case java.sql.Types.OTHER :
                typeName = "OTHER";
                break;
            case java.sql.Types.REAL :
                typeName = "REAL";
                break;
            case java.sql.Types.REF :
                typeName = "REF";
                break;
            case java.sql.Types.SMALLINT: 
                typeName = "SMALLINT";
                break;
            case java.sql.Types.STRUCT :
                typeName = "STRUCT";
                break;
            case java.sql.Types.TIME :
                typeName = "TIME";
                break;
            case java.sql.Types.TIMESTAMP: 
                typeName = "TIMESTAMP";
                break;
            case java.sql.Types.TINYINT :
                typeName = "TINYINT";
                break;
            case java.sql.Types.VARBINARY: 
                typeName = "VARBINARY";
                break;
            case java.sql.Types.VARCHAR :
                typeName = "VARCHAR";
                break;
            default:
                typeName = String.valueOf( type );
        }
        return typeName;
    }
    public void addParameter( Parameter param ) {
      if (param != null) {
        parameters.add(param);
        formats.add(null);
      }
    }

    public void addParameter( String paramName, Parameter param ) {
        addParameter( paramName, param, null );
    }

    public void addParameter( String paramName, Parameter param, Format format ) {
        if ( param != null && ! StringUtils.isEmpty( paramName ) ) {
            parameters.add( param );
            formats.add ( format );
            names.add ( paramName );
        }
    }
    
    public void addParameter(Control cntrl) {
      parameters.add(cntrl);
      formats.add(null);
      names.add(cntrl.getFieldSource());
    }

    public void addParameter( SqlParameter param ) {
        return;
    }

    public void addRawParameter( SqlParameter param ) {
        return;
    }

    public void addParameter( SPParameter param ) {
        return;
    }

    public Parameter getParameter( String paramName ) {
        return null;
    }

    public Parameter getParameter( int index ) {
        if ( index >= parameters.size() ) {
            return null;
        }
        return (Parameter) parameters.get(index);
    }

    public void removeParameters() {
      parameters = new Vector();
      formats = new Vector();
      names = new Vector();
    }

    public void clearParameters() {
      parameters.clear();
      formats.clear();
      names.clear();
    }

// Rev.1 : gestione messaggi di errore custom AFC
/*    protected void catchException( Exception e ) {
        StringBuffer sb = new StringBuffer();
        String commandName = this.getClass().getName();
        int pos = commandName.lastIndexOf(".");
        if (pos > -1) {
            commandName = commandName.substring(pos+1);
        }
        sb.append("Can't execute "+commandName+"\n");
        sb.append( StringUtils.toHtml(toString()) );
        conn.logger.error( sb.toString(), e );
        java.io.StringWriter sw = new java.io.StringWriter();
        java.io.PrintWriter pw = new java.io.PrintWriter(sw);
        e.printStackTrace(pw);
        pw.flush();
        sb.append("=== SQLException ====\n" + sw.toString() + "\n" );
        pw.close();
        try {
            sw.close();
        } catch ( java.io.IOException ignore ) {}
        if (! StringUtils.isEmpty(e.getMessage())) {
            conn.addError( StringUtils.replace(e.getMessage(), "\n", "<br>") );
        } else {
            conn.addError( StringUtils.replace(sb.toString(), "\n", "<br>") );
            
        }    
    }*/
       protected void catchException( Exception e ) {
        StringBuffer sb = new StringBuffer();
/* Gestione get_error*/
	String error_msg = null;
	String debug = null;
	String sql = null;
	error_msg = StringUtils.replace(e.getMessage(),"'","''");
	if (e.getMessage().indexOf("ORA-") >= 0) {
		sql = "SELECT si4.get_error('" + error_msg + "') MSG, "
				+ "nvl(amvweb.get_preferenza('Debug'),'NO') DEBUG from dual";
	} else { 
		sql = "SELECT '" + error_msg +"' MSG, "
				+ "nvl(amvweb.get_preferenza('Debug'),'NO') DEBUG from dual";
	} 
	DbRow row = conn.getOneRow(sql);
 	error_msg = row.get("MSG").toString();
	debug = row.get("DEBUG").toString();
	if (debug.equals("SI")) {
		sb.append(e.getMessage() + "\n DEBUGGER=YES\n" );
		sb.append( toString() );
	} else {	
		if (error_msg.lastIndexOf("ORA-") > 14){
			sb.append(error_msg.substring(0,error_msg.indexOf("ORA-",15) - 1) + "\n" );
		} else {
			sb.append(error_msg + "\n" );
		}
		if (!((error_msg.indexOf("ORA-00001") == 0) ||
		    (error_msg.indexOf("ORA-20") == 0) ||
			(error_msg.indexOf("ORA-0229") == 0)||
			(error_msg.indexOf("ORA-") == -1))) {
		  sb.append("\nDettaglio istruzione SQL:\n" );
		  sb.append(e.getMessage() + "\n" );
                  sb.append( toString() );
		}		
	}
        conn.logger.error( sb.toString(), e );
        conn.addError( StringUtils.replace(sb.toString(), "\n", "<br>") );
    }
// Rev.1 : fine custom AFC

}

//End Command class

