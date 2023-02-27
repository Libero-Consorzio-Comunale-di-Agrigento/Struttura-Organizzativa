//AMV_SEZIONE_RECORD DataSource @2-24485382
package amvadm.AdmSezione;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AMV_SEZIONE_RECORD DataSource

//class DataObject Header @2-2E232609
public class AMV_SEZIONE_RECORDDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @2-13F8E779
    

    LongField urlSZ = new LongField(null, null);
    
    LongField expr32 = new LongField(null, null);
    

    private AMV_SEZIONE_RECORDRow row = new AMV_SEZIONE_RECORDRow();

//End attributes of DataObject

//properties of DataObject @2-860EA68E

    public void  setUrlSZ( long param ) {
        this.urlSZ.setValue( param );
    }

    public void  setUrlSZ( long param, Format ignore ) throws java.text.ParseException {
        this.urlSZ.setValue( param );
    }

    public void  setUrlSZ( Object param, Format format ) throws java.text.ParseException {
        this.urlSZ.setValue( param, format );
    }

    public void  setUrlSZ( Long param ) {
        this.urlSZ.setValue( param );
    }

    public void  setExpr32( long param ) {
        this.expr32.setValue( param );
    }

    public void  setExpr32( long param, Format ignore ) throws java.text.ParseException {
        this.expr32.setValue( param );
    }

    public void  setExpr32( Object param, Format format ) throws java.text.ParseException {
        this.expr32.setValue( param, format );
    }

    public void  setExpr32( Long param ) {
        this.expr32.setValue( param );
    }

    public AMV_SEZIONE_RECORDRow getRow() {
        return row;
    }

    public void setRow( AMV_SEZIONE_RECORDRow row ) {
        this.row = row;
    }

//End properties of DataObject

//constructor @2-3D903C09
    public AMV_SEZIONE_RECORDDataObject(Page page) {
        super(page);
    }
//End constructor

//load @2-004FE1AD
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT *  "
                    + "FROM AMV_SEZIONI" );
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        }

        fireBeforeBuildSelectEvent( new DataObjectEvent(command) );

        if ( urlSZ.getObjectValue() == null ) urlSZ.setValue( 0 );
        String where1 = WhereParams.rawOperation( "ID_SEZIONE", FieldOperation.EQUAL, urlSZ, null, ds );
        String where2 = WhereParams.rawOperation( "ID_SEZIONE", FieldOperation.NOT_EQUAL, expr32, null, ds );
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

//loadDataBind @2-73DD4DB2
        if ( record == null || record.isEmpty() ) {
            empty = true;
        } else {
            row.setNOME(Utils.convertToString(ds.parse(record.get("NOME"), row.getNOMEField())));
            row.setDESCRIZIONE(Utils.convertToString(ds.parse(record.get("DESCRIZIONE"), row.getDESCRIZIONEField())));
            row.setID_PADRE(Utils.convertToString(ds.parse(record.get("ID_PADRE"), row.getID_PADREField())));
            row.setSEQUENZA(Utils.convertToLong(ds.parse(record.get("SEQUENZA"), row.getSEQUENZAField())));
            row.setID_AREA(Utils.convertToLong(ds.parse(record.get("ID_AREA"), row.getID_AREAField())));
            row.setVISIBILITA(Utils.convertToString(ds.parse(record.get("VISIBILITA"), row.getVISIBILITAField())));
            row.setZONA_ESPANSIONE(Utils.convertToString(ds.parse(record.get("ZONA_ESPANSIONE"), row.getZONA_ESPANSIONEField())));
            row.setZONA_TIPO(Utils.convertToString(ds.parse(record.get("ZONA_TIPO"), row.getZONA_TIPOField())));
            row.setZONA(Utils.convertToString(ds.parse(record.get("ZONA"), row.getZONAField())));
            row.setZONA_VISIBILITA(Utils.convertToString(ds.parse(record.get("ZONA_VISIBILITA"), row.getZONA_VISIBILITAField())));
            row.setZONA_FORMATO(Utils.convertToString(ds.parse(record.get("ZONA_FORMATO"), row.getZONA_FORMATOField())));
            row.setIMMAGINE(Utils.convertToString(ds.parse(record.get("IMMAGINE"), row.getIMMAGINEField())));
            row.setMAX_VIS(Utils.convertToLong(ds.parse(record.get("MAX_VIS"), row.getMAX_VISField())));
            row.setICONA(Utils.convertToString(ds.parse(record.get("ICONA"), row.getICONAField())));
            row.setINTESTAZIONE(Utils.convertToString(ds.parse(record.get("INTESTAZIONE"), row.getINTESTAZIONEField())));
            row.setLOGO_SX(Utils.convertToString(ds.parse(record.get("LOGO_SX"), row.getLOGO_SXField())));
            row.setLOGO_SX_LINK(Utils.convertToString(ds.parse(record.get("LOGO_SX_LINK"), row.getLOGO_SX_LINKField())));
            row.setLOGO_DX(Utils.convertToString(ds.parse(record.get("LOGO_DX"), row.getLOGO_DXField())));
            row.setLOGO_DX_LINK(Utils.convertToString(ds.parse(record.get("LOGO_DX_LINK"), row.getLOGO_DX_LINKField())));
            row.setSTYLE(Utils.convertToString(ds.parse(record.get("STYLE"), row.getSTYLEField())));
            row.setCOPYRIGHT(Utils.convertToString(ds.parse(record.get("COPYRIGHT"), row.getCOPYRIGHTField())));
            row.setID_SEZIONE(Utils.convertToLong(ds.parse(record.get("ID_SEZIONE"), row.getID_SEZIONEField())));
        }
