//registrazione_servizio DataSource @2-90D96983
package common.AmvRegistrazioneLink;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End registrazione_servizio DataSource

//class DataObject Header @2-A0902639
public class registrazione_servizioDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @2-7F41720B
    

    TextField sesIstanza = new TextField(null, null);
    
    TextField sesModulo = new TextField(null, null);
    
    TextField sesUserLogin = new TextField(null, null);
    
    TextField sesUtente = new TextField(null, null);
    
    TextField sesRuolo = new TextField(null, null);
    

    private registrazione_servizioRow[] rows = new registrazione_servizioRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @2-5FBE0A6F

    public void  setSesIstanza( String param ) {
        this.sesIstanza.setValue( param );
    }

    public void  setSesIstanza( Object param ) {
        this.sesIstanza.setValue( param );
    }

    public void  setSesIstanza( Object param, Format ignore ) {
        this.sesIstanza.setValue( param );
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

    public void  setSesUserLogin( String param ) {
        this.sesUserLogin.setValue( param );
    }

    public void  setSesUserLogin( Object param ) {
        this.sesUserLogin.setValue( param );
    }

    public void  setSesUserLogin( Object param, Format ignore ) {
        this.sesUserLogin.setValue( param );
    }

    public void  setSesUtente( String param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param, Format ignore ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesRuolo( String param ) {
        this.sesRuolo.setValue( param );
    }

    public void  setSesRuolo( Object param ) {
        this.sesRuolo.setValue( param );
    }

    public void  setSesRuolo( Object param, Format ignore ) {
        this.sesRuolo.setValue( param );
    }

    public registrazione_servizioRow[] getRows() {
        return rows;
    }

    public void setRows(registrazione_servizioRow[] rows) {
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

//constructor @2-20545C56
    public registrazione_servizioDataObject(Page page) {
        super(page);
    }
//End constructor

//load @2-9114FAAF
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select m.descrizione||'&nbsp;-&nbsp;'||i.descrizione servizio "
                    + ",  "
                    + "'{UserLogin}' nominativo "
                    + ", i.istanza "
                    + ", m.modulo "
                    + ", 'nuova richiesta' richiesta "
                    + "from ad4_moduli m,  "
                    + "ad4_istanze i "
                    + "where i.istanza ='{Istanza}' "
                    + "and m.modulo = '{Modulo}' "
                    + "and not exists ( "
                    + "select 1 from ad4_diritti_accesso d "
                    + "where d.istanza='{Istanza}' "
                    + "and d.modulo = '{Modulo}' "
                    + "and (d.utente = '{Utente}' "
                    + "or '{Utente}'= 'GUEST'))" );
        if ( StringUtils.isEmpty( (String) sesIstanza.getObjectValue() ) ) sesIstanza.setValue( "" );
        command.addParameter( "Istanza", sesIstanza, null );
        if ( StringUtils.isEmpty( (String) sesModulo.getObjectValue() ) ) sesModulo.setValue( "" );
        command.addParameter( "Modulo", sesModulo, null );
        if ( StringUtils.isEmpty( (String) sesUserLogin.getObjectValue() ) ) sesUserLogin.setValue( "" );
        command.addParameter( "UserLogin", sesUserLogin, null );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( StringUtils.isEmpty( (String) sesRuolo.getObjectValue() ) ) sesRuolo.setValue( "" );
        command.addParameter( "Ruolo", sesRuolo, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( select m.descrizione||'&nbsp;-&nbsp;'||i.descrizione servizio ,  "
                                                         + "            '{UserLogin}' nominativo , i.istanza , m.modulo ,  "
                                                         + "            'nuova richiesta' richiesta from ad4_moduli m,  "
                                                         + "            ad4_istanze i where i.istanza ='{Istanza}' and m.modulo = '{Modulo}' and not exists ( select 1 from ad4_diritti_accesso d where d.istanza='{Istanza}' and d.modulo = '{Modulo}' and (d.utente = '{Utente}' or '{Utente}'= 'GUEST')) ) cnt " );
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

//loadDataBind @2-5D66D755
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                registrazione_servizioRow row = new registrazione_servizioRow();
                DbRow record = (DbRow) records.nextElement();
                row.setSERVIZIO(Utils.convertToString(ds.parse(record.get("SERVIZIO"), row.getSERVIZIOField())));
                row.setNOMINATIVO(Utils.convertToString(ds.parse(record.get("NOMINATIVO"), row.getNOMINATIVOField())));
                row.setREGISTRAZIONE(Utils.convertToString(ds.parse(record.get("RICHIESTA"), row.getREGISTRAZIONEField())));
                row.setMODULO(Utils.convertToString(ds.parse(record.get("MODULO"), row.getMODULOField())));
                row.setISTANZA(Utils.convertToString(ds.parse(record.get("ISTANZA"), row.getISTANZAField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @2-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @2-2D941075
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "Istanza".equals(name) && "ses".equals(prefix) ) {
                param = sesIstanza;
            } else if ( "Istanza".equals(name) && prefix == null ) {
                param = sesIstanza;
            }
            if ( "Modulo".equals(name) && "ses".equals(prefix) ) {
                param = sesModulo;
            } else if ( "Modulo".equals(name) && prefix == null ) {
                param = sesModulo;
            }
            if ( "UserLogin".equals(name) && "ses".equals(prefix) ) {
                param = sesUserLogin;
            } else if ( "UserLogin".equals(name) && prefix == null ) {
                param = sesUserLogin;
            }
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            if ( "Ruolo".equals(name) && "ses".equals(prefix) ) {
                param = sesRuolo;
            } else if ( "Ruolo".equals(name) && prefix == null ) {
                param = sesRuolo;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @2-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @2-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @2-238A81BB
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

//fireBeforeExecuteSelectEvent @2-9DA7B025
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

//fireAfterExecuteSelectEvent @2-F7E8A616
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

//class DataObject Tail @2-ED3F53A4
} // End of class DS
//End class DataObject Tail

