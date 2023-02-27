/******************************************************************************
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
  1   05/02/2003   AO   Gestione parametri di output della procedure in Insert
  2   12/01/2004   AO   Revisione per CCS2.2.3
******************************************************************************/
//AD4_UTENTE DataSource @50-861B0D00
package common.AmvRegistrazioneInizio;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AD4_UTENTE DataSource

//class DataObject Header @50-6F70C966
public class AD4_UTENTEDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @50-7FBD9EA6
    

    TextField postNOMINATIVO = new TextField(null, null);
    
    TextField postCOGNOME = new TextField(null, null);
    
    TextField postNOME = new TextField(null, null);
    
    TextField postCODICE_FISCALE = new TextField(null, null);
    
    DoubleField postCOMUNE = new DoubleField(null, null);
    
    DoubleField postPROVINCIA = new DoubleField(null, null);
    
    TextField postCAP = new TextField(null, null);
    
    TextField postVIA = new TextField(null, null);
    
    TextField postINDIRIZZO = new TextField(null, null);
    
    TextField postNUMERO = new TextField(null, null);
    
    DoubleField postCOMUNE_NASCITA = new DoubleField(null, null);
    
    DoubleField postPROVINCIA_NASCITA = new DoubleField(null, null);
    
    TextField postDATA_NASCITA = new TextField(null, null);
    
    TextField postSESSO = new TextField(null, null);
    

    private AD4_UTENTERow row = new AD4_UTENTERow();

//End attributes of DataObject

//properties of DataObject @50-AB1D93C7

    public void  setPostNOMINATIVO( String param ) {
        this.postNOMINATIVO.setValue( param );
    }

    public void  setPostNOMINATIVO( Object param ) {
        this.postNOMINATIVO.setValue( param );
    }

    public void  setPostNOMINATIVO( Object param, Format ignore ) {
        this.postNOMINATIVO.setValue( param );
    }

    public void  setPostCOGNOME( String param ) {
        this.postCOGNOME.setValue( param );
    }

    public void  setPostCOGNOME( Object param ) {
        this.postCOGNOME.setValue( param );
    }

    public void  setPostCOGNOME( Object param, Format ignore ) {
        this.postCOGNOME.setValue( param );
    }

    public void  setPostNOME( String param ) {
        this.postNOME.setValue( param );
    }

    public void  setPostNOME( Object param ) {
        this.postNOME.setValue( param );
    }

    public void  setPostNOME( Object param, Format ignore ) {
        this.postNOME.setValue( param );
    }

    public void  setPostCODICE_FISCALE( String param ) {
        this.postCODICE_FISCALE.setValue( param );
    }

    public void  setPostCODICE_FISCALE( Object param ) {
        this.postCODICE_FISCALE.setValue( param );
    }

    public void  setPostCODICE_FISCALE( Object param, Format ignore ) {
        this.postCODICE_FISCALE.setValue( param );
    }

    public void  setPostCOMUNE( double param ) {
        this.postCOMUNE.setValue( param );
    }

    public void  setPostCOMUNE( double param, Format ignore ) throws java.text.ParseException {
        this.postCOMUNE.setValue( param );
    }

    public void  setPostCOMUNE( Object param, Format format ) throws java.text.ParseException {
        this.postCOMUNE.setValue( param, format );
    }

    public void  setPostCOMUNE( Double param ) {
        this.postCOMUNE.setValue( param );
    }

    public void  setPostPROVINCIA( double param ) {
        this.postPROVINCIA.setValue( param );
    }

    public void  setPostPROVINCIA( double param, Format ignore ) throws java.text.ParseException {
        this.postPROVINCIA.setValue( param );
    }

    public void  setPostPROVINCIA( Object param, Format format ) throws java.text.ParseException {
        this.postPROVINCIA.setValue( param, format );
    }

    public void  setPostPROVINCIA( Double param ) {
        this.postPROVINCIA.setValue( param );
    }

    public void  setPostCAP( String param ) {
        this.postCAP.setValue( param );
    }

    public void  setPostCAP( Object param ) {
        this.postCAP.setValue( param );
    }

    public void  setPostCAP( Object param, Format ignore ) {
        this.postCAP.setValue( param );
    }

    public void  setPostVIA( String param ) {
        this.postVIA.setValue( param );
    }

    public void  setPostVIA( Object param ) {
        this.postVIA.setValue( param );
    }

    public void  setPostVIA( Object param, Format ignore ) {
        this.postVIA.setValue( param );
    }

    public void  setPostINDIRIZZO( String param ) {
        this.postINDIRIZZO.setValue( param );
    }

    public void  setPostINDIRIZZO( Object param ) {
        this.postINDIRIZZO.setValue( param );
    }

    public void  setPostINDIRIZZO( Object param, Format ignore ) {
        this.postINDIRIZZO.setValue( param );
    }

    public void  setPostNUMERO( String param ) {
        this.postNUMERO.setValue( param );
    }

    public void  setPostNUMERO( Object param ) {
        this.postNUMERO.setValue( param );
    }

    public void  setPostNUMERO( Object param, Format ignore ) {
        this.postNUMERO.setValue( param );
    }

    public void  setPostCOMUNE_NASCITA( double param ) {
        this.postCOMUNE_NASCITA.setValue( param );
    }

    public void  setPostCOMUNE_NASCITA( double param, Format ignore ) throws java.text.ParseException {
        this.postCOMUNE_NASCITA.setValue( param );
    }

    public void  setPostCOMUNE_NASCITA( Object param, Format format ) throws java.text.ParseException {
        this.postCOMUNE_NASCITA.setValue( param, format );
    }

    public void  setPostCOMUNE_NASCITA( Double param ) {
        this.postCOMUNE_NASCITA.setValue( param );
    }

    public void  setPostPROVINCIA_NASCITA( double param ) {
        this.postPROVINCIA_NASCITA.setValue( param );
    }

    public void  setPostPROVINCIA_NASCITA( double param, Format ignore ) throws java.text.ParseException {
        this.postPROVINCIA_NASCITA.setValue( param );
    }

    public void  setPostPROVINCIA_NASCITA( Object param, Format format ) throws java.text.ParseException {
        this.postPROVINCIA_NASCITA.setValue( param, format );
    }

    public void  setPostPROVINCIA_NASCITA( Double param ) {
        this.postPROVINCIA_NASCITA.setValue( param );
    }

    public void  setPostDATA_NASCITA( String param ) {
        this.postDATA_NASCITA.setValue( param );
    }

    public void  setPostDATA_NASCITA( Object param ) {
        this.postDATA_NASCITA.setValue( param );
    }

    public void  setPostDATA_NASCITA( Object param, Format ignore ) {
        this.postDATA_NASCITA.setValue( param );
    }

    public void  setPostSESSO( String param ) {
        this.postSESSO.setValue( param );
    }

    public void  setPostSESSO( Object param ) {
        this.postSESSO.setValue( param );
    }

    public void  setPostSESSO( Object param, Format ignore ) {
        this.postSESSO.setValue( param );
    }

    public AD4_UTENTERow getRow() {
        return row;
    }

    public void setRow( AD4_UTENTERow row ) {
        this.row = row;
    }