//End loadDataBind

//End of load @2-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//checkUnique @2-23A80627
    int checkUnique( VerifiableControl control ) {
        int result = -1;
        boolean isErrors = false;
        if ( StringUtils.isEmpty(control.toString()) ) return 0;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        if ( urlSZ.getObjectValue() == null ) urlSZ.setValue( 0 );
        String where1 = WhereParams.rawOperation( "ID_SEZIONE", FieldOperation.EQUAL, urlSZ, null, ds );
        String where2 = WhereParams.rawOperation( "ID_SEZIONE", FieldOperation.NOT_EQUAL, expr32, null, ds );
        String whereParams = WhereParams.and(false, where1, where2);

        command.setCountSql( "SELECT count(*) FROM AMV_SEZIONI" );
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

//insert @2-19651C91
        boolean insert() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            command.setNeedQuotes(true);
            command.setSql("INSERT INTO AMV_SEZIONI ( NOME, DESCRIZIONE, ID_PADRE, SEQUENZA, ID_AREA, VISIBILITA, ZONA_ESPANSIONE, ZONA_TIPO, ZONA, ZONA_VISIBILITA, ZONA_FORMATO, IMMAGINE, MAX_VIS, ICONA, INTESTAZIONE, LOGO_SX, LOGO_SX_LINK, LOGO_DX, LOGO_DX_LINK, STYLE, COPYRIGHT, ID_SEZIONE ) VALUES ( {NOME}, {DESCRIZIONE}, {ID_PADRE}, {SEQUENZA}, {ID_AREA}, {VISIBILITA}, {ZONA_ESPANSIONE}, {ZONA_TIPO}, {ZONA}, {ZONA_VISIBILITA}, {ZONA_FORMATO}, {IMMAGINE}, {MAX_VIS}, {ICONA}, {INTESTAZIONE}, {LOGO_SX}, {LOGO_SX_LINK}, {LOGO_DX}, {LOGO_DX_LINK}, {STYLE}, {COPYRIGHT}, {ID_SEZIONE} )");
            command.addParameter("NOME", row.getNOMEField());
            command.addParameter("DESCRIZIONE", row.getDESCRIZIONEField());
            command.addParameter("ID_PADRE", row.getID_PADREField());
            command.addParameter("SEQUENZA", row.getSEQUENZAField());
            command.addParameter("ID_AREA", row.getID_AREAField());
            command.addParameter("VISIBILITA", row.getVISIBILITAField());
            command.addParameter("ZONA_ESPANSIONE", row.getZONA_ESPANSIONEField());
            command.addParameter("ZONA_TIPO", row.getZONA_TIPOField());
            command.addParameter("ZONA", row.getZONAField());
            command.addParameter("ZONA_VISIBILITA", row.getZONA_VISIBILITAField());
            command.addParameter("ZONA_FORMATO", row.getZONA_FORMATOField());
            command.addParameter("IMMAGINE", row.getIMMAGINEField());
            command.addParameter("MAX_VIS", row.getMAX_VISField());
            command.addParameter("ICONA", row.getICONAField());
            command.addParameter("INTESTAZIONE", row.getINTESTAZIONEField());
            command.addParameter("LOGO_SX", row.getLOGO_SXField());
            command.addParameter("LOGO_SX_LINK", row.getLOGO_SX_LINKField());
            command.addParameter("LOGO_DX", row.getLOGO_DXField());
            command.addParameter("LOGO_DX_LINK", row.getLOGO_DX_LINKField());
            command.addParameter("STYLE", row.getSTYLEField());
            command.addParameter("COPYRIGHT", row.getCOPYRIGHTField());
            command.addParameter("ID_SEZIONE", row.getID_SEZIONEField());

            fireBeforeBuildInsertEvent( new DataObjectEvent(command) );

//End insert

//insertDataBound @2-BC781F8A
            fireBeforeExecuteInsertEvent( new DataObjectEvent(command) );

            if ( ! ds.hasErrors() ) {
                command.executeUpdate();
            }

            CCLogger.getInstance().debug(command.toString());

            fireAfterExecuteInsertEvent( new DataObjectEvent(command) );

//End insertDataBound

//End of insert @2-CDC5319F
            ds.closeConnection();
            isErrors = ds.hasErrors();
            if ( isErrors ) addErrors( ds.getErrors() );
            return ( ! isErrors );
        }
