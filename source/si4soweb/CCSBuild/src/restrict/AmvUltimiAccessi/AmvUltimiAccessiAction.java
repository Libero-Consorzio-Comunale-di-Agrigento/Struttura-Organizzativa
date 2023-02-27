//AmvUltimiAccessiAction imports @1-2AD93C49
package restrict.AmvUltimiAccessi;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvUltimiAccessiAction imports

//AmvUltimiAccessiAction class @1-5B476379
public class AmvUltimiAccessiAction extends Action {

//End AmvUltimiAccessiAction class

//AmvUltimiAccessiAction: method perform @1-3E9819A4
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvUltimiAccessiModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvUltimiAccessiModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvUltimiAccessiAction: method perform

//AmvUltimiAccessiAction: call children actions @1-FDEB14C0
        if ( page.getChild( "Header" ).isVisible() ) {
            page.getRequest().setAttribute("HeaderParent",page);
            common.Header.HeaderAction Header = new common.Header.HeaderAction();
            result = result != null ? result : Header.perform( req, resp,  context );
            page.setCookies();
        }
        if ( page.getChild( "Left" ).isVisible() ) {
            page.getRequest().setAttribute("LeftParent",page);
            common.Left.LeftAction Left = new common.Left.LeftAction();
            result = result != null ? result : Left.perform( req, resp,  context );
            page.setCookies();
        }
        if ( page.getChild( "AmvGuida" ).isVisible() ) {
            page.getRequest().setAttribute("AmvGuidaParent",page);
            common.AmvGuida.AmvGuidaAction AmvGuida = new common.AmvGuida.AmvGuidaAction();
            result = result != null ? result : AmvGuida.perform( req, resp,  context );
            page.setCookies();
        }
        if (result == null) {
            AccessiElencoClass AccessiElenco = new AccessiElencoClass();
            AccessiElenco.perform(page.getGrid("AccessiElenco"));
        }
        if (result == null) {
            AD4_SERVIZIO_SELClass AD4_SERVIZIO_SEL = new AD4_SERVIZIO_SELClass();
            AD4_SERVIZIO_SEL.perform(page.getGrid("AD4_SERVIZIO_SEL"));
        }
        if (result == null) {
            AccessiDettaglioClass AccessiDettaglio = new AccessiDettaglioClass();
            AccessiDettaglio.perform(page.getGrid("AccessiDettaglio"));
        }
        if ( page.getChild( "Footer" ).isVisible() ) {
            page.getRequest().setAttribute("FooterParent",page);
            common.Footer.FooterAction Footer = new common.Footer.FooterAction();
            result = result != null ? result : Footer.perform( req, resp,  context );
            page.setCookies();
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvUltimiAccessiAction: call children actions

//AccessiElenco Grid @6-8FC51139
    final class AccessiElencoClass {
        com.codecharge.components.Grid model;
        Event e;
//End AccessiElenco Grid

//AccessiElenco Grid: method perform @6-B48879D3
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
//End AccessiElenco Grid: method perform

//AccessiElenco Grid: method read: head @6-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End AccessiElenco Grid: method read: head

//AccessiElenco Grid: method read: init @6-1223C023
            if ( ! model.allowRead ) return true;
            AccessiElencoDataObject ds = new AccessiElencoDataObject(page);
            ds.setComponent( model );
//End AccessiElenco Grid: method read: init

//AccessiElenco Grid: set where parameters @6-2B0125CF
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setSesProgetto( SessionStorage.getInstance(req).getAttribute("Progetto") );
//End AccessiElenco Grid: set where parameters

//AccessiElenco Grid: set grid properties @6-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End AccessiElenco Grid: set grid properties

//AccessiElenco Grid: retrieve data @6-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End AccessiElenco Grid: retrieve data

//AccessiElenco Grid: check errors @6-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End AccessiElenco Grid: check errors

//AccessiElenco Grid: method read: tail @6-F575E732
            return ( ! isErrors );
        }
//End AccessiElenco Grid: method read: tail

//AccessiElenco Grid: method bind @6-8E5AEC07
        public void bind(com.codecharge.components.Component model, AccessiElencoRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            AccessiElencoRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("DES_ACCESSO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("DES_ACCESSO").clone();
                    c.setValue(row.getDES_ACCESSO());
                    hashRow.put( c.getName(), c );
                }
                ((com.codecharge.components.Link) c).getParameter("DES_ACCESSO").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("DES_ACCESSO").getSourceName(), row ));
                ((com.codecharge.components.Link) c).getParameter("DES_SERVIZIO").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("DES_SERVIZIO").getSourceName(), row ));

                c = (com.codecharge.components.Control) hashRow.get("DES_SERVIZIO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("DES_SERVIZIO").clone();
                    c.setValue(row.getDES_SERVIZIO());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End AccessiElenco Grid: method bind

//AccessiElenco Directory: getRowFieldByName @6-1304D0D8
        public Object getRowFieldByName( String name, AccessiElencoRow row ) {
            Object value = null;
            if ( "DES_ACCESSO".equals(name) ) {
                value = row.getDES_ACCESSO();
            } else if ( "DES_SERVIZIO".equals(name) ) {
                value = row.getDES_SERVIZIO();
            } else if ( "AFCNavigator".equals(name) ) {
                value = row.getAFCNavigator();
            }
            return value;
        }
//End AccessiElenco Directory: getRowFieldByName

//AccessiElenco Grid: method validate @6-104025BA
        boolean validate() {
            return true;
        }
//End AccessiElenco Grid: method validate

//AccessiElenco Grid Tail @6-FCB6E20C
    }