//End properties of DataObject

//constructor @50-F9C29682
    public AD4_UTENTEDataObject(Page page) {
        super(page);
    }
//End constructor

//load @50-E30F9D9A
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select '' dummy from dual where 1=2" );
        if ( ! command.isSetAllParams() ) {
            empty = true;
            ds.closeConnection();
            return true;
        }
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        }

        fireBeforeBuildSelectEvent( new DataObjectEvent(command) );


        fireBeforeExecuteSelectEvent( new DataObjectEvent(command) );

        DbRow record = null;
        if ( ! ds.hasErrors() ) {
            record = command.getOneRow();
        }

        CCLogger.getInstance().debug(command.toString());

        fireAfterExecuteSelectEvent( new DataObjectEvent(command) );

        ds.closeConnection();
//End load

//loadDataBind @50-3235E50D
        if ( record == null || record.isEmpty() ) {
            empty = true;
        } else {
        }
//End loadDataBind

//End of load @50-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//Rev.1 : gestione parametri output della procedure custom AFC 
//insert @50-7899A9CD
        Collection insert() {	//custom AFC
        //boolean insert() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            SPCommand command = SPCommandFactory.getSPCommand( "cn" );
            command.setJdbcConnection( ds );

            command.setSql( "{ call AMV_UTENTE.REGISTRA_UTENTE ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ) }" );
            command.addParameter( "P_UTENTE", null, java.sql.Types.CHAR, 0, SPParameter.OUTPUT_PARAMETER );
            command.addParameter( "P_MEZZA_PASSWORD", null, java.sql.Types.CHAR, 0, SPParameter.OUTPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postNOMINATIVO.getObjectValue() ) ) postNOMINATIVO.setValue( "" );
            command.addParameter( "P_NOMINATIVO", postNOMINATIVO, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postCOGNOME.getObjectValue() ) ) postCOGNOME.setValue( "" );
            command.addParameter( "P_COGNOME", postCOGNOME, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postNOME.getObjectValue() ) ) postNOME.setValue( "" );
            command.addParameter( "P_NOME", postNOME, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postCODICE_FISCALE.getObjectValue() ) ) postCODICE_FISCALE.setValue( "" );
            command.addParameter( "P_CODICE_FISCALE", postCODICE_FISCALE, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_COMUNE", postCOMUNE, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_OUTPUT_PARAMETER );
            command.addParameter( "P_PROVINCIA", postPROVINCIA, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_OUTPUT_PARAMETER );
            if ( postCAP.getObjectValue() == null ) postCAP.setValue( "" );
            command.addParameter( "P_CAP", postCAP, java.sql.Types.CHAR, 0, SPParameter.INPUT_OUTPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postVIA.getObjectValue() ) ) postVIA.setValue( "" );
            command.addParameter( "P_VIA", postVIA, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postINDIRIZZO.getObjectValue() ) ) postINDIRIZZO.setValue( "" );
            command.addParameter( "P_INDIRIZZO", postINDIRIZZO, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postNUMERO.getObjectValue() ) ) postNUMERO.setValue( "" );
            command.addParameter( "P_NUMERO", postNUMERO, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_COMUNE_NAS", postCOMUNE_NASCITA, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_PROVINCIA_NAS", postPROVINCIA_NASCITA, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postDATA_NASCITA.getObjectValue() ) ) postDATA_NASCITA.setValue( "" );
            command.addParameter( "P_DATA_NASCITA", postDATA_NASCITA, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postSESSO.getObjectValue() ) ) postSESSO.setValue( "" );
            command.addParameter( "P_SESSO", postSESSO, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );

            fireBeforeBuildInsertEvent( new DataObjectEvent(command) );

