//AMV_TIPOLOGIE_RECORD DataSource @22-1D4F3DE8
package amvadm.AdmTipologie;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AMV_TIPOLOGIE_RECORD DataSource

//class DataObject Header @22-98F3C1E6
public class AMV_TIPOLOGIE_RECORDDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @22-ABE27AB5
    

    LongField urlID = new LongField(null, null);
    

    private AMV_TIPOLOGIE_RECORDRow row = new AMV_TIPOLOGIE_RECORDRow();

//End attributes of DataObject

//properties of DataObject @22-EBD9E8C7

    public void  setUrlID( long param ) {
        this.urlID.setValue( param );
    }

    public void  setUrlID( long param, Format ignore ) throws java.text.ParseException {
        this.urlID.setValue( param );
    }

    public void  setUrlID( Object param, Format format ) throws java.text.ParseException {
        this.urlID.setValue( param, format );
    }

    public void  setUrlID( Long param ) {
        this.urlID.setValue( param );
    }

    public AMV_TIPOLOGIE_RECORDRow getRow() {
        return row;
    }

    public void setRow( AMV_TIPOLOGIE_RECORDRow row ) {
        this.row = row;
    }

//End properties of DataObject

//constructor @22-08BF5C0F
    public AMV_TIPOLOGIE_RECORDDataObject(Page page) {
        super(page);
    }
//End constructor

//load @22-4C18C693
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT *  "
                    + "FROM AMV_TIPOLOGIE" );
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        }

        fireBeforeBuildSelectEvent( new DataObjectEvent(command) );

        String where1 = WhereParams.rawOperation( "ID_TIPOLOGIA", FieldOperation.EQUAL, urlID, null, ds );
        String whereParams = where1;

        if ( where1 == null ) {
            empty = true;
            ds.closeConnection();
            return true;
        }
        if ( ! StringUtils.isEmpty(whereParams) ) {
            if ( ! StringUtils.isEmpty(command.getWhere()) ) {
                command.setWhere( command.getWhere() + " AND (" + whereParams + ")" );
            } else {
                command.setWhere( whereParams );
            }
        }

        fireBeforeExecuteSelectEvent( new DataObjectEvent(command) );

        DbRow record = null;
        if ( ! ds.hasErrors() ) {
            record = command.getOneRow();
        }

        CCLogger.getInstance().debug(command.toString());

        fireAfterExecuteSelectEvent( new DataObjectEvent(command) );

        ds.closeConnection();
//End load

//loadDataBind @22-E7C553BF
        if ( record == null || record.isEmpty() ) {
            empty = true;
        } else {
            row.setNOME(Utils.convertToString(ds.parse(record.get("NOME"), row.getNOMEField())));
            row.setDESCRIZIONE(Utils.convertToString(ds.parse(record.get("DESCRIZIONE"), row.getDESCRIZIONEField())));
            row.setSEQUENZA(Utils.convertToLong(ds.parse(record.get("SEQUENZA"), row.getSEQUENZAField())));
            row.setLINK(Utils.convertToString(ds.parse(record.get("LINK"), row.getLINKField())));
            row.setZONA(Utils.convertToString(ds.parse(record.get("ZONA"), row.getZONAField())));
            row.setZONA_VISIBILITA(Utils.convertToString(ds.parse(record.get("ZONA_VISIBILITA"), row.getZONA_VISIBILITAField())));
            row.setZONA_FORMATO(Utils.convertToString(ds.parse(record.get("ZONA_FORMATO"), row.getZONA_FORMATOField())));
            row.setIMMAGINE(Utils.convertToString(ds.parse(record.get("IMMAGINE"), row.getIMMAGINEField())));
            row.setMAX_VIS(Utils.convertToLong(ds.parse(record.get("MAX_VIS"), row.getMAX_VISField())));
            row.setICONA(Utils.convertToString(ds.parse(record.get("ICONA"), row.getICONAField())));
            row.setID_TIPOLOGIA(Utils.convertToLong(ds.parse(record.get("ID_TIPOLOGIA"), row.getID_TIPOLOGIAField())));
        }
//End loadDataBind