//End End of insert

//update @2-768742C5
        boolean update() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            command.setNeedQuotes(true);
            command.setSql("UPDATE AMV_SEZIONI SET NOME = {NOME}, DESCRIZIONE = {DESCRIZIONE}, ID_PADRE = {ID_PADRE}, SEQUENZA = {SEQUENZA}, ID_AREA = {ID_AREA}, VISIBILITA = {VISIBILITA}, ZONA_ESPANSIONE = {ZONA_ESPANSIONE}, ZONA_TIPO = {ZONA_TIPO}, ZONA = {ZONA}, ZONA_VISIBILITA = {ZONA_VISIBILITA}, ZONA_FORMATO = {ZONA_FORMATO}, IMMAGINE = {IMMAGINE}, MAX_VIS = {MAX_VIS}, ICONA = {ICONA}, INTESTAZIONE = {INTESTAZIONE}, LOGO_SX = {LOGO_SX}, LOGO_SX_LINK = {LOGO_SX_LINK}, LOGO_DX = {LOGO_DX}, LOGO_DX_LINK = {LOGO_DX_LINK}, STYLE = {STYLE}, COPYRIGHT = {COPYRIGHT}, ID_SEZIONE = {ID_SEZIONE}");
            command.addParameter("NOME", row.getNOMEField());
            command.addParameter("DESCRIZIONE", row.getDESCRIZIONEField());
            command.addParameter("ID_PADRE", row.getID_PADREField());
            command.addParameter("SEQUENZA", row.getSEQUENZAField());
            command.addParameter("ID_AREA", row.getID_AREAField());
            command.addParameter("VISIBILITA", row.getVISIBILITAField());
            command.addParameter("ZONA_ESPANSIONE", row.getZONA_ESPANSIONEField());
            command.addParameter("ZONA_TIPO", row.getZONA_TIPOField());
            command.addParameter("ZONA", row.getZONAField());
            command.addParameter("ZONA_VISIBILITA", row.getZONA_VISIBILITAField());
            command.addParameter("ZONA_FORMATO", row.getZONA_FORMATOField());
            command.addParameter("IMMAGINE", row.getIMMAGINEField());
            command.addParameter("MAX_VIS", row.getMAX_VISField());
            command.addParameter("ICONA", row.getICONAField());
            command.addParameter("INTESTAZIONE", row.getINTESTAZIONEField());
            command.addParameter("LOGO_SX", row.getLOGO_SXField());
            command.addParameter("LOGO_SX_LINK", row.getLOGO_SX_LINKField());
            command.addParameter("LOGO_DX", row.getLOGO_DXField());
            command.addParameter("LOGO_DX_LINK", row.getLOGO_DX_LINKField());
            command.addParameter("STYLE", row.getSTYLEField());
            command.addParameter("COPYRIGHT", row.getCOPYRIGHTField());
            command.addParameter("ID_SEZIONE", row.getID_SEZIONEField());

            fireBeforeBuildUpdateEvent( new DataObjectEvent(command) );

            if ( urlSZ.getObjectValue() == null ) urlSZ.setValue( 0 );
            String where1 = WhereParams.rawOperation( "ID_SEZIONE", FieldOperation.EQUAL, urlSZ, null, ds );
            if (StringUtils.isEmpty(where1)) command.setCmdExecution(false);
            String where2 = WhereParams.rawOperation( "ID_SEZIONE", FieldOperation.NOT_EQUAL, expr32, null, ds );
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