//End insert
            Collection cParam = null;	//custom AFC
//insertDataBound @50-BC781F8A
            fireBeforeExecuteInsertEvent( new DataObjectEvent(command) );

            if ( ! ds.hasErrors() ) {
                command.executeUpdate();
				cParam = command.getParameters();  //custom AFC 
	  			Object params[] = cParam.toArray();

            }

            CCLogger.getInstance().debug(command.toString());

            fireAfterExecuteInsertEvent( new DataObjectEvent(command) );

//End insertDataBound

//End of insert @50-CDC5319F
            ds.closeConnection();
            isErrors = ds.hasErrors();
            if ( isErrors ) addErrors( ds.getErrors() );
            //return ( ! isErrors );
			return cParam;		//custom AFC 
        }
//End End of insert

//getParameterByName @50-32F2CD31
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "NOMINATIVO".equals(name) && "post".equals(prefix) ) {
                param = postNOMINATIVO;
            } else if ( "NOMINATIVO".equals(name) && prefix == null ) {
                param = postNOMINATIVO;
            }
            if ( "COGNOME".equals(name) && "post".equals(prefix) ) {
                param = postCOGNOME;
            } else if ( "COGNOME".equals(name) && prefix == null ) {
                param = postCOGNOME;
            }
            if ( "NOME".equals(name) && "post".equals(prefix) ) {
                param = postNOME;
            } else if ( "NOME".equals(name) && prefix == null ) {
                param = postNOME;
            }
            if ( "CODICE_FISCALE".equals(name) && "post".equals(prefix) ) {
                param = postCODICE_FISCALE;
            } else if ( "CODICE_FISCALE".equals(name) && prefix == null ) {
                param = postCODICE_FISCALE;
            }
            if ( "COMUNE".equals(name) && "post".equals(prefix) ) {
                param = postCOMUNE;
            } else if ( "COMUNE".equals(name) && prefix == null ) {
                param = postCOMUNE;
            }
            if ( "PROVINCIA".equals(name) && "post".equals(prefix) ) {
                param = postPROVINCIA;
            } else if ( "PROVINCIA".equals(name) && prefix == null ) {
                param = postPROVINCIA;
            }
            if ( "CAP".equals(name) && "post".equals(prefix) ) {
                param = postCAP;
            } else if ( "CAP".equals(name) && prefix == null ) {
                param = postCAP;
            }
            if ( "VIA".equals(name) && "post".equals(prefix) ) {
                param = postVIA;
            } else if ( "VIA".equals(name) && prefix == null ) {
                param = postVIA;
            }
            if ( "INDIRIZZO".equals(name) && "post".equals(prefix) ) {
                param = postINDIRIZZO;
            } else if ( "INDIRIZZO".equals(name) && prefix == null ) {
                param = postINDIRIZZO;
            }
            if ( "NUMERO".equals(name) && "post".equals(prefix) ) {
                param = postNUMERO;
            } else if ( "NUMERO".equals(name) && prefix == null ) {
                param = postNUMERO;
            }
            if ( "COMUNE_NASCITA".equals(name) && "post".equals(prefix) ) {
                param = postCOMUNE_NASCITA;
            } else if ( "COMUNE_NASCITA".equals(name) && prefix == null ) {
                param = postCOMUNE_NASCITA;
            }
            if ( "PROVINCIA_NASCITA".equals(name) && "post".equals(prefix) ) {
                param = postPROVINCIA_NASCITA;
            } else if ( "PROVINCIA_NASCITA".equals(name) && prefix == null ) {
                param = postPROVINCIA_NASCITA;
            }
            if ( "DATA_NASCITA".equals(name) && "post".equals(prefix) ) {
                param = postDATA_NASCITA;
            } else if ( "DATA_NASCITA".equals(name) && prefix == null ) {
                param = postDATA_NASCITA;
            }
            if ( "SESSO".equals(name) && "post".equals(prefix) ) {
                param = postSESSO;
            } else if ( "SESSO".equals(name) && prefix == null ) {
                param = postSESSO;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addRecordDataObjectListener @50-47141785
    public synchronized void addRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.addElement(l);
    }
