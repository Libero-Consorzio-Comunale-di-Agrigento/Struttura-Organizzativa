



//AmvServiziDisponibiliElenco_iAction imports @1-437B65BC
package common.AmvServiziDisponibiliElenco_i;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvServiziDisponibiliElenco_iAction imports

//AmvServiziDisponibiliElenco_iAction class @1-78DBDFBE
public class AmvServiziDisponibiliElenco_iAction extends Action {

//End AmvServiziDisponibiliElenco_iAction class

//AmvServiziDisponibiliElenco_iAction: method perform @1-57FEDE7D
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvServiziDisponibiliElenco_iModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvServiziDisponibiliElenco_iModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvServiziDisponibiliElenco_iAction: method perform

//AmvServiziDisponibiliElenco_iAction: call children actions @1-80B1A110
        if (result == null) {
            SERVIZI_DISPONIBILIClass SERVIZI_DISPONIBILI = new SERVIZI_DISPONIBILIClass();
            SERVIZI_DISPONIBILI.perform(page.getGrid("SERVIZI_DISPONIBILI"));
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvServiziDisponibiliElenco_iAction: call children actions

//SERVIZI_DISPONIBILI Grid @16-E9AE7F14
    final class SERVIZI_DISPONIBILIClass {
        com.codecharge.components.Grid model;
        Event e;
//End SERVIZI_DISPONIBILI Grid

//SERVIZI_DISPONIBILI Grid: method perform @16-B48879D3
        protected String perform(com.codecharge.components.Grid model) {
            if ( ! model.isVisible() ) { return null; }
            this.model = model;
            //e = new ActionEvent( model, page );
            setProperties( model, Action.GET );
            setActivePermissions( model );
            if ( ! model.isVisible() ) return null;
            read();
            return null;
        }
//End SERVIZI_DISPONIBILI Grid: method perform

//SERVIZI_DISPONIBILI Grid: method read: head @16-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End SERVIZI_DISPONIBILI Grid: method read: head

//SERVIZI_DISPONIBILI Grid: method read: init @16-1371A257
            if ( ! model.allowRead ) return true;
            SERVIZI_DISPONIBILIDataObject ds = new SERVIZI_DISPONIBILIDataObject(page);
            ds.setComponent( model );
//End SERVIZI_DISPONIBILI Grid: method read: init

//SERVIZI_DISPONIBILI Grid: set where parameters @16-10EA76A9
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setSesProgetto( SessionStorage.getInstance(req).getAttribute("Progetto") );
            ds.setSesMVUTE( SessionStorage.getInstance(req).getAttribute("MVUTE") );
            try {
                ds.setUrlID( page.getHttpGetParams().getParameter("ID"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID'" );
                return false;
            }
//End SERVIZI_DISPONIBILI Grid: set where parameters

//SERVIZI_DISPONIBILI Grid: set grid properties @16-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End SERVIZI_DISPONIBILI Grid: set grid properties

//SERVIZI_DISPONIBILI Grid: retrieve data @16-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End SERVIZI_DISPONIBILI Grid: retrieve data

//SERVIZI_DISPONIBILI Grid: check errors @16-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End SERVIZI_DISPONIBILI Grid: check errors

//SERVIZI_DISPONIBILI Grid: method read: tail @16-F575E732
            return ( ! isErrors );
        }
//End SERVIZI_DISPONIBILI Grid: method read: tail

//SERVIZI_DISPONIBILI Grid: method bind @16-B60F3790
        public void bind(com.codecharge.components.Component model, SERVIZI_DISPONIBILIRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            SERVIZI_DISPONIBILIRow row = null;
            while ( counter < rows.length && rows[counter] != null ) {
                row = rows[counter++];
                HashMap hashRow = null;
                com.codecharge.components.Control c = null;
                boolean isNew = false;
                if ( childRows.hasNext() ) {
                    hashRow = (HashMap) childRows.next();
                    if ( hashRow == null ) {
                        hashRow = new HashMap();
                        isNew = true;
                    }
                } else {
                    hashRow = new HashMap();
                    isNew = true;
                }

                c = (com.codecharge.components.Control) hashRow.get("SERVIZIO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("SERVIZIO").clone();
                    c.setValue(row.getSERVIZIO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("RICHIESTA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("RICHIESTA").clone();
                    c.setValue(row.getRICHIESTA());
                    hashRow.put( c.getName(), c );
                }
                ((com.codecharge.components.Link) c).getParameter("ISTANZA").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("ISTANZA").getSourceName(), row ));
                ((com.codecharge.components.Link) c).getParameter("MODULO").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("MODULO").getSourceName(), row ));

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End SERVIZI_DISPONIBILI Grid: method bind

//SERVIZI_DISPONIBILI Directory: getRowFieldByName @16-1D3ACC51
        public Object getRowFieldByName( String name, SERVIZI_DISPONIBILIRow row ) {
            Object value = null;
            if ( "SERVIZIO".equals(name) ) {
                value = row.getSERVIZIO();
            } else if ( "RICHIESTA".equals(name) ) {
                value = row.getRICHIESTA();
            } else if ( "AFCNavigator".equals(name) ) {
                value = row.getAFCNavigator();
            } else if ( "ISTANZA".equals(name) ) {
                value = row.getISTANZA();
            } else if ( "MODULO".equals(name) ) {
                value = row.getMODULO();
            }
            return value;
        }
//End SERVIZI_DISPONIBILI Directory: getRowFieldByName

//SERVIZI_DISPONIBILI Grid: method validate @16-104025BA
        boolean validate() {
            return true;
        }
//End SERVIZI_DISPONIBILI Grid: method validate

//SERVIZI_DISPONIBILI Grid Tail @16-FCB6E20C
    }
//End SERVIZI_DISPONIBILI Grid Tail

//AmvServiziDisponibiliElenco_i Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvServiziDisponibiliElenco_i Page: method validate

//AmvServiziDisponibiliElenco_iAction Tail @1-FCB6E20C
}
//End AmvServiziDisponibiliElenco_iAction Tail



