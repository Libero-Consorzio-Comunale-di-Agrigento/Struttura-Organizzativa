//Guida DataSource @2-5DA775D0
package common.AmvGuida;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End Guida DataSource

//class DataObject Header @2-7855E245
public class GuidaDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @2-7494AADB
    

    TextField sesMVVC = new TextField(null, null);
    
    TextField sesMVID = new TextField(null, null);
    
    TextField sesUtente = new TextField(null, null);
    
    TextField sesIstanza = new TextField(null, null);
    
    TextField sesProgetto = new TextField(null, null);
    
    TextField sesMVPC = new TextField(null, null);
    
    TextField sesMVCONTEXT = new TextField(null, null);
    
    TextField sesMVSTILE = new TextField(null, null);
    

    private GuidaRow[] rows = new GuidaRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @2-E5D0C597

    public void  setSesMVVC( String param ) {
        this.sesMVVC.setValue( param );
    }

    public void  setSesMVVC( Object param ) {
        this.sesMVVC.setValue( param );
    }

    public void  setSesMVVC( Object param, Format ignore ) {
        this.sesMVVC.setValue( param );
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

    public void  setSesMVSTILE( String param ) {
        this.sesMVSTILE.setValue( param );
    }

    public void  setSesMVSTILE( Object param ) {
        this.sesMVSTILE.setValue( param );
    }

    public void  setSesMVSTILE( Object param, Format ignore ) {
        this.sesMVSTILE.setValue( param );
    }

    public GuidaRow[] getRows() {
        return rows;
    }

    public void setRows(GuidaRow[] rows) {
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

//constructor @2-08426B70
    public GuidaDataObject(Page page) {
        super(page);
    }
//End constructor

//load @2-54BE3F15
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT  "
                    + "decode(g.sequenza,nvl('{MVID}',0) "
                    + ",'<td align=\"left\" valign=\"top\" class=\"AFCGuidaSelL\"><img src=\"../Themes/Default/GuidaBlank.gif\" ></td>' "
                    + ",'<td align=\"left\" valign=\"top\" class=\"AFCGuidaL\"><img src=\"../Themes/Default/GuidaBlank.gif\" ></td>' "
                    + ") apertura "
                    + ",  "
                    + "decode(g.sequenza,nvl('{MVID}',0),'<td align=\"left\" class=\"AFCGuidaSel\" valign=\"center\" nowrap>','<td align=\"left\" class=\"AFCGuida\" valign=\"center\" nowrap>') "
                    + "||'<a class=\"AFCGuidaLink\" href='||chr(34)||AMV_MENU.GET_LINK_STRINGA(v.stringa,v.modulo,'{MVCONTEXT}')||decode(instr(AMV_MENU.GET_LINK_STRINGA(v.stringa,v.modulo),'?'),0,'?','&')||'MVID='||g.sequenza||'&MVVC='||g.voce_menu||decode(upper(g.alias),'WEB','','&MVAV='||g.alias)||chr(34)||' >'||g.titolo||'</a>' "
                    + "||decode(g.sequenza,nvl('{MVID}',0),'</td>','</td>') titolo "
                    + ", decode(g.sequenza,nvl('{MVID}',0) "
                    + ",'<td align=\"left\" valign=\"top\" class=\"AFCGuidaSelR\"><img src=\"../Themes/Default/GuidaBlank.gif\" >' "
                    + ",'<td align=\"left\" valign=\"top\" class=\"AFCGuidaR\"><img src=\"../Themes/Default/GuidaBlank.gif\" >')||'</td>' chiusura "
                    + "  FROM AMV_GUIDE g, AMV_VOCI v, AMV_GUIDE s "
                    + " WHERE g.GUIDA =  "
                    + "      (select nvl(voce_guida,voce) "
                    + "         from AMV_VOCI "
                    + "        where voce = nvl('{MVVC}',AMV_MENU.GET_VOCE_MENU('{MVPC}','{Progetto}')) "
                    + "          and v.Progetto =  '{Progetto}' "
                    + "      ) "
                    + "   AND s.guida (+) = g.guida  "
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
                    + " " );
        if ( StringUtils.isEmpty( (String) sesMVVC.getObjectValue() ) ) sesMVVC.setValue( "" );
        command.addParameter( "MVVC", sesMVVC, null );
        if ( StringUtils.isEmpty( (String) sesMVID.getObjectValue() ) ) sesMVID.setValue( "" );
        command.addParameter( "MVID", sesMVID, null );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( StringUtils.isEmpty( (String) sesIstanza.getObjectValue() ) ) sesIstanza.setValue( "" );
        command.addParameter( "Istanza", sesIstanza, null );
        if ( StringUtils.isEmpty( (String) sesProgetto.getObjectValue() ) ) sesProgetto.setValue( "" );
        command.addParameter( "Progetto", sesProgetto, null );
        if ( StringUtils.isEmpty( (String) sesMVPC.getObjectValue() ) ) sesMVPC.setValue( "" );
        command.addParameter( "MVPC", sesMVPC, null );
        if ( StringUtils.isEmpty( (String) sesMVCONTEXT.getObjectValue() ) ) sesMVCONTEXT.setValue( "" );
        command.addParameter( "MVCONTEXT", sesMVCONTEXT, null );
        if ( StringUtils.isEmpty( (String) sesMVSTILE.getObjectValue() ) ) sesMVSTILE.setValue( "" );
        command.addParameter( "MVSTILE", sesMVSTILE, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT decode(g.sequenza,nvl('{MVID}',0) ,'<td align=\"left\" valign=\"top\" class=\"AFCGuidaSelL\"><img src=\"../Themes/Default/GuidaBlank.gif\" ></td>' ,'<td align=\"left\" valign=\"top\" class=\"AFCGuidaL\"><img src=\"../Themes/Default/GuidaBlank.gif\" ></td>' ) apertura ,  "
                                                         + "            decode(g.sequenza,nvl('{MVID}',0),'<td align=\"left\" class=\"AFCGuidaSel\" valign=\"center\" nowrap>','<td align=\"left\" class=\"AFCGuida\" valign=\"center\" nowrap>') ||'<a class=\"AFCGuidaLink\" href='||chr(34)||AMV_MENU.GET_LINK_STRINGA(v.stringa,v.modulo,'{MVCONTEXT}')||decode(instr(AMV_MENU.GET_LINK_STRINGA(v.stringa,v.modulo),'?'),0,'?','&')||'MVID='||g.sequenza||'&MVVC='||g.voce_menu||decode(upper(g.alias),'WEB','','&MVAV='||g.alias)||chr(34)||' >'||g.titolo||'</a>' ||decode(g.sequenza,nvl('{MVID}',0),'</td>','</td>') titolo , decode(g.sequenza,nvl('{MVID}',0) ,'<td align=\"left\" valign=\"top\" class=\"AFCGuidaSelR\"><img src=\"../Themes/Default/GuidaBlank.gif\" >' ,'<td align=\"left\" valign=\"top\" class=\"AFCGuidaR\"><img src=\"../Themes/Default/GuidaBlank.gif\" >')||'</td>' chiusura FROM AMV_GUIDE g, AMV_VOCI v, AMV_GUIDE s WHERE g.GUIDA = (select nvl(voce_guida,voce) from AMV_VOCI where voce = nvl('{MVVC}',AMV_MENU.GET_VOCE_MENU('{MVPC}','{Progetto}')) and v.Progetto = '{Progetto}' ) AND s.guida (+) = g.guida AND v.voce = g.voce_menu AND v.Progetto = '{Progetto}' AND (EXISTS (SELECT 1 FROM AMV_ABILITAZIONI a, AD4_DIRITTI_ACCESSO d WHERE d.utente = '{Utente}' AND d.istanza = '{Istanza}' AND a.modulo = d.modulo AND a.ruolo = d.ruolo AND a.voce_menu = nvl(g.voce_rif, g.voce_menu) ) OR NOT EXISTS (SELECT 1 FROM AMV_ABILITAZIONI a, AD4_DIRITTI_ACCESSO d WHERE d.utente = '{Utente}' AND d.istanza = '{Istanza}' AND a.modulo = d.modulo AND a.voce_menu = nvl(g.voce_rif, g.voce_menu) )) GROUP BY g.sequenza, g.voce_menu, g.titolo, g.alias, v.stringa, v.modulo  ) cnt " );
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

//loadDataBind @2-C4062A52
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                GuidaRow row = new GuidaRow();
                DbRow record = (DbRow) records.nextElement();
                row.setAPERTURA(Utils.convertToString(ds.parse(record.get("APERTURA"), row.getAPERTURAField())));
                row.setGUIDA(Utils.convertToString(ds.parse(record.get("TITOLO"), row.getGUIDAField())));
                row.setCHIUSURA(Utils.convertToString(ds.parse(record.get("CHIUSURA"), row.getCHIUSURAField())));
                row.setSTRINGA(Utils.convertToString(ds.parse(record.get("STRINGA"), row.getSTRINGAField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @2-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @2-33637883
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "MVVC".equals(name) && "ses".equals(prefix) ) {
                param = sesMVVC;
            } else if ( "MVVC".equals(name) && prefix == null ) {
                param = sesMVVC;
            }
            if ( "MVID".equals(name) && "ses".equals(prefix) ) {
                param = sesMVID;
            } else if ( "MVID".equals(name) && prefix == null ) {
                param = sesMVID;
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
            if ( "MVSTILE".equals(name) && "ses".equals(prefix) ) {
                param = sesMVSTILE;
            } else if ( "MVSTILE".equals(name) && prefix == null ) {
                param = sesMVSTILE;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @2-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @2-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @2-238A81BB
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

//fireBeforeExecuteSelectEvent @2-9DA7B025
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

//fireAfterExecuteSelectEvent @2-F7E8A616
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

//class DataObject Tail @2-ED3F53A4
} // End of class DS
//End class DataObject Tail

