//GuidaPropria DataSource @13-748C4ECE
package common.AmvGuidaBar;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End GuidaPropria DataSource

//class DataObject Header @13-48D36614
public class GuidaPropriaDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @13-4421CCE3
    

    TextField sesMVVC = new TextField(null, null);
    
    TextField urlMVID = new TextField(null, null);
    
    TextField sesUtente = new TextField(null, null);
    
    TextField sesIstanza = new TextField(null, null);
    
    TextField sesProgetto = new TextField(null, null);
    
    TextField urlMVID2 = new TextField(null, null);
    
    TextField sesMVPC = new TextField(null, null);
    
    TextField sesMVCONTEXT = new TextField(null, null);
    

    private GuidaPropriaRow[] rows = new GuidaPropriaRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @13-4A377556

    public void  setSesMVVC( String param ) {
        this.sesMVVC.setValue( param );
    }

    public void  setSesMVVC( Object param ) {
        this.sesMVVC.setValue( param );
    }

    public void  setSesMVVC( Object param, Format ignore ) {
        this.sesMVVC.setValue( param );
    }

    public void  setUrlMVID( String param ) {
        this.urlMVID.setValue( param );
    }

    public void  setUrlMVID( Object param ) {
        this.urlMVID.setValue( param );
    }

    public void  setUrlMVID( Object param, Format ignore ) {
        this.urlMVID.setValue( param );
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

    public void  setSesIstanza( String param ) {
        this.sesIstanza.setValue( param );
    }

    public void  setSesIstanza( Object param ) {
        this.sesIstanza.setValue( param );
    }

    public void  setSesIstanza( Object param, Format ignore ) {
        this.sesIstanza.setValue( param );
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

    public void  setUrlMVID2( String param ) {
        this.urlMVID2.setValue( param );
    }

    public void  setUrlMVID2( Object param ) {
        this.urlMVID2.setValue( param );
    }

    public void  setUrlMVID2( Object param, Format ignore ) {
        this.urlMVID2.setValue( param );
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

    public void  setSesMVCONTEXT( String param ) {
        this.sesMVCONTEXT.setValue( param );
    }

    public void  setSesMVCONTEXT( Object param ) {
        this.sesMVCONTEXT.setValue( param );
    }

    public void  setSesMVCONTEXT( Object param, Format ignore ) {
        this.sesMVCONTEXT.setValue( param );
    }

    public GuidaPropriaRow[] getRows() {
        return rows;
    }

    public void setRows(GuidaPropriaRow[] rows) {
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

//constructor @13-C35B6AC8
    public GuidaPropriaDataObject(Page page) {
        super(page);
    }
//End constructor

//load @13-DD83FC4B
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT decode(g.sequenza,min(s.sequenza),'| ','') separatore,  "
                    + "decode(g.sequenza,nvl('{MVID2}',0),'<b>')||'<a href='||chr(34)||AMV_MENU.GET_LINK_STRINGA(v.stringa,v.modulo,'{MVCONTEXT}')||decode(instr(AMV_MENU.GET_LINK_STRINGA(v.stringa,v.modulo,'{MVCONTEXT}'),'?'),0,'?','&')||'MVID='||'{MVID}'||'&MVID2='||g.sequenza||'&MVVC='||g.voce_menu||decode(upper(g.alias),'WEB','','&MVAV='||g.alias)||chr(34)||' >'||g.titolo||'</a>'||decode(g.sequenza,nvl('{MVID2}',0),'</b>') titolo "
                    + "  FROM AMV_GUIDE g, AMV_VOCI v, AMV_GUIDE s "
                    + " WHERE g.GUIDA =  "
                    + "      (select voce "
                    + "         from AMV_VOCI "
                    + "        where voce = nvl('{MVVC}',AMV_MENU.GET_VOCE_MENU('{MVPC}','{Progetto}')) "
                    + "          and v.Progetto =  '{Progetto}' "
                    + "          and voce_guida is not null "
                    + "      ) "
                    + "   AND s.guida (+)    = g.guida  "
                    + "   AND v.voce = g.voce_menu "
                    + "   AND v.Progetto =  '{Progetto}'  "
                    + "   AND (EXISTS "
                    + "      (SELECT 1 FROM AMV_ABILITAZIONI a, AD4_DIRITTI_ACCESSO d "
                    + "        WHERE d.utente    = '{Utente}' "
                    + "          AND d.istanza   = '{Istanza}' "
                    + "          AND a.modulo    = d.modulo "
                    + "          AND a.ruolo     = d.ruolo "
                    + "          AND a.voce_menu = nvl(g.voce_rif, g.voce_menu) "
                    + "      ) "
                    + "   OR NOT EXISTS "
                    + "      (SELECT 1 FROM AMV_ABILITAZIONI a, AD4_DIRITTI_ACCESSO d "
                    + "        WHERE d.utente    = '{Utente}' "
                    + "          AND d.istanza   = '{Istanza}' "
                    + "          AND a.modulo    = d.modulo "
                    + "          AND a.voce_menu = nvl(g.voce_rif, g.voce_menu) "
                    + "      )) "
                    + "GROUP BY g.sequenza, g.voce_menu, g.titolo, g.alias, v.stringa, v.modulo "
                    + "" );
        if ( StringUtils.isEmpty( (String) sesMVVC.getObjectValue() ) ) sesMVVC.setValue( "" );
        command.addParameter( "MVVC", sesMVVC, null );
        if ( StringUtils.isEmpty( (String) urlMVID.getObjectValue() ) ) urlMVID.setValue( "" );
        command.addParameter( "MVID", urlMVID, null );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( StringUtils.isEmpty( (String) sesIstanza.getObjectValue() ) ) sesIstanza.setValue( "" );
        command.addParameter( "Istanza", sesIstanza, null );
        if ( StringUtils.isEmpty( (String) sesProgetto.getObjectValue() ) ) sesProgetto.setValue( "" );
        command.addParameter( "Progetto", sesProgetto, null );
        if ( StringUtils.isEmpty( (String) urlMVID2.getObjectValue() ) ) urlMVID2.setValue( "" );
        command.addParameter( "MVID2", urlMVID2, null );
        if ( StringUtils.isEmpty( (String) sesMVPC.getObjectValue() ) ) sesMVPC.setValue( "" );
        command.addParameter( "MVPC", sesMVPC, null );
        if ( StringUtils.isEmpty( (String) sesMVCONTEXT.getObjectValue() ) ) sesMVCONTEXT.setValue( "" );
        command.addParameter( "MVCONTEXT", sesMVCONTEXT, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT decode(g.sequenza,min(s.sequenza),'| ','') separatore,  "
                                                         + "            decode(g.sequenza,nvl('{MVID2}',0),'<b>')||'<a href='||chr(34)||AMV_MENU.GET_LINK_STRINGA(v.stringa,v.modulo,'{MVCONTEXT}')||decode(instr(AMV_MENU.GET_LINK_STRINGA(v.stringa,v.modulo,'{MVCONTEXT}'),'?'),0,'?','&')||'MVID='||'{MVID}'||'&MVID2='||g.sequenza||'&MVVC='||g.voce_menu||decode(upper(g.alias),'WEB','','&MVAV='||g.alias)||chr(34)||' >'||g.titolo||'</a>'||decode(g.sequenza,nvl('{MVID2}',0),'</b>') titolo FROM AMV_GUIDE g, AMV_VOCI v, AMV_GUIDE s WHERE g.GUIDA = (select voce from AMV_VOCI where voce = nvl('{MVVC}',AMV_MENU.GET_VOCE_MENU('{MVPC}','{Progetto}')) and v.Progetto = '{Progetto}' and voce_guida is not null ) AND s.guida (+) = g.guida AND v.voce = g.voce_menu AND v.Progetto = '{Progetto}' AND (EXISTS (SELECT 1 FROM AMV_ABILITAZIONI a, AD4_DIRITTI_ACCESSO d WHERE d.utente = '{Utente}' AND d.istanza = '{Istanza}' AND a.modulo = d.modulo AND a.ruolo = d.ruolo AND a.voce_menu = nvl(g.voce_rif, g.voce_menu) ) OR NOT EXISTS (SELECT 1 FROM AMV_ABILITAZIONI a, AD4_DIRITTI_ACCESSO d WHERE d.utente = '{Utente}' AND d.istanza = '{Istanza}' AND a.modulo = d.modulo AND a.voce_menu = nvl(g.voce_rif, g.voce_menu) )) GROUP BY g.sequenza, g.voce_menu, g.titolo, g.alias, v.stringa, v.modulo  ) cnt " );
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        } else {
            command.setOrder( "g.sequenza" );
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

//loadDataBind @13-80CA6AB5
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                GuidaPropriaRow row = new GuidaPropriaRow();
                DbRow record = (DbRow) records.nextElement();
                row.setSEPARATORE(Utils.convertToString(ds.parse(record.get("SEPARATORE"), row.getSEPARATOREField())));
                row.setGUIDA(Utils.convertToString(ds.parse(record.get("TITOLO"), row.getGUIDAField())));
                row.setSTRINGA(Utils.convertToString(ds.parse(record.get("STRINGA"), row.getSTRINGAField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @13-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @13-06C880D0
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "MVVC".equals(name) && "ses".equals(prefix) ) {
                param = sesMVVC;
            } else if ( "MVVC".equals(name) && prefix == null ) {
                param = sesMVVC;
            }
            if ( "MVID".equals(name) && "url".equals(prefix) ) {
                param = urlMVID;
            } else if ( "MVID".equals(name) && prefix == null ) {
                param = urlMVID;
            }
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
            if ( "Progetto".equals(name) && "ses".equals(prefix) ) {
                param = sesProgetto;
            } else if ( "Progetto".equals(name) && prefix == null ) {
                param = sesProgetto;
            }
            if ( "MVID2".equals(name) && "url".equals(prefix) ) {
                param = urlMVID2;
            } else if ( "MVID2".equals(name) && prefix == null ) {
                param = urlMVID2;
            }
            if ( "MVPC".equals(name) && "ses".equals(prefix) ) {
                param = sesMVPC;
            } else if ( "MVPC".equals(name) && prefix == null ) {
                param = sesMVPC;
            }
            if ( "MVCONTEXT".equals(name) && "ses".equals(prefix) ) {
                param = sesMVCONTEXT;
            } else if ( "MVCONTEXT".equals(name) && prefix == null ) {
                param = sesMVCONTEXT;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @13-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @13-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @13-238A81BB
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

//fireBeforeExecuteSelectEvent @13-9DA7B025
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

//fireAfterExecuteSelectEvent @13-F7E8A616
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

//class DataObject Tail @13-ED3F53A4
} // End of class DS
//End class DataObject Tail

