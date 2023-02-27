//welcome DataSource @19-D64F0131
package common.AmvHeader;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End welcome DataSource

//class DataObject Header @19-F67B29AC
public class welcomeDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @19-C2388D54
    

    TextField sesUtente = new TextField(null, null);
    
    TextField sesNote = new TextField(null, null);
    
    TextField sesUserLogin = new TextField(null, null);
    
    TextField sesModulo = new TextField(null, null);
    
    LongField urlMVSZ = new LongField(null, null);
    

    private welcomeRow[] rows = new welcomeRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @19-C98A5E22

    public void  setSesUtente( String param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param, Format ignore ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesNote( String param ) {
        this.sesNote.setValue( param );
    }

    public void  setSesNote( Object param ) {
        this.sesNote.setValue( param );
    }

    public void  setSesNote( Object param, Format ignore ) {
        this.sesNote.setValue( param );
    }

    public void  setSesUserLogin( String param ) {
        this.sesUserLogin.setValue( param );
    }

    public void  setSesUserLogin( Object param ) {
        this.sesUserLogin.setValue( param );
    }

    public void  setSesUserLogin( Object param, Format ignore ) {
        this.sesUserLogin.setValue( param );
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

    public void  setUrlMVSZ( long param ) {
        this.urlMVSZ.setValue( param );
    }

    public void  setUrlMVSZ( long param, Format ignore ) throws java.text.ParseException {
        this.urlMVSZ.setValue( param );
    }

    public void  setUrlMVSZ( Object param, Format format ) throws java.text.ParseException {
        this.urlMVSZ.setValue( param, format );
    }

    public void  setUrlMVSZ( Long param ) {
        this.urlMVSZ.setValue( param );
    }

    public welcomeRow[] getRows() {
        return rows;
    }

    public void setRows(welcomeRow[] rows) {
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

//constructor @19-3CAE1193
    public welcomeDataObject(Page page) {
        super(page);
    }
//End constructor

//load @19-0A2D492B
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select  "
                    + "amvweb.get_preferenza('Intestazione',{MVSZ},'{Modulo}') intestazione "
                    + ",amvweb.get('HEADER.MESSAGGIO', '{Modulo}', '{Utente}',  "
                    + "'{UserLogin}') messaggio "
                    + ",amvweb.get('HEADER.OGGI') oggi   "
                    + ",amvweb.get('HEADER.NOTE', '{Modulo}',  "
                    + "'{Note}') note "
                    + ",amvweb.get('HEADER.MENUBAR', '{Utente}',  "
                    + "'{Modulo}') menubar   "
                    + ",amvweb.get('HEADER.NUOVI_MSG', '{Utente}') nuovi_msg "
                    + "from dual" );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( StringUtils.isEmpty( (String) sesNote.getObjectValue() ) ) sesNote.setValue( "" );
        command.addParameter( "Note", sesNote, null );
        if ( StringUtils.isEmpty( (String) sesUserLogin.getObjectValue() ) ) sesUserLogin.setValue( "" );
        command.addParameter( "UserLogin", sesUserLogin, null );
        if ( StringUtils.isEmpty( (String) sesModulo.getObjectValue() ) ) sesModulo.setValue( "" );
        command.addParameter( "Modulo", sesModulo, null );
        if ( urlMVSZ.getObjectValue() == null ) urlMVSZ.setValue( 0 );
        command.addParameter( "MVSZ", urlMVSZ, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( select amvweb.get_preferenza('Intestazione',{MVSZ},'{Modulo}') intestazione ,amvweb.get('HEADER.MESSAGGIO', '{Modulo}', '{Utente}',  "
                                                         + "            '{UserLogin}') messaggio ,amvweb.get('HEADER.OGGI') oggi ,amvweb.get('HEADER.NOTE',  "
                                                         + "            '{Modulo}', '{Note}') note ,amvweb.get('HEADER.MENUBAR', '{Utente}',  "
                                                         + "            '{Modulo}') menubar ,amvweb.get('HEADER.NUOVI_MSG',  "
                                                         + "            '{Utente}') nuovi_msg from dual ) cnt " );
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

//loadDataBind @19-0F00C10F
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                welcomeRow row = new welcomeRow();
                DbRow record = (DbRow) records.nextElement();
                row.setINTESTAZIONE(Utils.convertToString(ds.parse(record.get("INTESTAZIONE"), row.getINTESTAZIONEField())));
                row.setMESSAGGIO(Utils.convertToString(ds.parse(record.get("MESSAGGIO"), row.getMESSAGGIOField())));
                row.setOGGI(Utils.convertToString(ds.parse(record.get("OGGI"), row.getOGGIField())));
                row.setNOTE(Utils.convertToString(ds.parse(record.get("NOTE"), row.getNOTEField())));
                row.setNEW_MSG(Utils.convertToString(ds.parse(record.get("NUOVI_MSG"), row.getNEW_MSGField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @19-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @19-6D33FDF3
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            if ( "Note".equals(name) && "ses".equals(prefix) ) {
                param = sesNote;
            } else if ( "Note".equals(name) && prefix == null ) {
                param = sesNote;
            }
            if ( "UserLogin".equals(name) && "ses".equals(prefix) ) {
                param = sesUserLogin;
            } else if ( "UserLogin".equals(name) && prefix == null ) {
                param = sesUserLogin;
            }
            if ( "Modulo".equals(name) && "ses".equals(prefix) ) {
                param = sesModulo;
            } else if ( "Modulo".equals(name) && prefix == null ) {
                param = sesModulo;
            }
            if ( "MVSZ".equals(name) && "url".equals(prefix) ) {
                param = urlMVSZ;
            } else if ( "MVSZ".equals(name) && prefix == null ) {
                param = urlMVSZ;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @19-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @19-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @19-238A81BB
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

//fireBeforeExecuteSelectEvent @19-9DA7B025
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

//fireAfterExecuteSelectEvent @19-F7E8A616
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

//class DataObject Tail @19-ED3F53A4
} // End of class DS
//End class DataObject Tail

