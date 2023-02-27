//AmvGuidaBarAction imports @1-281C9039
package common.AmvGuidaBar;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvGuidaBarAction imports

//AmvGuidaBarAction class @1-DB8A4A6F
public class AmvGuidaBarAction extends Action {

//End AmvGuidaBarAction class

//AmvGuidaBarAction: method perform @1-512F6F11
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvGuidaBarModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvGuidaBarModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvGuidaBarAction: method perform

//AmvGuidaBarAction: call children actions @1-21D6E008
        if (result == null) {
            GuidaClass Guida = new GuidaClass();
            Guida.perform(page.getGrid("Guida"));
        }
        if (result == null) {
            GuidaPropriaClass GuidaPropria = new GuidaPropriaClass();
            GuidaPropria.perform(page.getGrid("GuidaPropria"));
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvGuidaBarAction: call children actions

//Guida Grid @2-3259D32A
    final class GuidaClass {
        com.codecharge.components.Grid model;
        Event e;
//End Guida Grid

//Guida Grid: method perform @2-B48879D3
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
//End Guida Grid: method perform

//Guida Grid: method read: head @2-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End Guida Grid: method read: head

//Guida Grid: method read: init @2-78F89622
            if ( ! model.allowRead ) return true;
            GuidaDataObject ds = new GuidaDataObject(page);
            ds.setComponent( model );
//End Guida Grid: method read: init

//Guida Grid: set where parameters @2-7CC0241D
            ds.setSesMVVC( SessionStorage.getInstance(req).getAttribute("MVVC") );
            ds.setUrlMVID( page.getHttpGetParams().getParameter("MVID") );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setSesIstanza( SessionStorage.getInstance(req).getAttribute("Istanza") );
            ds.setSesProgetto( SessionStorage.getInstance(req).getAttribute("Progetto") );
            ds.setSesMVPC( SessionStorage.getInstance(req).getAttribute("MVPC") );
            ds.setSesMVCONTEXT( SessionStorage.getInstance(req).getAttribute("MVCONTEXT") );
//End Guida Grid: set where parameters

//Guida Grid: set grid properties @2-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End Guida Grid: set grid properties

//Guida Grid: retrieve data @2-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End Guida Grid: retrieve data

//Guida Grid: check errors @2-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End Guida Grid: check errors

//Guida Grid: method read: tail @2-F575E732
            return ( ! isErrors );
        }
//End Guida Grid: method read: tail

//Guida Grid: method bind @2-6F2F9DAF
        public void bind(com.codecharge.components.Component model, GuidaRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            GuidaRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("SEPARATORE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("SEPARATORE").clone();
                    c.setValue(row.getSEPARATORE());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("GUIDA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("GUIDA").clone();
                    c.setValue(row.getGUIDA());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End Guida Grid: method bind

//Guida Directory: getRowFieldByName @2-FCD88E2E
        public Object getRowFieldByName( String name, GuidaRow row ) {
            Object value = null;
            if ( "SEPARATORE".equals(name) ) {
                value = row.getSEPARATORE();
            } else if ( "GUIDA".equals(name) ) {
                value = row.getGUIDA();
            } else if ( "ID".equals(name) ) {
                value = row.getID();
            } else if ( "SEQUENZA".equals(name) ) {
                value = row.getSEQUENZA();
            } else if ( "STRINGA".equals(name) ) {
                value = row.getSTRINGA();
            }
            return value;
        }
//End Guida Directory: getRowFieldByName

//Guida Grid: method validate @2-104025BA
        boolean validate() {
            return true;
        }
//End Guida Grid: method validate

//Guida Grid Tail @2-FCB6E20C
    }
//End Guida Grid Tail

//GuidaPropria Grid @13-4A4ACC04
    final class GuidaPropriaClass {
        com.codecharge.components.Grid model;
        Event e;
//End GuidaPropria Grid

//GuidaPropria Grid: method perform @13-B48879D3
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
//End GuidaPropria Grid: method perform

//GuidaPropria Grid: method read: head @13-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End GuidaPropria Grid: method read: head

//GuidaPropria Grid: method read: init @13-68EC5C73
            if ( ! model.allowRead ) return true;
            GuidaPropriaDataObject ds = new GuidaPropriaDataObject(page);
            ds.setComponent( model );
//End GuidaPropria Grid: method read: init

//GuidaPropria Grid: set where parameters @13-BD71A316
            ds.setSesMVVC( SessionStorage.getInstance(req).getAttribute("MVVC") );
            ds.setUrlMVID( page.getHttpGetParams().getParameter("MVID") );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setSesIstanza( SessionStorage.getInstance(req).getAttribute("Istanza") );
            ds.setSesProgetto( SessionStorage.getInstance(req).getAttribute("Progetto") );
            ds.setUrlMVID2( page.getHttpGetParams().getParameter("MVID2") );
            ds.setSesMVPC( SessionStorage.getInstance(req).getAttribute("MVPC") );
            ds.setSesMVCONTEXT( SessionStorage.getInstance(req).getAttribute("MVCONTEXT") );
//End GuidaPropria Grid: set where parameters

//GuidaPropria Grid: set grid properties @13-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End GuidaPropria Grid: set grid properties

//GuidaPropria Grid: retrieve data @13-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End GuidaPropria Grid: retrieve data

//GuidaPropria Grid: check errors @13-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End GuidaPropria Grid: check errors

//GuidaPropria Grid: method read: tail @13-F575E732
            return ( ! isErrors );
        }
//End GuidaPropria Grid: method read: tail

//GuidaPropria Grid: method bind @13-F7533766
        public void bind(com.codecharge.components.Component model, GuidaPropriaRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            GuidaPropriaRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("SEPARATORE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("SEPARATORE").clone();
                    c.setValue(row.getSEPARATORE());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("GUIDA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("GUIDA").clone();
                    c.setValue(row.getGUIDA());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End GuidaPropria Grid: method bind

//GuidaPropria Directory: getRowFieldByName @13-5B403333
        public Object getRowFieldByName( String name, GuidaPropriaRow row ) {
            Object value = null;
            if ( "SEPARATORE".equals(name) ) {
                value = row.getSEPARATORE();
            } else if ( "GUIDA".equals(name) ) {
                value = row.getGUIDA();
            } else if ( "ID".equals(name) ) {
                value = row.getID();
            } else if ( "SEQUENZA".equals(name) ) {
                value = row.getSEQUENZA();
            } else if ( "STRINGA".equals(name) ) {
                value = row.getSTRINGA();
            }
            return value;
        }
//End GuidaPropria Directory: getRowFieldByName

//GuidaPropria Grid: method validate @13-104025BA
        boolean validate() {
            return true;
        }
//End GuidaPropria Grid: method validate

//GuidaPropria Grid Tail @13-FCB6E20C
    }
//End GuidaPropria Grid Tail

//AmvGuidaBar Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvGuidaBar Page: method validate

//AmvGuidaBarAction Tail @1-FCB6E20C
}
//End AmvGuidaBarAction Tail


