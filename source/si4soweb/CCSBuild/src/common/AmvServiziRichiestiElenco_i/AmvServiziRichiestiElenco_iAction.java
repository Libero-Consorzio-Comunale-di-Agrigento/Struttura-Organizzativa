//AmvServiziRichiestiElenco_iAction imports @1-8CDA7B14
package common.AmvServiziRichiestiElenco_i;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvServiziRichiestiElenco_iAction imports

//AmvServiziRichiestiElenco_iAction class @1-1B640024
public class AmvServiziRichiestiElenco_iAction extends Action {

//End AmvServiziRichiestiElenco_iAction class

//AmvServiziRichiestiElenco_iAction: method perform @1-065212B9
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvServiziRichiestiElenco_iModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvServiziRichiestiElenco_iModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvServiziRichiestiElenco_iAction: method perform

//AmvServiziRichiestiElenco_iAction: call children actions @1-BE734EA5
        if (result == null) {
            SERVIZI_RICHIESTIClass SERVIZI_RICHIESTI = new SERVIZI_RICHIESTIClass();
            SERVIZI_RICHIESTI.perform(page.getGrid("SERVIZI_RICHIESTI"));
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvServiziRichiestiElenco_iAction: call children actions

//SERVIZI_RICHIESTI Grid @2-A000B914
    final class SERVIZI_RICHIESTIClass {
        com.codecharge.components.Grid model;
        Event e;
//End SERVIZI_RICHIESTI Grid

//SERVIZI_RICHIESTI Grid: method perform @2-B48879D3
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
//End SERVIZI_RICHIESTI Grid: method perform

//SERVIZI_RICHIESTI Grid: method read: head @2-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End SERVIZI_RICHIESTI Grid: method read: head

//SERVIZI_RICHIESTI Grid: method read: init @2-622F9B86
            if ( ! model.allowRead ) return true;
            SERVIZI_RICHIESTIDataObject ds = new SERVIZI_RICHIESTIDataObject(page);
            ds.setComponent( model );
//End SERVIZI_RICHIESTI Grid: method read: init

//SERVIZI_RICHIESTI Grid: set where parameters @2-62166758
            ds.setSesMVUTE( SessionStorage.getInstance(req).getAttribute("MVUTE") );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            try {
                ds.setUrlID( page.getHttpGetParams().getParameter("ID"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID'" );
                return false;
            }
//End SERVIZI_RICHIESTI Grid: set where parameters

//SERVIZI_RICHIESTI Grid: set grid properties @2-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End SERVIZI_RICHIESTI Grid: set grid properties

//SERVIZI_RICHIESTI Grid: retrieve data @2-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End SERVIZI_RICHIESTI Grid: retrieve data

//SERVIZI_RICHIESTI Grid: check errors @2-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End SERVIZI_RICHIESTI Grid: check errors

//SERVIZI_RICHIESTI Grid: method read: tail @2-F575E732
            return ( ! isErrors );
        }
//End SERVIZI_RICHIESTI Grid: method read: tail

//SERVIZI_RICHIESTI Grid: method bind @2-9B3F5097
        public void bind(com.codecharge.components.Component model, SERVIZI_RICHIESTIRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            SERVIZI_RICHIESTIRow row = null;
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
//End SERVIZI_RICHIESTI Grid: method bind

//SERVIZI_RICHIESTI Directory: getRowFieldByName @2-7CDC490D
        public Object getRowFieldByName( String name, SERVIZI_RICHIESTIRow row ) {
            Object value = null;
            if ( "DATA".equals(name) ) {
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
//End SERVIZI_RICHIESTI Directory: getRowFieldByName

//SERVIZI_RICHIESTI Grid: method validate @2-104025BA
        boolean validate() {
            return true;
        }
//End SERVIZI_RICHIESTI Grid: method validate

//SERVIZI_RICHIESTI Grid Tail @2-FCB6E20C
    }
//End SERVIZI_RICHIESTI Grid Tail

//AmvServiziRichiestiElenco_i Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvServiziRichiestiElenco_i Page: method validate

//AmvServiziRichiestiElenco_iAction Tail @1-FCB6E20C
}
//End AmvServiziRichiestiElenco_iAction Tail
