//INSERISCI_RICHIESTA DataSource @29-4B91B36E
package restrict.ServletModulistica;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End INSERISCI_RICHIESTA DataSource

//class DataObject Header @29-603514D3
public class INSERISCI_RICHIESTADataObject extends DS {
//End class DataObject Header

//attributes of DataObject @29-E3B7EC08
    

    TextField sesUtente = new TextField(null, null);
    
    LongField sesMVIDRIC = new LongField(null, null);
    
    TextField postCr = new TextField(null, null);
    
    TextField sesMVEXE = new TextField(null, null);
    
    LongField sesMVIDPDRIC = new LongField(null, null);
    

    private INSERISCI_RICHIESTARow[] rows = new INSERISCI_RICHIESTARow[300];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @29-AE547F84

    public void  setSesUtente( String param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param, Format ignore ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesMVIDRIC( long param ) {
        this.sesMVIDRIC.setValue( param );
    }

    public void  setSesMVIDRIC( long param, Format ignore ) throws java.text.ParseException {
        this.sesMVIDRIC.setValue( param );
    }

    public void  setSesMVIDRIC( Object param, Format format ) throws java.text.ParseException {
        this.sesMVIDRIC.setValue( param, format );
    }

    public void  setSesMVIDRIC( Long param ) {
        this.sesMVIDRIC.setValue( param );
    }

    public void  setPostCr( String param ) {
        this.postCr.setValue( param );
    }

    public void  setPostCr( Object param ) {
        this.postCr.setValue( param );
    }

    public void  setPostCr( Object param, Format ignore ) {
        this.postCr.setValue( param );
    }

    public void  setSesMVEXE( String param ) {
        this.sesMVEXE.setValue( param );
    }

    public void  setSesMVEXE( Object param ) {
        this.sesMVEXE.setValue( param );
    }

    public void  setSesMVEXE( Object param, Format ignore ) {
        this.sesMVEXE.setValue( param );
    }

    public void  setSesMVIDPDRIC( long param ) {
        this.sesMVIDPDRIC.setValue( param );
    }

    public void  setSesMVIDPDRIC( long param, Format ignore ) throws java.text.ParseException {
        this.sesMVIDPDRIC.setValue( param );
    }

    public void  setSesMVIDPDRIC( Object param, Format format ) throws java.text.ParseException {
        this.sesMVIDPDRIC.setValue( param, format );
    }

    public void  setSesMVIDPDRIC( Long param ) {
        this.sesMVIDPDRIC.setValue( param );
    }

    public INSERISCI_RICHIESTARow[] getRows() {
        return rows;
    }

    public void setRows(INSERISCI_RICHIESTARow[] rows) {
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

//constructor @29-80D29117
    public INSERISCI_RICHIESTADataObject(Page page) {
        super(page);
        addDataObjectListener( new INSERISCI_RICHIESTADataObjectHandler() );
    }
//End constructor

//load @29-ABBD0622
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT AMV_DOCUMENTO.CREA_RICHIESTA(decode({MVIDRIC} "
                    + "                                          ,0,{MVIDPDRIC} "
                    + "                                            ,{MVIDRIC} "
                    + "                                          ) "
                    + "                                   ,'{cr}','{Utente}') MSG "
                    + "FROM DUAL "
                    + "where '{MVEXE}'= 'SI' " );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( sesMVIDRIC.getObjectValue() == null ) sesMVIDRIC.setValue( null );
        command.addParameter( "MVIDRIC", sesMVIDRIC, null );
        if ( StringUtils.isEmpty( (String) postCr.getObjectValue() ) ) postCr.setValue( "" );
        command.addParameter( "cr", postCr, null );
        if ( StringUtils.isEmpty( (String) sesMVEXE.getObjectValue() ) ) sesMVEXE.setValue( "" );
        command.addParameter( "MVEXE", sesMVEXE, null );
        if ( sesMVIDPDRIC.getObjectValue() == null ) sesMVIDPDRIC.setValue( null );
        command.addParameter( "MVIDPDRIC", sesMVIDPDRIC, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT AMV_DOCUMENTO.CREA_RICHIESTA(decode({MVIDRIC} ,0,{MVIDPDRIC} ,{MVIDRIC} ) ,'{cr}','{Utente}') MSG FROM DUAL where '{MVEXE}'= 'SI'  ) cnt " );
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

//loadDataBind @29-E0E9BC68
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                INSERISCI_RICHIESTARow row = new INSERISCI_RICHIESTARow();
                DbRow record = (DbRow) records.nextElement();
                row.setMESSAGGIO(Utils.convertToString(ds.parse(record.get("MSG"), row.getMESSAGGIOField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @29-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @29-D73A36A8
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            if ( "MVIDRIC".equals(name) && "ses".equals(prefix) ) {
                param = sesMVIDRIC;
            } else if ( "MVIDRIC".equals(name) && prefix == null ) {
                param = sesMVIDRIC;
            }
            if ( "cr".equals(name) && "post".equals(prefix) ) {
                param = postCr;
            } else if ( "cr".equals(name) && prefix == null ) {
                param = postCr;
            }
            if ( "MVEXE".equals(name) && "ses".equals(prefix) ) {
                param = sesMVEXE;
            } else if ( "MVEXE".equals(name) && prefix == null ) {
                param = sesMVEXE;
            }
            if ( "MVIDPDRIC".equals(name) && "ses".equals(prefix) ) {
                param = sesMVIDPDRIC;
            } else if ( "MVIDPDRIC".equals(name) && prefix == null ) {
                param = sesMVIDPDRIC;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @29-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @29-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @29-238A81BB
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

//fireBeforeExecuteSelectEvent @29-9DA7B025
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

//fireAfterExecuteSelectEvent @29-F7E8A616
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

//class DataObject Tail @29-ED3F53A4
} // End of class DS
//End class DataObject Tail

