//AMV_GUIDE1 DataSource @19-0B1961D6
package amvadm.AdmGuide;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AMV_GUIDE1 DataSource

//class DataObject Header @19-325C29F2
public class AMV_GUIDE1DataObject extends DS {
//End class DataObject Header

//attributes of DataObject @19-88AC71B1
    

    TextField urlGuida = new TextField(null, null);
    
    LongField urlSeq = new LongField(null, null);
    

    private AMV_GUIDE1Row row = new AMV_GUIDE1Row();

//End attributes of DataObject

//properties of DataObject @19-FF12B0FC

    public void  setUrlGuida( String param ) {
        this.urlGuida.setValue( param );
    }

    public void  setUrlGuida( Object param ) {
        this.urlGuida.setValue( param );
    }

    public void  setUrlGuida( Object param, Format ignore ) {
        this.urlGuida.setValue( param );
    }

    public void  setUrlSeq( long param ) {
        this.urlSeq.setValue( param );
    }

    public void  setUrlSeq( long param, Format ignore ) throws java.text.ParseException {
        this.urlSeq.setValue( param );
    }

    public void  setUrlSeq( Object param, Format format ) throws java.text.ParseException {
        this.urlSeq.setValue( param, format );
    }

    public void  setUrlSeq( Long param ) {
        this.urlSeq.setValue( param );
    }

    public AMV_GUIDE1Row getRow() {
        return row;
    }

