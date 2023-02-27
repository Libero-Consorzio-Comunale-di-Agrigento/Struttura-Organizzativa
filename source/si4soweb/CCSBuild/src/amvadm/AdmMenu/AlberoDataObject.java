//Albero DataSource @15-93188AC4
package amvadm.AdmMenu;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End Albero DataSource

//class DataObject Header @15-E06D07DB
public class AlberoDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @15-76F4CEC4
    

    TextField sesUtente = new TextField(null, null);
    
    TextField sesIstanza = new TextField(null, null);
    
    TextField sesModulo = new TextField(null, null);
    
    TextField sesMVSM = new TextField(null, null);
    
    TextField urlL2 = new TextField(null, null);
    
    TextField urlL3 = new TextField(null, null);
    
    TextField sesMVSR = new TextField(null, null);
    
    TextField urlVC = new TextField(null, null);
    
    TextField sesMVID = new TextField(null, null);
    
    TextField sesMVSP = new TextField(null, null);
    
    TextField sesProgetto = new TextField(null, null);
    

    private AlberoRow[] rows = new AlberoRow[300];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @15-34F293F6

    public void  setSesUtente( String param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param, Format ignore ) {
        this.sesUtente.setValue( param );
    }

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

    public void  setSesMVSM( String param ) {
        this.sesMVSM.setValue( param );
    }

    public void  setSesMVSM( Object param ) {
        this.sesMVSM.setValue( param );
    }

    public void  setSesMVSM( Object param, Format ignore ) {
        this.sesMVSM.setValue( param );
    }

    public void  setUrlL2( String param ) {
        this.urlL2.setValue( param );
    }

    public void  setUrlL2( Object param ) {
        this.urlL2.setValue( param );
    }

    public void  setUrlL2( Object param, Format ignore ) {
        this.urlL2.setValue( param );
    }

    public void  setUrlL3( String param ) {
        this.urlL3.setValue( param );
    }

    public void  setUrlL3( Object param ) {
        this.urlL3.setValue( param );
    }

    public void  setUrlL3( Object param, Format ignore ) {
        this.urlL3.setValue( param );
    }

    public void  setSesMVSR( String param ) {
        this.sesMVSR.setValue( param );
    }

    public void  setSesMVSR( Object param ) {
        this.sesMVSR.setValue( param );
    }

    public void  setSesMVSR( Object param, Format ignore ) {
        this.sesMVSR.setValue( param );
    }

    public void  setUrlVC( String param ) {
        this.urlVC.setValue( param );
    }

    public void  setUrlVC( Object param ) {
        this.urlVC.setValue( param );
    }

    public void  setUrlVC( Object param, Format ignore ) {
        this.urlVC.setValue( param );
    }

    public void  setSesMVID( String param ) {
        this.sesMVID.setValue( param );
    }

    public void  setSesMVID( Object param ) {
        this.sesMVID.setValue( param );
    }

    public void  setSesMVID( Object param, Format ignore ) {
        this.sesMVID.setValue( param );
    }

    public void  setSesMVSP( String param ) {
        this.sesMVSP.setValue( param );
    }

    public void  setSesMVSP( Object param ) {
        this.sesMVSP.setValue( param );
    }

    public void  setSesMVSP( Object param, Format ignore ) {
        this.sesMVSP.setValue( param );
    }

    public void  setSesProgetto( String param ) {
        this.sesProgetto.setValue( param );
    }

    public void  setSesProgetto( Object param ) {
        this.sesProgetto.setValue( param );
    }

    public void  setSesProgetto( Object param, Format ignore ) {
        this.sesProgetto.setValue( param );
    }

    public AlberoRow[] getRows() {
        return rows;
    }

    public void setRows(AlberoRow[] rows) {
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

//constructor @15-834318E1
    public AlberoDataObject(Page page) {
        super(page);
    }
//End constructor

//load @15-E68DF1F9
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT AMV_MENU.GET_ALBERO_MENU('{Utente}' "
                    + ", '{Istanza}' "
                    + ", '{MVSM}' "
                    + ", '{MVSP}' "
                    + ",  "
                    + "'{P_VOCE_L2}' "
                    + ", '{P_VOCE_L3}' "
                    + ", '{MVSR}' "
                    + ", '{P_VOCE_SEL}' "
                    + ",  "
                    + "'{MVID}' "
                    + ") TABELLA FROM DUAL" );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( StringUtils.isEmpty( (String) sesIstanza.getObjectValue() ) ) sesIstanza.setValue( "" );
        command.addParameter( "Istanza", sesIstanza, null );
        if ( StringUtils.isEmpty( (String) sesModulo.getObjectValue() ) ) sesModulo.setValue( "" );
        command.addParameter( "Modulo", sesModulo, null );
        if ( StringUtils.isEmpty( (String) sesMVSM.getObjectValue() ) ) sesMVSM.setValue( "" );
        command.addParameter( "MVSM", sesMVSM, null );
        if ( StringUtils.isEmpty( (String) urlL2.getObjectValue() ) ) urlL2.setValue( "" );
        command.addParameter( "P_VOCE_L2", urlL2, null );
        if ( StringUtils.isEmpty( (String) urlL3.getObjectValue() ) ) urlL3.setValue( "" );
        command.addParameter( "P_VOCE_L3", urlL3, null );
        if ( StringUtils.isEmpty( (String) sesMVSR.getObjectValue() ) ) sesMVSR.setValue( "*" );
        command.addParameter( "MVSR", sesMVSR, null );
        if ( StringUtils.isEmpty( (String) urlVC.getObjectValue() ) ) urlVC.setValue( "" );
        command.addParameter( "P_VOCE_SEL", urlVC, null );
        if ( StringUtils.isEmpty( (String) sesMVID.getObjectValue() ) ) sesMVID.setValue( "0" );
        command.addParameter( "MVID", sesMVID, null );
        if ( StringUtils.isEmpty( (String) sesMVSP.getObjectValue() ) ) sesMVSP.setValue( "" );
        command.addParameter( "MVSP", sesMVSP, null );
        if ( StringUtils.isEmpty( (String) sesProgetto.getObjectValue() ) ) sesProgetto.setValue( "" );
        command.addParameter( "Progetto", sesProgetto, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT AMV_MENU.GET_ALBERO_MENU('{Utente}' , '{Istanza}' , '{MVSM}' , '{MVSP}' ,  "
                                                         + "            '{P_VOCE_L2}' , '{P_VOCE_L3}' , '{MVSR}' , '{P_VOCE_SEL}' ,  "
                                                         + "            '{MVID}' ) TABELLA FROM DUAL ) cnt " );
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

//loadDataBind @15-58860F34
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AlberoRow row = new AlberoRow();
                DbRow record = (DbRow) records.nextElement();
                row.setMENU(Utils.convertToString(ds.parse(record.get("TABELLA"), row.getMENUField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @15-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @15-1745EA38
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
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
            if ( "MVSM".equals(name) && "ses".equals(prefix) ) {
                param = sesMVSM;
            } else if ( "MVSM".equals(name) && prefix == null ) {
                param = sesMVSM;
            }
            if ( "L2".equals(name) && "url".equals(prefix) ) {
                param = urlL2;
            } else if ( "L2".equals(name) && prefix == null ) {
                param = urlL2;
            }
            if ( "L3".equals(name) && "url".equals(prefix) ) {
                param = urlL3;
            } else if ( "L3".equals(name) && prefix == null ) {
                param = urlL3;
            }
            if ( "MVSR".equals(name) && "ses".equals(prefix) ) {
                param = sesMVSR;
            } else if ( "MVSR".equals(name) && prefix == null ) {
                param = sesMVSR;
            }
            if ( "VC".equals(name) && "url".equals(prefix) ) {
                param = urlVC;
            } else if ( "VC".equals(name) && prefix == null ) {
                param = urlVC;
            }
            if ( "MVID".equals(name) && "ses".equals(prefix) ) {
                param = sesMVID;
            } else if ( "MVID".equals(name) && prefix == null ) {
                param = sesMVID;
            }
            if ( "MVSP".equals(name) && "ses".equals(prefix) ) {
                param = sesMVSP;
            } else if ( "MVSP".equals(name) && prefix == null ) {
                param = sesMVSP;
            }
            if ( "Progetto".equals(name) && "ses".equals(prefix) ) {
                param = sesProgetto;
            } else if ( "Progetto".equals(name) && prefix == null ) {
                param = sesProgetto;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @15-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @15-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @15-238A81BB
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

//fireBeforeExecuteSelectEvent @15-9DA7B025
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

//fireAfterExecuteSelectEvent @15-F7E8A616
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

//class DataObject Tail @15-ED3F53A4
} // End of class DS
//End class DataObject Tail