//End of load @22-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//checkUnique @22-C7628373
    int checkUnique( VerifiableControl control ) {
        int result = -1;
        boolean isErrors = false;
        if ( StringUtils.isEmpty(control.toString()) ) return 0;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        String where1 = WhereParams.rawOperation( "ID_TIPOLOGIA", FieldOperation.EQUAL, urlID, null, ds );
        String whereParams = where1;

        command.setCountSql( "SELECT count(*) FROM AMV_TIPOLOGIE" );
        where = new StringBuffer( control.getFieldSource() + " = " + ds.toSql( ds.format( control ), control.getType() ) );
        if ( ! StringUtils.isEmpty(whereParams) ) {
            where.append( " AND NOT ( " + whereParams + ")");
        }
        command.setWhere(where.toString());
        result = command.count();
        ds.closeConnection();
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        if ( isErrors ) result = -1;
        return result;
    }
//End checkUnique

//insert @22-725D7022
        boolean insert() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            command.setNeedQuotes(true);
            command.setSql("INSERT INTO AMV_TIPOLOGIE ( NOME, DESCRIZIONE, SEQUENZA, LINK, ZONA, ZONA_VISIBILITA, ZONA_FORMATO, IMMAGINE, MAX_VIS, ICONA, ID_TIPOLOGIA ) VALUES ( {NOME}, {DESCRIZIONE}, {SEQUENZA}, {LINK}, {ZONA}, {ZONA_VISIBILITA}, {ZONA_FORMATO}, {IMMAGINE}, {MAX_VIS}, {ICONA}, {ID_TIPOLOGIA} )");
            command.addParameter("NOME", row.getNOMEField());
            command.addParameter("DESCRIZIONE", row.getDESCRIZIONEField());
            command.addParameter("SEQUENZA", row.getSEQUENZAField());
            command.addParameter("LINK", row.getLINKField());
            command.addParameter("ZONA", row.getZONAField());
            command.addParameter("ZONA_VISIBILITA", row.getZONA_VISIBILITAField());
            command.addParameter("ZONA_FORMATO", row.getZONA_FORMATOField());
            command.addParameter("IMMAGINE", row.getIMMAGINEField());
            command.addParameter("MAX_VIS", row.getMAX_VISField());
            command.addParameter("ICONA", row.getICONAField());
            command.addParameter("ID_TIPOLOGIA", row.getID_TIPOLOGIAField());

            fireBeforeBuildInsertEvent( new DataObjectEvent(command) );

//End insert

//insertDataBound @22-BC781F8A
            fireBeforeExecuteInsertEvent( new DataObjectEvent(command) );

            if ( ! ds.hasErrors() ) {
                command.executeUpdate();
            }

            CCLogger.getInstance().debug(command.toString());

            fireAfterExecuteInsertEvent( new DataObjectEvent(command) );

//End insertDataBound

//End of insert @22-CDC5319F
            ds.closeConnection();
            isErrors = ds.hasErrors();
            if ( isErrors ) addErrors( ds.getErrors() );
            return ( ! isErrors );
        }
//End End of insert

//update @22-9162F191
        boolean update() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            command.setNeedQuotes(true);
            command.setSql("UPDATE AMV_TIPOLOGIE SET NOME = {NOME}, DESCRIZIONE = {DESCRIZIONE}, SEQUENZA = {SEQUENZA}, LINK = {LINK}, ZONA = {ZONA}, ZONA_VISIBILITA = {ZONA_VISIBILITA}, ZONA_FORMATO = {ZONA_FORMATO}, IMMAGINE = {IMMAGINE}, MAX_VIS = {MAX_VIS}, ICONA = {ICONA}, ID_TIPOLOGIA = {ID_TIPOLOGIA}");
            command.addParameter("NOME", row.getNOMEField());
            command.addParameter("DESCRIZIONE", row.getDESCRIZIONEField());
            command.addParameter("SEQUENZA", row.getSEQUENZAField());
            command.addParameter("LINK", row.getLINKField());
            command.addParameter("ZONA", row.getZONAField());
            command.addParameter("ZONA_VISIBILITA", row.getZONA_VISIBILITAField());
            command.addParameter("ZONA_FORMATO", row.getZONA_FORMATOField());
            command.addParameter("IMMAGINE", row.getIMMAGINEField());
            command.addParameter("MAX_VIS", row.getMAX_VISField());
            command.addParameter("ICONA", row.getICONAField());
            command.addParameter("ID_TIPOLOGIA", row.getID_TIPOLOGIAField());

            fireBeforeBuildUpdateEvent( new DataObjectEvent(command) );

            String where1 = WhereParams.rawOperation( "ID_TIPOLOGIA", FieldOperation.EQUAL, urlID, null, ds );
            if (StringUtils.isEmpty(where1)) command.setCmdExecution(false);
            String whereParams = where1;

            if ( where1 == null ) {
                addError(getResourceBundle().getString("CustomOperationError_MissingParameters"));
            }
            if ( ! StringUtils.isEmpty(whereParams) ) {
                if ( ! StringUtils.isEmpty(command.getWhere()) ) {
                    command.setWhere( command.getWhere() + " AND (" + whereParams + ")" );
                } else {
                    command.setWhere( whereParams );
                }
            }