    public void setRow( AMV_GUIDE1Row row ) {
        this.row = row;
    }

//End properties of DataObject

//constructor @19-05273304
    public AMV_GUIDE1DataObject(Page page) {
        super(page);
    }
//End constructor

//load @19-6C7F801B
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT *  "
                    + "FROM AMV_GUIDE" );
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        }

        fireBeforeBuildSelectEvent( new DataObjectEvent(command) );

        String where1 = WhereParams.rawOperation( "GUIDA", FieldOperation.EQUAL, urlGuida, null, ds );
        String where2 = WhereParams.rawOperation( "SEQUENZA", FieldOperation.EQUAL, urlSeq, null, ds );
        String whereParams = WhereParams.and(false, where1, where2);

        if ( where1 == null || where2 == null ) {
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

//loadDataBind @19-ACF60D50
        if ( record == null || record.isEmpty() ) {
            empty = true;
        } else {
            row.setTITOLO(Utils.convertToString(ds.parse(record.get("TITOLO"), row.getTITOLOField())));
            row.setGUIDA(Utils.convertToString(ds.parse(record.get("GUIDA"), row.getGUIDAField())));
            row.setSEQUENZA(Utils.convertToString(ds.parse(record.get("SEQUENZA"), row.getSEQUENZAField())));
            row.setVOCE_MENU(Utils.convertToString(ds.parse(record.get("VOCE_MENU"), row.getVOCE_MENUField())));
            row.setALIAS(Utils.convertToString(ds.parse(record.get("ALIAS"), row.getALIASField())));
            row.setVOCE_RIF(Utils.convertToString(ds.parse(record.get("VOCE_RIF"), row.getVOCE_RIFField())));
        }
//End loadDataBind

//End of load @19-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//checkUnique @19-F426DDB2
    int checkUnique( VerifiableControl control ) {
        int result = -1;
        boolean isErrors = false;
        if ( StringUtils.isEmpty(control.toString()) ) return 0;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        String where1 = WhereParams.rawOperation( "GUIDA", FieldOperation.EQUAL, urlGuida, null, ds );
        String where2 = WhereParams.rawOperation( "SEQUENZA", FieldOperation.EQUAL, urlSeq, null, ds );
        String whereParams = WhereParams.and(false, where1, where2);

        command.setCountSql( "SELECT count(*) FROM AMV_GUIDE" );
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

//insert @19-4C25C93E
        boolean insert() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            command.setNeedQuotes(true);
            command.setSql("INSERT INTO AMV_GUIDE ( TITOLO, GUIDA, SEQUENZA, VOCE_MENU, ALIAS, VOCE_RIF ) VALUES ( {TITOLO}, {GUIDA}, {SEQUENZA}, {VOCE_MENU}, {ALIAS}, {VOCE_RIF} )");
            command.addParameter("TITOLO", row.getTITOLOField());
            command.addParameter("GUIDA", row.getGUIDAField());
            command.addParameter("SEQUENZA", row.getSEQUENZAField());
            command.addParameter("VOCE_MENU", row.getVOCE_MENUField());
            command.addParameter("ALIAS", row.getALIASField());
            command.addParameter("VOCE_RIF", row.getVOCE_RIFField());

            fireBeforeBuildInsertEvent( new DataObjectEvent(command) );

//End insert

//insertDataBound @19-BC781F8A
            fireBeforeExecuteInsertEvent( new DataObjectEvent(command) );

            if ( ! ds.hasErrors() ) {
                command.executeUpdate();
            }

            CCLogger.getInstance().debug(command.toString());

            fireAfterExecuteInsertEvent( new DataObjectEvent(command) );

//End insertDataBound

//End of insert @19-CDC5319F
            ds.closeConnection();
            isErrors = ds.hasErrors();
            if ( isErrors ) addErrors( ds.getErrors() );
            return ( ! isErrors );
        }
//End End of insert

//update @19-6BFAE546
        boolean update() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            command.setNeedQuotes(true);
            command.setSql("UPDATE AMV_GUIDE SET TITOLO = {TITOLO}, GUIDA = {GUIDA}, SEQUENZA = {SEQUENZA}, VOCE_MENU = {VOCE_MENU}, ALIAS = {ALIAS}, VOCE_RIF = {VOCE_RIF}");
            command.addParameter("TITOLO", row.getTITOLOField());
            command.addParameter("GUIDA", row.getGUIDAField());
            command.addParameter("SEQUENZA", row.getSEQUENZAField());
            command.addParameter("VOCE_MENU", row.getVOCE_MENUField());
            command.addParameter("ALIAS", row.getALIASField());
            command.addParameter("VOCE_RIF", row.getVOCE_RIFField());

            fireBeforeBuildUpdateEvent( new DataObjectEvent(command) );

            String where1 = WhereParams.rawOperation( "GUIDA", FieldOperation.EQUAL, urlGuida, null, ds );
            if (StringUtils.isEmpty(where1)) command.setCmdExecution(false);
            String where2 = WhereParams.rawOperation( "SEQUENZA", FieldOperation.EQUAL, urlSeq, null, ds );
            if (StringUtils.isEmpty(where2)) command.setCmdExecution(false);
            String whereParams = WhereParams.and(false, where1, where2);

            if ( where1 == null || where2 == null ) {
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

//updateDataBound @19-35E17193
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

//End of update @19-CDC5319F
            ds.closeConnection();
            isErrors = ds.hasErrors();
            if ( isErrors ) addErrors( ds.getErrors() );
            return ( ! isErrors );
        }
//End End of update

//delete @19-BB67A37D
        boolean delete() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            command.setNeedQuotes(true);
            command.setSql("DELETE FROM AMV_GUIDE");

            fireBeforeBuildDeleteEvent( new DataObjectEvent(command) );

            String where1 = WhereParams.rawOperation( "GUIDA", FieldOperation.EQUAL, urlGuida, null, ds );
            if (StringUtils.isEmpty(where1)) command.setCmdExecution(false);
            String where2 = WhereParams.rawOperation( "SEQUENZA", FieldOperation.EQUAL, urlSeq, null, ds );
            if (StringUtils.isEmpty(where2)) command.setCmdExecution(false);
            String whereParams = WhereParams.and(false, where1, where2);

            if ( where1 == null || where2 == null ) {
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

//deleteDataBound @19-5B959F17
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

//End of delete @19-CDC5319F
            ds.closeConnection();
            isErrors = ds.hasErrors();
            if ( isErrors ) addErrors( ds.getErrors() );
            return ( ! isErrors );
        }
//End End of delete

//getParameterByName @19-6E054091
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "guida".equals(name) && "url".equals(prefix) ) {
                param = urlGuida;
            } else if ( "guida".equals(name) && prefix == null ) {
                param = urlGuida;
            }
            if ( "seq".equals(name) && "url".equals(prefix) ) {
                param = urlSeq;
            } else if ( "seq".equals(name) && prefix == null ) {
                param = urlSeq;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addRecordDataObjectListener @19-47141785
    public synchronized void addRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.addElement(l);
    }
//End addRecordDataObjectListener

//removeRecordDataObjectListener @19-A1ABC1F4
    public synchronized void removeRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeRecordDataObjectListener

//fireBeforeBuildSelectEvent @19-305A023C
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

//fireBeforeExecuteSelectEvent @19-D00ACF95
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

//fireAfterExecuteSelectEvent @19-3BAD39CE
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

//fireBeforeBuildInsertEvent @19-FBA08B71
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

//fireBeforeExecuteInsertEvent @19-47AFA6A5
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

//fireAfterExecuteInsertEvent @19-E9CE95AE
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

//fireBeforeBuildSelectEvent @19-2405BE8B
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

//fireBeforeExecuteSelectEvent @19-E9DFF86B
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

//fireAfterExecuteSelectEvent @19-580A2987
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

//fireBeforeBuildSelectEvent @19-D021D0EA
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

//fireBeforeExecuteDeleteEvent @19-DD540FBB
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

//fireAfterExecuteDeleteEvent @19-2A6E2049
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

//class DataObject Tail @19-ED3F53A4
} // End of class DS
//End class DataObject Tail

