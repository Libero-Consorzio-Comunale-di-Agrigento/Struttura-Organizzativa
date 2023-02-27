//copyright DataSource @25-E5DDCD43
package restrict.AmvPreferenzeStile;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End copyright DataSource

//class DataObject Header @25-460A1D59
public class copyrightDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @25-9D15E515
    

    TextField sesUtente = new TextField(null, null);
    
    TextField sesModulo = new TextField(null, null);
    
    TextField urlSTYLE = new TextField(null, null);
    

    private copyrightRow[] rows = new copyrightRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @25-82672299

    public void  setSesUtente( String param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param, Format ignore ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesModulo( String param ) {
        this.sesModulo.setValue( param );
    }

    public void  setSesModulo( Object param ) {
        this.sesModulo.setValue( param );
    }

    public void  setSesModulo( Object param, Format ignore ) {
        this.sesModulo.setValue( param );
    }

    public void  setUrlSTYLE( String param ) {
        this.urlSTYLE.setValue( param );
    }

    public void  setUrlSTYLE( Object param ) {
        this.urlSTYLE.setValue( param );
    }

    public void  setUrlSTYLE( Object param, Format ignore ) {
        this.urlSTYLE.setValue( param );
    }

    public copyrightRow[] getRows() {
        return rows;
    }

    public void setRows(copyrightRow[] rows) {
        this.rows = rows;
    }

    public void setPageNum( int pageNum ) {
        this.pageNum = pageNum;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize( int pageSize ) {
        this.pageSize = pageSize;
    }

//End properties of DataObject

//constructor @25-8D0A5C73
    public copyrightDataObject(Page page) {
        super(page);
    }
//End constructor

//load @25-451551DB
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select nvl(amvweb.get_preferenza('Copyright', '{Modulo}',  "
                    + "'{Utente}'),'© <a href=\"http://www.ads.it\" target=\"_blank\" >Gruppo Finmatica</a> - Tutti i diritti riservati') MESSAGGIO, '<link id=\"AFC\" href=\"../Themes/'||nvl('{STYLE}',nvl(amvweb.get_preferenza('Style','{Modulo}', '{Utente}'),'AFC'))||'/Style.css\" type=\"text/css\" rel=\"stylesheet\">' STILE  "
                    + "from dual" );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( StringUtils.isEmpty( (String) sesModulo.getObjectValue() ) ) sesModulo.setValue( "" );
        command.addParameter( "Modulo", sesModulo, null );
        if ( StringUtils.isEmpty( (String) urlSTYLE.getObjectValue() ) ) urlSTYLE.setValue( "" );
        command.addParameter( "STYLE", urlSTYLE, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( select nvl(amvweb.get_preferenza('Copyright', '{Modulo}',  "
                                                         + "            '{Utente}'),'© <a href=\"http://www.ads.it\" target=\"_blank\" >Gruppo Finmatica</a> - Tutti i diritti riservati') MESSAGGIO, '<link id=\"AFC\" href=\"../Themes/'||nvl('{STYLE}',nvl(amvweb.get_preferenza('Style','{Modulo}', '{Utente}'),'AFC'))||'/Style.css\" type=\"text/css\" rel=\"stylesheet\">' STILE from dual ) cnt " );
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        }
        command.setStartPos( ( pageNum - 1 ) * pageSize + 1 );
        command.setFetchSize( pageSize );

        fireBeforeBuildSelectEvent( new DataObjectEvent(command) );


        fireBeforeExecuteSelectEvent( new DataObjectEvent(command) );

        if ( ! StringUtils.isEmpty( command.getCountSql() ) ) {
            if ( ! ds.hasErrors() ) {
                amountOfRows = command.count();
                CCLogger.getInstance().debug(command.toString());
            }
        }
        Enumeration records = null;
        if ( ! ds.hasErrors() ) {
            records = command.getRows();
        }

        CCLogger.getInstance().debug(command.toString());

        fireAfterExecuteSelectEvent( new DataObjectEvent(command) );

        ds.closeConnection();
//End load

//loadDataBind @25-8A396C25
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                copyrightRow row = new copyrightRow();
                DbRow record = (DbRow) records.nextElement();
                row.setMESSAGGIO(Utils.convertToString(ds.parse(record.get("MESSAGGIO"), row.getMESSAGGIOField())));
                row.setSTILE(Utils.convertToString(ds.parse(record.get("STILE"), row.getSTILEField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @25-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @25-492FE71F
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            if ( "Modulo".equals(name) && "ses".equals(prefix) ) {
                param = sesModulo;
            } else if ( "Modulo".equals(name) && prefix == null ) {
                param = sesModulo;
            }
            if ( "STYLE".equals(name) && "url".equals(prefix) ) {
                param = urlSTYLE;
            } else if ( "STYLE".equals(name) && prefix == null ) {
                param = urlSTYLE;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @25-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @25-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @25-238A81BB
    public void fireBeforeBuildSelectEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource(this);
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i < v.size(); i++) {
            ((DataObjectListener)v.elementAt(i)).beforeBuildSelect(e);
        }
    }
//End fireBeforeBuildSelectEvent

//fireBeforeExecuteSelectEvent @25-9DA7B025
    public void fireBeforeExecuteSelectEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i < v.size(); i++) {
            ((DataObjectListener)v.elementAt(i)).beforeExecuteSelect(e);
        }
    }
//End fireBeforeExecuteSelectEvent

//fireAfterExecuteSelectEvent @25-F7E8A616
    public void fireAfterExecuteSelectEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i < v.size(); i++) {
            ((DataObjectListener)v.elementAt(i)).afterExecuteSelect(e);
        }
    }
//End fireAfterExecuteSelectEvent

//class DataObject Tail @25-ED3F53A4
} // End of class DS
//End class DataObject Tail