//updateDataBound @2-35E17193
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

//End of update @2-CDC5319F
            ds.closeConnection();
            isErrors = ds.hasErrors();
            if ( isErrors ) addErrors( ds.getErrors() );
            return ( ! isErrors );
        }
//End End of update

//delete @2-58920091
        boolean delete() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            command.setNeedQuotes(true);
            command.setSql("DELETE FROM AMV_SEZIONI");

            fireBeforeBuildDeleteEvent( new DataObjectEvent(command) );

            if ( urlSZ.getObjectValue() == null ) urlSZ.setValue( 0 );
            String where1 = WhereParams.rawOperation( "ID_SEZIONE", FieldOperation.EQUAL, urlSZ, null, ds );
            if (StringUtils.isEmpty(where1)) command.setCmdExecution(false);
            String where2 = WhereParams.rawOperation( "ID_SEZIONE", FieldOperation.NOT_EQUAL, expr32, null, ds );
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

//deleteDataBound @2-5B959F17
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

//End of delete @2-CDC5319F
            ds.closeConnection();
            isErrors = ds.hasErrors();
            if ( isErrors ) addErrors( ds.getErrors() );
            return ( ! isErrors );
        }
//End End of delete

//getParameterByName @2-7882AA20
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "SZ".equals(name) && "url".equals(prefix) ) {
                param = urlSZ;
            } else if ( "SZ".equals(name) && prefix == null ) {
                param = urlSZ;
            }
            if ( "expr32".equals(name) && "expr".equals(prefix) ) {
                param = expr32;
            } else if ( "expr32".equals(name) && prefix == null ) {
                param = expr32;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addRecordDataObjectListener @2-47141785
    public synchronized void addRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.addElement(l);
    }
//End addRecordDataObjectListener

//removeRecordDataObjectListener @2-A1ABC1F4
    public synchronized void removeRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeRecordDataObjectListener

//fireBeforeBuildSelectEvent @2-305A023C
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

//fireBeforeExecuteSelectEvent @2-D00ACF95
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

//fireAfterExecuteSelectEvent @2-3BAD39CE
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

//fireBeforeBuildInsertEvent @2-FBA08B71
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

//fireBeforeExecuteInsertEvent @2-47AFA6A5
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

//fireAfterExecuteInsertEvent @2-E9CE95AE
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

//fireBeforeBuildSelectEvent @2-2405BE8B
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

//fireBeforeExecuteSelectEvent @2-E9DFF86B
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

//fireAfterExecuteSelectEvent @2-580A2987
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

//fireBeforeBuildSelectEvent @2-D021D0EA
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

//fireBeforeExecuteDeleteEvent @2-DD540FBB
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

//fireAfterExecuteDeleteEvent @2-2A6E2049
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

//class DataObject Tail @2-ED3F53A4
} // End of class DS
//End class DataObject Tail