//End update

//updateDataBound @22-35E17193
            fireBeforeExecuteUpdateEvent( new DataObjectEvent(command) );
            if (!command.isCmdExecution()) {
                ds.closeConnection();
                return false;
            }

            if ( ! ds.hasErrors() ) {
                command.executeUpdate();
            }

            CCLogger.getInstance().debug(command.toString());

            fireAfterExecuteUpdateEvent( new DataObjectEvent(command) );

//End updateDataBound

//End of update @22-CDC5319F
            ds.closeConnection();
            isErrors = ds.hasErrors();
            if ( isErrors ) addErrors( ds.getErrors() );
            return ( ! isErrors );
        }
//End End of update

//delete @22-5F5CD7B9
        boolean delete() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            command.setNeedQuotes(true);
            command.setSql("DELETE FROM AMV_TIPOLOGIE");

            fireBeforeBuildDeleteEvent( new DataObjectEvent(command) );

            String where1 = WhereParams.rawOperation( "ID_TIPOLOGIA", FieldOperation.EQUAL, urlID, null, ds );
            if (StringUtils.isEmpty(where1)) command.setCmdExecution(false);
            String whereParams = where1;

            if ( where1 == null ) {
                addError(getResourceBundle().getString("CustomOperationError_MissingParameters"));
            }
            if ( ! StringUtils.isEmpty(whereParams) ) {
                if ( ! StringUtils.isEmpty(command.getWhere()) ) {
                    command.setWhere( command.getWhere() + " AND (" + whereParams + ")" );
                } else {
                    command.setWhere( whereParams );
                }
            }

//End delete

//deleteDataBound @22-5B959F17
            fireBeforeExecuteDeleteEvent( new DataObjectEvent(command) );
            if (!command.isCmdExecution()) {
                ds.closeConnection();
                return false;
            }

            if ( ! ds.hasErrors() ) {
                command.executeUpdate();
            }

            CCLogger.getInstance().debug(command.toString());

            fireAfterExecuteDeleteEvent( new DataObjectEvent(command) );

//End deleteDataBound

//End of delete @22-CDC5319F
            ds.closeConnection();
            isErrors = ds.hasErrors();
            if ( isErrors ) addErrors( ds.getErrors() );
            return ( ! isErrors );
        }
//End End of delete

//getParameterByName @22-1BE048C3
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "ID".equals(name) && "url".equals(prefix) ) {
                param = urlID;
            } else if ( "ID".equals(name) && prefix == null ) {
                param = urlID;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addRecordDataObjectListener @22-47141785
    public synchronized void addRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.addElement(l);
    }
//End addRecordDataObjectListener

//removeRecordDataObjectListener @22-A1ABC1F4
    public synchronized void removeRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeRecordDataObjectListener

//fireBeforeBuildSelectEvent @22-305A023C
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

//fireBeforeExecuteSelectEvent @22-D00ACF95
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

//fireAfterExecuteSelectEvent @22-3BAD39CE
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

//fireBeforeBuildInsertEvent @22-FBA08B71
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

//fireBeforeExecuteInsertEvent @22-47AFA6A5
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

//fireAfterExecuteInsertEvent @22-E9CE95AE
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

//fireBeforeBuildSelectEvent @22-2405BE8B
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

//fireBeforeExecuteSelectEvent @22-E9DFF86B
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

//fireAfterExecuteSelectEvent @22-580A2987
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

//fireBeforeBuildSelectEvent @22-D021D0EA
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

//fireBeforeExecuteDeleteEvent @22-DD540FBB
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

//fireAfterExecuteDeleteEvent @22-2A6E2049
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

//class DataObject Tail @22-ED3F53A4
} // End of class DS
//End class DataObject Tail