//End addRecordDataObjectListener

//removeRecordDataObjectListener @50-A1ABC1F4
    public synchronized void removeRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeRecordDataObjectListener

//fireBeforeBuildSelectEvent @50-305A023C
    public void fireBeforeBuildSelectEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeBuildSelect(e);
        }
    }
//End fireBeforeBuildSelectEvent

//fireBeforeExecuteSelectEvent @50-D00ACF95
    public void fireBeforeExecuteSelectEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeExecuteSelect(e);
        }
    }
//End fireBeforeExecuteSelectEvent

//fireAfterExecuteSelectEvent @50-3BAD39CE
    public void fireAfterExecuteSelectEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).afterExecuteSelect(e);
        }
    }
//End fireAfterExecuteSelectEvent

//fireBeforeBuildInsertEvent @50-FBA08B71
    public void fireBeforeBuildInsertEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeBuildInsert(e);
        }
    }
//End fireBeforeBuildInsertEvent

//fireBeforeExecuteInsertEvent @50-47AFA6A5
    public void fireBeforeExecuteInsertEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeExecuteInsert(e);
        }
    }
//End fireBeforeExecuteInsertEvent

//fireAfterExecuteInsertEvent @50-E9CE95AE
    public void fireAfterExecuteInsertEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).afterExecuteInsert(e);
        }
    }
//End fireAfterExecuteInsertEvent

//fireBeforeBuildSelectEvent @50-2405BE8B
    public void fireBeforeBuildUpdateEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeBuildUpdate(e);
        }
    }
//End fireBeforeBuildSelectEvent

//fireBeforeExecuteSelectEvent @50-E9DFF86B
    public void fireBeforeExecuteUpdateEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeExecuteUpdate(e);
        }
    }
//End fireBeforeExecuteSelectEvent

//fireAfterExecuteSelectEvent @50-580A2987
    public void fireAfterExecuteUpdateEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).afterExecuteUpdate(e);
        }
    }
//End fireAfterExecuteSelectEvent

//fireBeforeBuildSelectEvent @50-D021D0EA
    public void fireBeforeBuildDeleteEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeBuildDelete(e);
        }
    }
//End fireBeforeBuildSelectEvent

//fireBeforeExecuteDeleteEvent @50-DD540FBB
    public void fireBeforeExecuteDeleteEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeExecuteDelete(e);
        }
    }
//End fireBeforeExecuteDeleteEvent

//fireAfterExecuteDeleteEvent @50-2A6E2049
    public void fireAfterExecuteDeleteEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).afterExecuteDelete(e);
        }
    }
//End fireAfterExecuteDeleteEvent

//class DataObject Tail @50-ED3F53A4
} // End of class DS
//End class DataObject Tail

