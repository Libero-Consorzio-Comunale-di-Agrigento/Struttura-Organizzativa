//Menu DataSource @103-B691A054
package common.AmvLeftMenu;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End Menu DataSource

//class DataObject Header @103-26DD9679
public class MenuDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @103-508E9F10
    

    TextField sesUtente = new TextField(null, null);
    
    TextField sesIstanza = new TextField(null, null);
    
    TextField sesModulo = new TextField(null, null);
    
    TextField sesMVL2 = new TextField(null, null);
    
    TextField sesMVL3 = new TextField(null, null);
    
    TextField sesRuolo = new TextField(null, null);
    
    TextField sesMVURL = new TextField(null, null);
    
    TextField sesMVRP = new TextField(null, null);
    
    TextField sesMVCONTEXT = new TextField(null, null);
    
    TextField sesMVL1 = new TextField(null, null);
    
    TextField sesMVVC = new TextField(null, null);
    

    private MenuRow[] rows = new MenuRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @103-F3A34109

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

    public void  setSesMVL2( String param ) {
        this.sesMVL2.setValue( param );
    }

    public void  setSesMVL2( Object param ) {
        this.sesMVL2.setValue( param );
    }

    public void  setSesMVL2( Object param, Format ignore ) {
        this.sesMVL2.setValue( param );
    }

    public void  setSesMVL3( String param ) {
        this.sesMVL3.setValue( param );
    }

    public void  setSesMVL3( Object param ) {
        this.sesMVL3.setValue( param );
    }

    public void  setSesMVL3( Object param, Format ignore ) {
        this.sesMVL3.setValue( param );
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

    public void  setSesMVURL( String param ) {
        this.sesMVURL.setValue( param );
    }

    public void  setSesMVURL( Object param ) {
        this.sesMVURL.setValue( param );
    }

    public void  setSesMVURL( Object param, Format ignore ) {
        this.sesMVURL.setValue( param );
    }

    public void  setSesMVRP( String param ) {
        this.sesMVRP.setValue( param );
    }

    public void  setSesMVRP( Object param ) {
        this.sesMVRP.setValue( param );
    }

    public void  setSesMVRP( Object param, Format ignore ) {
        this.sesMVRP.setValue( param );
    }

    public void  setSesMVCONTEXT( String param ) {
        this.sesMVCONTEXT.setValue( param );
    }

    public void  setSesMVCONTEXT( Object param ) {
        this.sesMVCONTEXT.setValue( param );
    }

    public void  setSesMVCONTEXT( Object param, Format ignore ) {
        this.sesMVCONTEXT.setValue( param );
    }

    public void  setSesMVL1( String param ) {
        this.sesMVL1.setValue( param );
    }

    public void  setSesMVL1( Object param ) {
        this.sesMVL1.setValue( param );
    }

    public void  setSesMVL1( Object param, Format ignore ) {
        this.sesMVL1.setValue( param );
    }

    public void  setSesMVVC( String param ) {
        this.sesMVVC.setValue( param );
    }

    public void  setSesMVVC( Object param ) {
        this.sesMVVC.setValue( param );
    }

    public void  setSesMVVC( Object param, Format ignore ) {
        this.sesMVVC.setValue( param );
    }

    public MenuRow[] getRows() {
        return rows;
    }

    public void setRows(MenuRow[] rows) {
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

//constructor @103-7E8CA55C
    public MenuDataObject(Page page) {
        super(page);
    }
//End constructor

//load @103-5F778EEC
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT AMV_MENU.GET_BLOCCO('{P_UTENTE}' "
                    + ", '{P_ISTANZA}' "
                    + ", '{P_MODULO}' "
                    + ",  "
                    + "'{MVVC}' "
                    + ", '{P_VOCE_L1}' "
                    + ", '{P_VOCE_L2}' "
                    + ", '{P_VOCE_L3}' "
                    + ", '{P_RUOLO}' "
                    + ", '{MVURL}' "
                    + ",  "
                    + "'{MVRP}' "
                    + ", '{MVCONTEXT}') TABELLA FROM DUAL" );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "P_UTENTE", sesUtente, null );
        if ( StringUtils.isEmpty( (String) sesIstanza.getObjectValue() ) ) sesIstanza.setValue( "" );
        command.addParameter( "P_ISTANZA", sesIstanza, null );
        if ( StringUtils.isEmpty( (String) sesModulo.getObjectValue() ) ) sesModulo.setValue( "" );
        command.addParameter( "P_MODULO", sesModulo, null );
        if ( StringUtils.isEmpty( (String) sesMVL2.getObjectValue() ) ) sesMVL2.setValue( "" );
        command.addParameter( "P_VOCE_L2", sesMVL2, null );
        if ( StringUtils.isEmpty( (String) sesMVL3.getObjectValue() ) ) sesMVL3.setValue( "" );
        command.addParameter( "P_VOCE_L3", sesMVL3, null );
        if ( StringUtils.isEmpty( (String) sesRuolo.getObjectValue() ) ) sesRuolo.setValue( "" );
        command.addParameter( "P_RUOLO", sesRuolo, null );
        if ( StringUtils.isEmpty( (String) sesMVURL.getObjectValue() ) ) sesMVURL.setValue( "" );
        command.addParameter( "MVURL", sesMVURL, null );
        if ( StringUtils.isEmpty( (String) sesMVRP.getObjectValue() ) ) sesMVRP.setValue( "" );
        command.addParameter( "MVRP", sesMVRP, null );
        if ( StringUtils.isEmpty( (String) sesMVCONTEXT.getObjectValue() ) ) sesMVCONTEXT.setValue( "" );
        command.addParameter( "MVCONTEXT", sesMVCONTEXT, null );
        if ( StringUtils.isEmpty( (String) sesMVL1.getObjectValue() ) ) sesMVL1.setValue( "" );
        command.addParameter( "P_VOCE_L1", sesMVL1, null );
        if ( StringUtils.isEmpty( (String) sesMVVC.getObjectValue() ) ) sesMVVC.setValue( "" );
        command.addParameter( "MVVC", sesMVVC, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT AMV_MENU.GET_BLOCCO('{P_UTENTE}' , '{P_ISTANZA}' , '{P_MODULO}' ,  "
                                                         + "            '{MVVC}' , '{P_VOCE_L1}' , '{P_VOCE_L2}' , '{P_VOCE_L3}' , '{P_RUOLO}' ,  "
                                                         + "            '{MVURL}' , '{MVRP}' , '{MVCONTEXT}') TABELLA FROM DUAL ) cnt " );
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

//loadDataBind @103-AF1C452E
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                MenuRow row = new MenuRow();
                DbRow record = (DbRow) records.nextElement();
                row.setMENU(Utils.convertToString(ds.parse(record.get("TABELLA"), row.getMENUField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @103-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @103-BC52B56B
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
            if ( "MVL2".equals(name) && "ses".equals(prefix) ) {
                param = sesMVL2;
            } else if ( "MVL2".equals(name) && prefix == null ) {
                param = sesMVL2;
            }
            if ( "MVL3".equals(name) && "ses".equals(prefix) ) {
                param = sesMVL3;
            } else if ( "MVL3".equals(name) && prefix == null ) {
                param = sesMVL3;
            }
            if ( "Ruolo".equals(name) && "ses".equals(prefix) ) {
                param = sesRuolo;
            } else if ( "Ruolo".equals(name) && prefix == null ) {
                param = sesRuolo;
            }
            if ( "MVURL".equals(name) && "ses".equals(prefix) ) {
                param = sesMVURL;
            } else if ( "MVURL".equals(name) && prefix == null ) {
                param = sesMVURL;
            }
            if ( "MVRP".equals(name) && "ses".equals(prefix) ) {
                param = sesMVRP;
            } else if ( "MVRP".equals(name) && prefix == null ) {
                param = sesMVRP;
            }
            if ( "MVCONTEXT".equals(name) && "ses".equals(prefix) ) {
                param = sesMVCONTEXT;
            } else if ( "MVCONTEXT".equals(name) && prefix == null ) {
                param = sesMVCONTEXT;
            }
            if ( "MVL1".equals(name) && "ses".equals(prefix) ) {
                param = sesMVL1;
            } else if ( "MVL1".equals(name) && prefix == null ) {
                param = sesMVL1;
            }
            if ( "MVVC".equals(name) && "ses".equals(prefix) ) {
                param = sesMVVC;
            } else if ( "MVVC".equals(name) && prefix == null ) {
                param = sesMVVC;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @103-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @103-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @103-238A81BB
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

//fireBeforeExecuteSelectEvent @103-9DA7B025
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

//fireAfterExecuteSelectEvent @103-F7E8A616
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

//class DataObject Tail @103-ED3F53A4
} // End of class DS
//End class DataObject Tail

