//AD4_MODULI DataSource @28-D64F0131
package common.AmvHeader;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AD4_MODULI DataSource

//class DataObject Header @28-004E45D4
public class AD4_MODULIDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @28-EFB4C779
    

    TextField sesMVVC = new TextField(null, null);
    
    TextField sesMVPD = new TextField(null, null);
    
    TextField sesModulo = new TextField(null, null);
    
    TextField urlMVTD = new TextField(null, null);
    
    TextField urlMVNP = new TextField(null, null);
    
    TextField sesMVRP = new TextField(null, null);
    
    TextField sesMVCONTEXT = new TextField(null, null);
    
    TextField sesUtente = new TextField(null, null);
    
    TextField sesRuolo = new TextField(null, null);
    
    TextField sesMVL1 = new TextField(null, null);
    
    TextField sesMVL2 = new TextField(null, null);
    
    TextField sesMVL3 = new TextField(null, null);
    
    TextField sesIstanza = new TextField(null, null);
    
    LongField urlMVSZ = new LongField(null, null);
    
    TextField sesMVPC = new TextField(null, null);
    

    private AD4_MODULIRow[] rows = new AD4_MODULIRow[100];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @28-076A5F82

    public void  setSesMVVC( String param ) {
        this.sesMVVC.setValue( param );
    }

    public void  setSesMVVC( Object param ) {
        this.sesMVVC.setValue( param );
    }

    public void  setSesMVVC( Object param, Format ignore ) {
        this.sesMVVC.setValue( param );
    }

    public void  setSesMVPD( String param ) {
        this.sesMVPD.setValue( param );
    }

    public void  setSesMVPD( Object param ) {
        this.sesMVPD.setValue( param );
    }

    public void  setSesMVPD( Object param, Format ignore ) {
        this.sesMVPD.setValue( param );
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

    public void  setUrlMVTD( String param ) {
        this.urlMVTD.setValue( param );
    }

    public void  setUrlMVTD( Object param ) {
        this.urlMVTD.setValue( param );
    }

    public void  setUrlMVTD( Object param, Format ignore ) {
        this.urlMVTD.setValue( param );
    }

    public void  setUrlMVNP( String param ) {
        this.urlMVNP.setValue( param );
    }

    public void  setUrlMVNP( Object param ) {
        this.urlMVNP.setValue( param );
    }

    public void  setUrlMVNP( Object param, Format ignore ) {
        this.urlMVNP.setValue( param );
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

    public void  setSesMVL1( String param ) {
        this.sesMVL1.setValue( param );
    }

    public void  setSesMVL1( Object param ) {
        this.sesMVL1.setValue( param );
    }

    public void  setSesMVL1( Object param, Format ignore ) {
        this.sesMVL1.setValue( param );
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

    public void  setSesIstanza( String param ) {
        this.sesIstanza.setValue( param );
    }

    public void  setSesIstanza( Object param ) {
        this.sesIstanza.setValue( param );
    }

    public void  setSesIstanza( Object param, Format ignore ) {
        this.sesIstanza.setValue( param );
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

    public void  setSesMVPC( String param ) {
        this.sesMVPC.setValue( param );
    }

    public void  setSesMVPC( Object param ) {
        this.sesMVPC.setValue( param );
    }

    public void  setSesMVPC( Object param, Format ignore ) {
        this.sesMVPC.setValue( param );
    }

    public AD4_MODULIRow[] getRows() {
        return rows;
    }

    public void setRows(AD4_MODULIRow[] rows) {
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

//constructor @28-34EDE271
    public AD4_MODULIDataObject(Page page) {
        super(page);
    }
//End constructor

//load @28-B93F6598
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT AMVWEB.GET_RETURNPAGE('{MVRP}') RETURN_PAGE "
                    + ", DESCRIZIONE  "
                    + ",  "
                    + "'{MVNP}' NOTE_PAGINA "
                    + ",  "
                    + "'<a name=\"Help\" id=\"Help\" href=\"../common/Help.do\" alt=\"Help\" target=\"_blank\"><img border=0 src=\"../common/images/AMV/help.gif\" alt=\"Help\" align=\"absmiddle\"></a>&nbsp;' help "
                    + ", amvweb.get('HEADER.MENUBAR', '{Utente}', '{Modulo}', '{Ruolo}','{Istanza}') menubar   "
                    + ", AMV_MENU.GET_NAVIGATORE('{VOCE}','{MVL1}','{MVL2}','{MVL3}','{TIPOLOGIA}','{MVCONTEXT}') NAVIGATORE "
                    + ", AMV_SEZIONE.GET_HEADER_BAR('{Utente}',{MVSZ},'{MVPC}') SECTIONBAR  "
                    + " FROM AD4_MODULI "
                    + "WHERE MODULO = '{Modulo}'" );
        if ( StringUtils.isEmpty( (String) sesMVVC.getObjectValue() ) ) sesMVVC.setValue( "" );
        command.addParameter( "VOCE", sesMVVC, null );
        if ( StringUtils.isEmpty( (String) sesMVPD.getObjectValue() ) ) sesMVPD.setValue( "" );
        command.addParameter( "PADRE", sesMVPD, null );
        if ( StringUtils.isEmpty( (String) sesModulo.getObjectValue() ) ) sesModulo.setValue( "" );
        command.addParameter( "Modulo", sesModulo, null );
        if ( StringUtils.isEmpty( (String) urlMVTD.getObjectValue() ) ) urlMVTD.setValue( "" );
        command.addParameter( "TIPOLOGIA", urlMVTD, null );
        if ( StringUtils.isEmpty( (String) urlMVNP.getObjectValue() ) ) urlMVNP.setValue( "" );
        command.addParameter( "MVNP", urlMVNP, null );
        if ( StringUtils.isEmpty( (String) sesMVRP.getObjectValue() ) ) sesMVRP.setValue( "" );
        command.addParameter( "MVRP", sesMVRP, null );
        if ( StringUtils.isEmpty( (String) sesMVCONTEXT.getObjectValue() ) ) sesMVCONTEXT.setValue( "" );
        command.addParameter( "MVCONTEXT", sesMVCONTEXT, null );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( StringUtils.isEmpty( (String) sesRuolo.getObjectValue() ) ) sesRuolo.setValue( "" );
        command.addParameter( "Ruolo", sesRuolo, null );
        if ( StringUtils.isEmpty( (String) sesMVL1.getObjectValue() ) ) sesMVL1.setValue( "" );
        command.addParameter( "MVL1", sesMVL1, null );
        if ( StringUtils.isEmpty( (String) sesMVL2.getObjectValue() ) ) sesMVL2.setValue( "" );
        command.addParameter( "MVL2", sesMVL2, null );
        if ( StringUtils.isEmpty( (String) sesMVL3.getObjectValue() ) ) sesMVL3.setValue( "" );
        command.addParameter( "MVL3", sesMVL3, null );
        if ( StringUtils.isEmpty( (String) sesIstanza.getObjectValue() ) ) sesIstanza.setValue( "" );
        command.addParameter( "Istanza", sesIstanza, null );
        if ( urlMVSZ.getObjectValue() == null ) urlMVSZ.setValue( 0 );
        command.addParameter( "MVSZ", urlMVSZ, null );
        if ( StringUtils.isEmpty( (String) sesMVPC.getObjectValue() ) ) sesMVPC.setValue( "" );
        command.addParameter( "MVPC", sesMVPC, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT AMVWEB.GET_RETURNPAGE('{MVRP}') RETURN_PAGE , DESCRIZIONE ,  "
                                                         + "            '{MVNP}' NOTE_PAGINA ,  "
                                                         + "            '<a name=\"Help\" id=\"Help\" href=\"../common/Help.do\" alt=\"Help\" target=\"_blank\"><img border=0 src=\"../common/images/AMV/help.gif\" alt=\"Help\" align=\"absmiddle\"></a>&nbsp;' help , amvweb.get('HEADER.MENUBAR', '{Utente}', '{Modulo}', '{Ruolo}','{Istanza}') menubar , AMV_MENU.GET_NAVIGATORE('{VOCE}','{MVL1}','{MVL2}','{MVL3}','{TIPOLOGIA}','{MVCONTEXT}') NAVIGATORE , AMV_SEZIONE.GET_HEADER_BAR('{Utente}',{MVSZ},'{MVPC}') SECTIONBAR FROM AD4_MODULI WHERE MODULO = '{Modulo}' ) cnt " );
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

//loadDataBind @28-23E62A12
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AD4_MODULIRow row = new AD4_MODULIRow();
                DbRow record = (DbRow) records.nextElement();
                row.setRETURN_PAGE(Utils.convertToString(ds.parse(record.get("RETURN_PAGE"), row.getRETURN_PAGEField())));
                row.setNAVIGATORE(Utils.convertToString(ds.parse(record.get("NAVIGATORE"), row.getNAVIGATOREField())));
                row.setMENUBAR(Utils.convertToString(ds.parse(record.get("MENUBAR"), row.getMENUBARField())));
                row.setSECTIONBAR(Utils.convertToString(ds.parse(record.get("SECTIONBAR"), row.getSECTIONBARField())));
                row.setHELP(Utils.convertToString(ds.parse(record.get("HELP"), row.getHELPField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @28-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @28-5C58A803
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "MVVC".equals(name) && "ses".equals(prefix) ) {
                param = sesMVVC;
            } else if ( "MVVC".equals(name) && prefix == null ) {
                param = sesMVVC;
            }
            if ( "MVPD".equals(name) && "ses".equals(prefix) ) {
                param = sesMVPD;
            } else if ( "MVPD".equals(name) && prefix == null ) {
                param = sesMVPD;
            }
            if ( "Modulo".equals(name) && "ses".equals(prefix) ) {
                param = sesModulo;
            } else if ( "Modulo".equals(name) && prefix == null ) {
                param = sesModulo;
            }
            if ( "MVTD".equals(name) && "url".equals(prefix) ) {
                param = urlMVTD;
            } else if ( "MVTD".equals(name) && prefix == null ) {
                param = urlMVTD;
            }
            if ( "MVNP".equals(name) && "url".equals(prefix) ) {
                param = urlMVNP;
            } else if ( "MVNP".equals(name) && prefix == null ) {
                param = urlMVNP;
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
            if ( "MVL1".equals(name) && "ses".equals(prefix) ) {
                param = sesMVL1;
            } else if ( "MVL1".equals(name) && prefix == null ) {
                param = sesMVL1;
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
            if ( "Istanza".equals(name) && "ses".equals(prefix) ) {
                param = sesIstanza;
            } else if ( "Istanza".equals(name) && prefix == null ) {
                param = sesIstanza;
            }
            if ( "MVSZ".equals(name) && "url".equals(prefix) ) {
                param = urlMVSZ;
            } else if ( "MVSZ".equals(name) && prefix == null ) {
                param = urlMVSZ;
            }
            if ( "MVPC".equals(name) && "ses".equals(prefix) ) {
                param = sesMVPC;
            } else if ( "MVPC".equals(name) && prefix == null ) {
                param = sesMVPC;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @28-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @28-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @28-238A81BB
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

//fireBeforeExecuteSelectEvent @28-9DA7B025
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

//fireAfterExecuteSelectEvent @28-F7E8A616
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

//class DataObject Tail @28-ED3F53A4
} // End of class DS
//End class DataObject Tail

