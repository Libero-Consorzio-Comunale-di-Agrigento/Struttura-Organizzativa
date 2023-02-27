



//AmvServiziAbilitatiElenco_iAction imports @1-58204282
package common.AmvServiziAbilitatiElenco_i;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvServiziAbilitatiElenco_iAction imports

//AmvServiziAbilitatiElenco_iAction class @1-344A52D4
public class AmvServiziAbilitatiElenco_iAction extends Action {

//End AmvServiziAbilitatiElenco_iAction class

//AmvServiziAbilitatiElenco_iAction: method perform @1-3747F392
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvServiziAbilitatiElenco_iModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvServiziAbilitatiElenco_iModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvServiziAbilitatiElenco_iAction: method perform

//AmvServiziAbilitatiElenco_iAction: call children actions @1-B864B79B
        if (result == null) {
            SERVIZI_ABILITATIClass SERVIZI_ABILITATI = new SERVIZI_ABILITATIClass();
            SERVIZI_ABILITATI.perform(page.getGrid("SERVIZI_ABILITATI"));
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvServiziAbilitatiElenco_iAction: call children actions

//SERVIZI_ABILITATI Grid @10-BC4E5F17
    final class SERVIZI_ABILITATIClass {
        com.codecharge.components.Grid model;
        Event e;
//End SERVIZI_ABILITATI Grid

//SERVIZI_ABILITATI Grid: method perform @10-B48879D3
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
//End SERVIZI_ABILITATI Grid: method perform

//SERVIZI_ABILITATI Grid: method read: head @10-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End SERVIZI_ABILITATI Grid: method read: head

//SERVIZI_ABILITATI Grid: method read: init @10-CED0D39A
            if ( ! model.allowRead ) return true;
            SERVIZI_ABILITATIDataObject ds = new SERVIZI_ABILITATIDataObject(page);
            ds.setComponent( model );
//End SERVIZI_ABILITATI Grid: method read: init

//SERVIZI_ABILITATI Grid: set where parameters @10-20D1D62B
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setSesMVUTE( SessionStorage.getInstance(req).getAttribute("MVUTE") );
            ds.setSesProgetto( SessionStorage.getInstance(req).getAttribute("Progetto") );
            try {
                ds.setUrlID( page.getHttpGetParams().getParameter("ID"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID'" );
                return false;
            }
//End SERVIZI_ABILITATI Grid: set where parameters

//SERVIZI_ABILITATI Grid: set grid properties @10-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End SERVIZI_ABILITATI Grid: set grid properties

//SERVIZI_ABILITATI Grid: retrieve data @10-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End SERVIZI_ABILITATI Grid: retrieve data

//SERVIZI_ABILITATI Grid: check errors @10-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End SERVIZI_ABILITATI Grid: check errors

//SERVIZI_ABILITATI Grid: method read: tail @10-F575E732
            return ( ! isErrors );
        }
//End SERVIZI_ABILITATI Grid: method read: tail

//SERVIZI_ABILITATI Grid: method bind @10-9F2CFD50
        public void bind(com.codecharge.components.Component model, SERVIZI_ABILITATIRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            SERVIZI_ABILITATIRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("DATA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("DATA").clone();
                    c.setValue(row.getDATA());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("SERVIZIO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("SERVIZIO").clone();
                    c.setValue(row.getSERVIZIO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("NOTIFICA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("NOTIFICA").clone();
                    c.setValue(row.getNOTIFICA());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("AZIENDA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("AZIENDA").clone();
                    c.setValue(row.getAZIENDA());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End SERVIZI_ABILITATI Grid: method bind

//SERVIZI_ABILITATI Directory: getRowFieldByName @10-B70DD422
        public Object getRowFieldByName( String name, SERVIZI_ABILITATIRow row ) {
            Object value = null;
            if ( "Label1".equals(name) ) {
                value = row.getLabel1();
            } else if ( "DATA".equals(name) ) {
                value = row.getDATA();
            } else if ( "SERVIZIO".equals(name) ) {
                value = row.getSERVIZIO();
            } else if ( "NOTIFICA".equals(name) ) {
                value = row.getNOTIFICA();
            } else if ( "AZIENDA".equals(name) ) {
                value = row.getAZIENDA();
            } else if ( "AFCNavigator".equals(name) ) {
                value = row.getAFCNavigator();
            }
            return value;
        }
//End SERVIZI_ABILITATI Directory: getRowFieldByName

//SERVIZI_ABILITATI Grid: method validate @10-104025BA
        boolean validate() {
            return true;
        }
//End SERVIZI_ABILITATI Grid: method validate

//SERVIZI_ABILITATI Grid Tail @10-FCB6E20C
    }
//End SERVIZI_ABILITATI Grid Tail

//AmvServiziAbilitatiElenco_i Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvServiziAbilitatiElenco_i Page: method validate

//AmvServiziAbilitatiElenco_iAction Tail @1-FCB6E20C
}
//End AmvServiziAbilitatiElenco_iAction Tail