//End AccessiElenco Grid Tail

//AD4_SERVIZIO_SEL Grid @23-B58FB1CB
    final class AD4_SERVIZIO_SELClass {
        com.codecharge.components.Grid model;
        Event e;
//End AD4_SERVIZIO_SEL Grid

//AD4_SERVIZIO_SEL Grid: method perform @23-B48879D3
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
//End AD4_SERVIZIO_SEL Grid: method perform

//AD4_SERVIZIO_SEL Grid: method read: head @23-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End AD4_SERVIZIO_SEL Grid: method read: head

//AD4_SERVIZIO_SEL Grid: method read: init @23-3293D765
            if ( ! model.allowRead ) return true;
            AD4_SERVIZIO_SELDataObject ds = new AD4_SERVIZIO_SELDataObject(page);
            ds.setComponent( model );
//End AD4_SERVIZIO_SEL Grid: method read: init

//AD4_SERVIZIO_SEL Grid: set where parameters @23-D2406AF3
            ds.setUrlDES_ACCESSO( page.getHttpGetParams().getParameter("DES_ACCESSO") );
            ds.setUrlDES_SERVIZIO( page.getHttpGetParams().getParameter("DES_SERVIZIO") );
//End AD4_SERVIZIO_SEL Grid: set where parameters

//AD4_SERVIZIO_SEL Grid: set grid properties @23-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End AD4_SERVIZIO_SEL Grid: set grid properties

//AD4_SERVIZIO_SEL Grid: retrieve data @23-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End AD4_SERVIZIO_SEL Grid: retrieve data

//AD4_SERVIZIO_SEL Grid: check errors @23-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End AD4_SERVIZIO_SEL Grid: check errors

//AD4_SERVIZIO_SEL Grid: method read: tail @23-F575E732
            return ( ! isErrors );
        }
//End AD4_SERVIZIO_SEL Grid: method read: tail

