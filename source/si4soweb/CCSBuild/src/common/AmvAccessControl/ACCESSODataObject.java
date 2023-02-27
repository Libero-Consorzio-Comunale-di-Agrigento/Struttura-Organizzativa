//ACCESSO DataSource @3-2574433F
package common.AmvAccessControl;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End ACCESSO DataSource

//class DataObject Header @3-BB7C88CD
public class ACCESSODataObject extends DS {
//End class DataObject Header

//attributes of DataObject @3-BCBF07A4
    

    TextField sesModulo = new TextField(null, null);
    
    TextField sesRuolo = new TextField(null, null);
    
    TextField sesMVURL = new TextField(null, null);
    
    TextField sesMVCONTEXT = new TextField(null, null);
    
    TextField sesMVPATH = new TextField(null, null);
    

    private ACCESSORow[] rows = new ACCESSORow[100];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @3-FD1D8F91

    public void  setSesModulo( String param ) {
        this.sesModulo.setValue( param );
    }

    public void  setSesModulo( Object param ) {
        this.sesModulo.setValue( param );
    }

    public void  setSesModulo( Object param, Format ignore ) {
        this.sesModulo.setValue( param );
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

    public void  setSesMVCONTEXT( String param ) {
        this.sesMVCONTEXT.setValue( param );
    }

    public void  setSesMVCONTEXT( Object param ) {
        this.sesMVCONTEXT.setValue( param );
    }

    public void  setSesMVCONTEXT( Object param, Format ignore ) {
        this.sesMVCONTEXT.setValue( param );
    }

    public void  setSesMVPATH( String param ) {
        this.sesMVPATH.setValue( param );
    }

    public void  setSesMVPATH( Object param ) {
        this.sesMVPATH.setValue( param );
    }

    public void  setSesMVPATH( Object param, Format ignore ) {
        this.sesMVPATH.setValue( param );
    }

    public ACCESSORow[] getRows() {
        return rows;
    }

    public void setRows(ACCESSORow[] rows) {
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

//constructor @3-8ABA75CC
    public ACCESSODataObject(Page page) {
        super(page);
    }
//End constructor

//load @3-40BA0486
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select distinct  "
                    + "       v.voce voce "
                    + "     ,  "
                    + "replace(AMV_MENU.GET_PAGE(v.voce),'../','') pagina "
                    + "     ,  "
                    + "amv_menu.get_link_stringa(stringa) stringa "
                    + "     ,'{MVURL}' PATH "
                    + "     ,'{MVCONTEXT}' CONTEXT "
                    + "  from AMV_VOCI v,  "
                    + "AMV_ABILITAZIONI a "
                    + " where v.voce = a.voce_menu(+) "
                    + "   and nvl(a.ruolo,'{Ruolo}') = '{Ruolo}' "
                    + "   and (amv_menu.get_accesso_pagina(v.voce, '{MVURL}') = 1 "
                    + "        or AMVWEB.GET_PREFERENZA('Controllo Accesso Pagina','{Modulo}')='NO' "
                    + "        or instr('{MVPATH}','common/') > 0 "
                    + "        )" );
        if ( StringUtils.isEmpty( (String) sesModulo.getObjectValue() ) ) sesModulo.setValue( "" );
        command.addParameter( "Modulo", sesModulo, null );
        if ( StringUtils.isEmpty( (String) sesRuolo.getObjectValue() ) ) sesRuolo.setValue( "" );
        command.addParameter( "Ruolo", sesRuolo, null );
        if ( StringUtils.isEmpty( (String) sesMVURL.getObjectValue() ) ) sesMVURL.setValue( "" );
        command.addParameter( "MVURL", sesMVURL, null );
        if ( StringUtils.isEmpty( (String) sesMVCONTEXT.getObjectValue() ) ) sesMVCONTEXT.setValue( "" );
        command.addParameter( "MVCONTEXT", sesMVCONTEXT, null );
        if ( StringUtils.isEmpty( (String) sesMVPATH.getObjectValue() ) ) sesMVPATH.setValue( "" );
        command.addParameter( "MVPATH", sesMVPATH, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( select distinct v.voce voce , replace(AMV_MENU.GET_PAGE(v.voce),'../','') pagina ,  "
                                                         + "            amv_menu.get_link_stringa(stringa) stringa ,'{MVURL}' PATH ,'{MVCONTEXT}' CONTEXT from AMV_VOCI v, AMV_ABILITAZIONI a where v.voce = a.voce_menu(+) and nvl(a.ruolo,'{Ruolo}') = '{Ruolo}' and (amv_menu.get_accesso_pagina(v.voce, '{MVURL}') = 1 or AMVWEB.GET_PREFERENZA('Controllo Accesso Pagina','{Modulo}')='NO' or instr('{MVPATH}','common/') > 0 ) ) cnt " );
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

//loadDataBind @3-5410613F
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                ACCESSORow row = new ACCESSORow();
                DbRow record = (DbRow) records.nextElement();
                row.setVOCE(Utils.convertToString(ds.parse(record.get("VOCE"), row.getVOCEField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @3-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @3-AE77D0BC
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "Modulo".equals(name) && "ses".equals(prefix) ) {
                param = sesModulo;
            } else if ( "Modulo".equals(name) && prefix == null ) {
                param = sesModulo;
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
            if ( "MVCONTEXT".equals(name) && "ses".equals(prefix) ) {
                param = sesMVCONTEXT;
            } else if ( "MVCONTEXT".equals(name) && prefix == null ) {
                param = sesMVCONTEXT;
            }
            if ( "MVPATH".equals(name) && "ses".equals(prefix) ) {
                param = sesMVPATH;
            } else if ( "MVPATH".equals(name) && prefix == null ) {
                param = sesMVPATH;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @3-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @3-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @3-238A81BB
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

//fireBeforeExecuteSelectEvent @3-9DA7B025
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

//fireAfterExecuteSelectEvent @3-F7E8A616
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

//class DataObject Tail @3-ED3F53A4
} // End of class DS
//End class DataObject Tail