//AD4_SERVIZIO_SEL Grid: method bind @23-ACB1794B
        public void bind(com.codecharge.components.Component model, AD4_SERVIZIO_SELRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            AD4_SERVIZIO_SELRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("DES_ACCESSO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("DES_ACCESSO").clone();
                    c.setValue(row.getDES_ACCESSO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("DES_SERVIZIO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("DES_SERVIZIO").clone();
                    c.setValue(row.getDES_SERVIZIO());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End AD4_SERVIZIO_SEL Grid: method bind

//AD4_SERVIZIO_SEL Directory: getRowFieldByName @23-C9317F0F
        public Object getRowFieldByName( String name, AD4_SERVIZIO_SELRow row ) {
            Object value = null;
            if ( "DES_ACCESSO".equals(name) ) {
                value = row.getDES_ACCESSO();
            } else if ( "DES_SERVIZIO".equals(name) ) {
                value = row.getDES_SERVIZIO();
            }
            return value;
        }
//End AD4_SERVIZIO_SEL Directory: getRowFieldByName

//AD4_SERVIZIO_SEL Grid: method validate @23-104025BA
        boolean validate() {
            return true;
        }
//End AD4_SERVIZIO_SEL Grid: method validate

//AD4_SERVIZIO_SEL Grid Tail @23-FCB6E20C
    }
//End AD4_SERVIZIO_SEL Grid Tail

//AccessiDettaglio Grid @14-B9D84E55
    final class AccessiDettaglioClass {
        com.codecharge.components.Grid model;
        Event e;
//End AccessiDettaglio Grid

//AccessiDettaglio Grid: method perform @14-B48879D3
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
//End AccessiDettaglio Grid: method perform

//AccessiDettaglio Grid: method read: head @14-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End AccessiDettaglio Grid: method read: head

//AccessiDettaglio Grid: method read: init @14-F851FE6A
            if ( ! model.allowRead ) return true;
            AccessiDettaglioDataObject ds = new AccessiDettaglioDataObject(page);
            ds.setComponent( model );
//End AccessiDettaglio Grid: method read: init

//AccessiDettaglio Grid: set where parameters @14-CA667F0E
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setUrlDES_ACCESSO( page.getHttpGetParams().getParameter("DES_ACCESSO") );
            ds.setUrlDES_SERVIZIO( page.getHttpGetParams().getParameter("DES_SERVIZIO") );
            ds.setSesProgetto( SessionStorage.getInstance(req).getAttribute("Progetto") );
//End AccessiDettaglio Grid: set where parameters

//AccessiDettaglio Grid: set grid properties @14-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End AccessiDettaglio Grid: set grid properties

//AccessiDettaglio Grid: retrieve data @14-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End AccessiDettaglio Grid: retrieve data

//AccessiDettaglio Grid: check errors @14-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End AccessiDettaglio Grid: check errors

//AccessiDettaglio Grid: method read: tail @14-F575E732
            return ( ! isErrors );
        }
//End AccessiDettaglio Grid: method read: tail

//AccessiDettaglio Grid: method bind @14-859D3BD6
        public void bind(com.codecharge.components.Component model, AccessiDettaglioRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            AccessiDettaglioRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("DES_ACCESSO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("DES_ACCESSO").clone();
                    c.setValue(row.getDES_ACCESSO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("DES_ORA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("DES_ORA").clone();
                    c.setValue(row.getDES_ORA());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("DSP_SESSIONE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("DSP_SESSIONE").clone();
                    c.setValue(row.getDSP_SESSIONE());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End AccessiDettaglio Grid: method bind

//AccessiDettaglio Directory: getRowFieldByName @14-407EF29B
        public Object getRowFieldByName( String name, AccessiDettaglioRow row ) {
            Object value = null;
            if ( "DES_ACCESSO".equals(name) ) {
                value = row.getDES_ACCESSO();
            } else if ( "DES_ORA".equals(name) ) {
                value = row.getDES_ORA();
            } else if ( "DSP_SESSIONE".equals(name) ) {
                value = row.getDSP_SESSIONE();
            } else if ( "AFCNavigator".equals(name) ) {
                value = row.getAFCNavigator();
            }
            return value;
        }
//End AccessiDettaglio Directory: getRowFieldByName

//AccessiDettaglio Grid: method validate @14-104025BA
        boolean validate() {
            return true;
        }
//End AccessiDettaglio Grid: method validate

//AccessiDettaglio Grid Tail @14-FCB6E20C
    }
//End AccessiDettaglio Grid Tail

//AmvUltimiAccessi Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvUltimiAccessi Page: method validate

//AmvUltimiAccessiAction Tail @1-FCB6E20C
}
//End AmvUltimiAccessiAction Tail

