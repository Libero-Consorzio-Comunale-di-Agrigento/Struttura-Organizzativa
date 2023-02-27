//AdmRichiesteAction imports @1-92D6BA1E
package amvadm.AdmRichieste;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmRichiesteAction imports

//AdmRichiesteAction class @1-2ED6EBB0
public class AdmRichiesteAction extends Action {

//End AdmRichiesteAction class

//AdmRichiesteAction: method perform @1-BE489A09
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AdmRichiesteModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AdmRichiesteModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AdmRichiesteAction: method perform

//AdmRichiesteAction: call children actions @1-7107C4F9
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
        if ( page.getChild( "Guida" ).isVisible() ) {
            page.getRequest().setAttribute("GuidaParent",page);
            common.Guida.GuidaAction Guida = new common.Guida.GuidaAction();
            result = result != null ? result : Guida.perform( req, resp,  context );
            page.setCookies();
        }
        if (result == null) {
            TITLEGridClass TITLEGrid = new TITLEGridClass();
            TITLEGrid.perform(page.getGrid("TITLEGrid"));
        }
        if (result == null) {
            AD4_RICHIESTE_ABILITAZIONEClass AD4_RICHIESTE_ABILITAZIONE = new AD4_RICHIESTE_ABILITAZIONEClass();
            AD4_RICHIESTE_ABILITAZIONE.perform(page.getGrid("AD4_RICHIESTE_ABILITAZIONE"));
        }
        if (result == null) {
            AD4_SERVIZIO_SELClass AD4_SERVIZIO_SEL = new AD4_SERVIZIO_SELClass();
            AD4_SERVIZIO_SEL.perform(page.getGrid("AD4_SERVIZIO_SEL"));
        }
        if (result == null) {
            AD4_RICHIESTE_SERVIZIOClass AD4_RICHIESTE_SERVIZIO = new AD4_RICHIESTE_SERVIZIOClass();
            AD4_RICHIESTE_SERVIZIO.perform(page.getGrid("AD4_RICHIESTE_SERVIZIO"));
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
//End AdmRichiesteAction: call children actions

//TITLEGrid Grid @148-58BEAD48
    final class TITLEGridClass {
        com.codecharge.components.Grid model;
        Event e;
//End TITLEGrid Grid

//TITLEGrid Grid: method perform @148-B48879D3
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
//End TITLEGrid Grid: method perform

//TITLEGrid Grid: method read: head @148-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End TITLEGrid Grid: method read: head

//TITLEGrid Grid: method read: init @148-96EAF3B0
            if ( ! model.allowRead ) return true;
            TITLEGridDataObject ds = new TITLEGridDataObject(page);
            ds.setComponent( model );
//End TITLEGrid Grid: method read: init

//TITLEGrid Grid: set where parameters @148-D037C9AC
            ds.setUrlMVAV( page.getHttpGetParams().getParameter("MVAV") );
//End TITLEGrid Grid: set where parameters

//TITLEGrid Grid: set grid properties @148-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End TITLEGrid Grid: set grid properties

//TITLEGrid Grid: retrieve data @148-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End TITLEGrid Grid: retrieve data

//TITLEGrid Grid: check errors @148-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End TITLEGrid Grid: check errors

//TITLEGrid Grid: method read: tail @148-F575E732
            return ( ! isErrors );
        }
//End TITLEGrid Grid: method read: tail

//TITLEGrid Grid: method bind @148-D760C0A1
        public void bind(com.codecharge.components.Component model, TITLEGridRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            TITLEGridRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("STATO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("STATO").clone();
                    c.setValue(row.getSTATO());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End TITLEGrid Grid: method bind

//TITLEGrid Directory: getRowFieldByName @148-23050FBB
        public Object getRowFieldByName( String name, TITLEGridRow row ) {
            Object value = null;
            if ( "STATO".equals(name) ) {
                value = row.getSTATO();
            }
            return value;
        }
//End TITLEGrid Directory: getRowFieldByName

//TITLEGrid Grid: method validate @148-104025BA
        boolean validate() {
            return true;
        }
//End TITLEGrid Grid: method validate

//TITLEGrid Grid Tail @148-FCB6E20C
    }
//End TITLEGrid Grid Tail

//AD4_RICHIESTE_ABILITAZIONE Grid @30-73F59F44
    final class AD4_RICHIESTE_ABILITAZIONEClass {
        com.codecharge.components.Grid model;
        Event e;
//End AD4_RICHIESTE_ABILITAZIONE Grid

//AD4_RICHIESTE_ABILITAZIONE Grid: method perform @30-B48879D3
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
//End AD4_RICHIESTE_ABILITAZIONE Grid: method perform

//AD4_RICHIESTE_ABILITAZIONE Grid: method read: head @30-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End AD4_RICHIESTE_ABILITAZIONE Grid: method read: head

//AD4_RICHIESTE_ABILITAZIONE Grid: method read: init @30-36FAA7B1
            if ( ! model.allowRead ) return true;
            AD4_RICHIESTE_ABILITAZIONEDataObject ds = new AD4_RICHIESTE_ABILITAZIONEDataObject(page);
            ds.setComponent( model );
//End AD4_RICHIESTE_ABILITAZIONE Grid: method read: init

//AD4_RICHIESTE_ABILITAZIONE Grid: set where parameters @30-4B5D99F1
            try {
                ds.setUrlMVAV( page.getHttpGetParams().getParameter("MVAV"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVAV'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVAV'" );
                return false;
            }
            try {
                ds.setSesGroupID( SessionStorage.getInstance(req).getAttribute("GroupID"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'GroupID'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'GroupID'" );
                return false;
            }
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
//End AD4_RICHIESTE_ABILITAZIONE Grid: set where parameters

//AD4_RICHIESTE_ABILITAZIONE Grid: set grid properties @30-CD130E8B
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
            Hashtable sortAscColumns = new Hashtable();
            Hashtable sortDescColumns = new Hashtable();
            sortAscColumns.put( "Sorter_SERVIZIO", "SERVIZIO" );
            if ( ! StringUtils.isEmpty( model.getSort() ) ) {
                if ( "desc".equalsIgnoreCase(model.getDir())) {
                    if ( sortDescColumns.get( model.getSort() ) != null  && "desc".equalsIgnoreCase(model.getDir())) {
                        ds.setOrderBy( (String) sortDescColumns.get( model.getSort() ) );
                    } else {
                        ds.setOrderBy( (String) sortAscColumns.get( model.getSort() ) + " DESC " );
                    }
                } else {
                    ds.setOrderBy( (String) sortAscColumns.get( model.getSort() ) );
                }
            }
//End AD4_RICHIESTE_ABILITAZIONE Grid: set grid properties

//AD4_RICHIESTE_ABILITAZIONE Grid: retrieve data @30-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End AD4_RICHIESTE_ABILITAZIONE Grid: retrieve data

//AD4_RICHIESTE_ABILITAZIONE Grid: check errors @30-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End AD4_RICHIESTE_ABILITAZIONE Grid: check errors

//AD4_RICHIESTE_ABILITAZIONE Grid: method read: tail @30-F575E732
            return ( ! isErrors );
        }
//End AD4_RICHIESTE_ABILITAZIONE Grid: method read: tail

//AD4_RICHIESTE_ABILITAZIONE Grid: method bind @30-79CF9EAD
        public void bind(com.codecharge.components.Component model, AD4_RICHIESTE_ABILITAZIONERow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            AD4_RICHIESTE_ABILITAZIONERow row = null;
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
                ((com.codecharge.components.Link) c).getParameter("MOD").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("MOD").getSourceName(), row ));
                ((com.codecharge.components.Link) c).getParameter("IST").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("IST").getSourceName(), row ));
                ((com.codecharge.components.Link) c).getParameter("STATO").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("STATO").getSourceName(), row ));

                c = (com.codecharge.components.Control) hashRow.get("ABILITAZIONE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("ABILITAZIONE").clone();
                    c.setValue(row.getABILITAZIONE());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("LIVELLO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("LIVELLO").clone();
                    c.setValue(row.getLIVELLO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("TOTALE_RICHIESTE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("TOTALE_RICHIESTE").clone();
                    c.setValue(row.getTOTALE_RICHIESTE());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End AD4_RICHIESTE_ABILITAZIONE Grid: method bind

//AD4_RICHIESTE_ABILITAZIONE Directory: getRowFieldByName @30-C10A75D6
        public Object getRowFieldByName( String name, AD4_RICHIESTE_ABILITAZIONERow row ) {
            Object value = null;
            if ( "SERVIZIO".equals(name) ) {
                value = row.getSERVIZIO();
            } else if ( "ABILITAZIONE".equals(name) ) {
                value = row.getABILITAZIONE();
            } else if ( "LIVELLO".equals(name) ) {
                value = row.getLIVELLO();
            } else if ( "TOTALE_RICHIESTE".equals(name) ) {
                value = row.getTOTALE_RICHIESTE();
            } else if ( "AFCNavigator".equals(name) ) {
                value = row.getAFCNavigator();
            } else if ( "MOD".equals(name) ) {
                value = row.getMOD();
            } else if ( "MODULO".equals(name) ) {
                value = row.getMODULO();
            } else if ( "IST".equals(name) ) {
                value = row.getIST();
            } else if ( "ISTANZA".equals(name) ) {
                value = row.getISTANZA();
            } else if ( "STATO".equals(name) ) {
                value = row.getSTATO();
            }
            return value;
        }
//End AD4_RICHIESTE_ABILITAZIONE Directory: getRowFieldByName

//AD4_RICHIESTE_ABILITAZIONE Grid: method validate @30-104025BA
        boolean validate() {
            return true;
        }
//End AD4_RICHIESTE_ABILITAZIONE Grid: method validate

//AD4_RICHIESTE_ABILITAZIONE Grid Tail @30-FCB6E20C
    }
//End AD4_RICHIESTE_ABILITAZIONE Grid Tail

//AD4_SERVIZIO_SEL Grid @98-B58FB1CB
    final class AD4_SERVIZIO_SELClass {
        com.codecharge.components.Grid model;
        Event e;
//End AD4_SERVIZIO_SEL Grid

//AD4_SERVIZIO_SEL Grid: method perform @98-B48879D3
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

//AD4_SERVIZIO_SEL Grid: method read: head @98-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End AD4_SERVIZIO_SEL Grid: method read: head

//AD4_SERVIZIO_SEL Grid: method read: init @98-3293D765
            if ( ! model.allowRead ) return true;
            AD4_SERVIZIO_SELDataObject ds = new AD4_SERVIZIO_SELDataObject(page);
            ds.setComponent( model );
//End AD4_SERVIZIO_SEL Grid: method read: init

//AD4_SERVIZIO_SEL Grid: set where parameters @98-B26B8AD8
            ds.setUrlMOD( page.getHttpGetParams().getParameter("MOD") );
            ds.setUrlIST( page.getHttpGetParams().getParameter("IST") );
//End AD4_SERVIZIO_SEL Grid: set where parameters

//AD4_SERVIZIO_SEL Grid: set grid properties @98-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End AD4_SERVIZIO_SEL Grid: set grid properties

//AD4_SERVIZIO_SEL Grid: retrieve data @98-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End AD4_SERVIZIO_SEL Grid: retrieve data

//AD4_SERVIZIO_SEL Grid: check errors @98-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End AD4_SERVIZIO_SEL Grid: check errors

//AD4_SERVIZIO_SEL Grid: method read: tail @98-F575E732
            return ( ! isErrors );
        }
//End AD4_SERVIZIO_SEL Grid: method read: tail

//AD4_SERVIZIO_SEL Grid: method bind @98-6A634C85
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

                c = (com.codecharge.components.Control) hashRow.get("SERVIZIO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("SERVIZIO").clone();
                    c.setValue(row.getSERVIZIO());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End AD4_SERVIZIO_SEL Grid: method bind

//AD4_SERVIZIO_SEL Directory: getRowFieldByName @98-48389506
        public Object getRowFieldByName( String name, AD4_SERVIZIO_SELRow row ) {
            Object value = null;
            if ( "SERVIZIO".equals(name) ) {
                value = row.getSERVIZIO();
            }
            return value;
        }
//End AD4_SERVIZIO_SEL Directory: getRowFieldByName

//AD4_SERVIZIO_SEL Grid: method validate @98-104025BA
        boolean validate() {
            return true;
        }
//End AD4_SERVIZIO_SEL Grid: method validate

//AD4_SERVIZIO_SEL Grid Tail @98-FCB6E20C
    }
//End AD4_SERVIZIO_SEL Grid Tail

//AD4_RICHIESTE_SERVIZIO Grid @123-EB433DA6
    final class AD4_RICHIESTE_SERVIZIOClass {
        com.codecharge.components.Grid model;
        Event e;
//End AD4_RICHIESTE_SERVIZIO Grid

//AD4_RICHIESTE_SERVIZIO Grid: method perform @123-B48879D3
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
//End AD4_RICHIESTE_SERVIZIO Grid: method perform

//AD4_RICHIESTE_SERVIZIO Grid: method read: head @123-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End AD4_RICHIESTE_SERVIZIO Grid: method read: head

//AD4_RICHIESTE_SERVIZIO Grid: method read: init @123-218DA34C
            if ( ! model.allowRead ) return true;
            AD4_RICHIESTE_SERVIZIODataObject ds = new AD4_RICHIESTE_SERVIZIODataObject(page);
            ds.setComponent( model );
//End AD4_RICHIESTE_SERVIZIO Grid: method read: init

//AD4_RICHIESTE_SERVIZIO Grid: set where parameters @123-936350AE
            ds.setUrlSTATO( page.getHttpGetParams().getParameter("STATO") );
            try {
                ds.setSesGroupID( SessionStorage.getInstance(req).getAttribute("GroupID"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'GroupID'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'GroupID'" );
                return false;
            }
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setUrlMOD( page.getHttpGetParams().getParameter("MOD") );
            ds.setUrlIST( page.getHttpGetParams().getParameter("IST") );
//End AD4_RICHIESTE_SERVIZIO Grid: set where parameters

//AD4_RICHIESTE_SERVIZIO Grid: set grid properties @123-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End AD4_RICHIESTE_SERVIZIO Grid: set grid properties

//AD4_RICHIESTE_SERVIZIO Grid: retrieve data @123-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End AD4_RICHIESTE_SERVIZIO Grid: retrieve data

//AD4_RICHIESTE_SERVIZIO Grid: check errors @123-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End AD4_RICHIESTE_SERVIZIO Grid: check errors

//AD4_RICHIESTE_SERVIZIO Grid: method read: tail @123-F575E732
            return ( ! isErrors );
        }
//End AD4_RICHIESTE_SERVIZIO Grid: method read: tail

//AD4_RICHIESTE_SERVIZIO Grid: method bind @123-CF866C0D
        public void bind(com.codecharge.components.Component model, AD4_RICHIESTE_SERVIZIORow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            AD4_RICHIESTE_SERVIZIORow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("AUTORE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("AUTORE").clone();
                    c.setValue(row.getAUTORE());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("INDIRIZZO_WEB");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("INDIRIZZO_WEB").clone();
                    c.setValue(row.getINDIRIZZO_WEB());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("INDIRIZZO_NOTIFICA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("INDIRIZZO_NOTIFICA").clone();
                    c.setValue(row.getINDIRIZZO_NOTIFICA());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("NOTIFICATA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("NOTIFICATA").clone();
                    c.setValue(row.getNOTIFICATA());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("AZIENDA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("AZIENDA").clone();
                    c.setValue(row.getAZIENDA());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("APPROVA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("APPROVA").clone();
                    c.setValue(row.getAPPROVA());
                    hashRow.put( c.getName(), c );
                }
                ((com.codecharge.components.Link) c).getParameter("ID").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("ID").getSourceName(), row ));
                ((com.codecharge.components.Link) c).getParameter("AB").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("AB").getSourceName(), row ));

                c = (com.codecharge.components.Control) hashRow.get("RESPINGI");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("RESPINGI").clone();
                    c.setValue(row.getRESPINGI());
                    hashRow.put( c.getName(), c );
                }
                ((com.codecharge.components.Link) c).getParameter("ID").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("ID").getSourceName(), row ));
                ((com.codecharge.components.Link) c).getParameter("AB").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("AB").getSourceName(), row ));

                c = (com.codecharge.components.Control) hashRow.get("NOTIFICA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("NOTIFICA").clone();
                    c.setValue(row.getNOTIFICA());
                    hashRow.put( c.getName(), c );
                }
                ((com.codecharge.components.Link) c).getParameter("ID").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("ID").getSourceName(), row ));
                ((com.codecharge.components.Link) c).getParameter("AB").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("AB").getSourceName(), row ));

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End AD4_RICHIESTE_SERVIZIO Grid: method bind

//AD4_RICHIESTE_SERVIZIO Directory: getRowFieldByName @123-A2FC3C93
        public Object getRowFieldByName( String name, AD4_RICHIESTE_SERVIZIORow row ) {
            Object value = null;
            if ( "DATA".equals(name) ) {
                value = row.getDATA();
            } else if ( "AUTORE".equals(name) ) {
                value = row.getAUTORE();
            } else if ( "INDIRIZZO_WEB".equals(name) ) {
                value = row.getINDIRIZZO_WEB();
            } else if ( "INDIRIZZO_NOTIFICA".equals(name) ) {
                value = row.getINDIRIZZO_NOTIFICA();
            } else if ( "NOTIFICATA".equals(name) ) {
                value = row.getNOTIFICATA();
            } else if ( "AZIENDA".equals(name) ) {
                value = row.getAZIENDA();
            } else if ( "APPROVA".equals(name) ) {
                value = row.getAPPROVA();
            } else if ( "RESPINGI".equals(name) ) {
                value = row.getRESPINGI();
            } else if ( "NOTIFICA".equals(name) ) {
                value = row.getNOTIFICA();
            } else if ( "AFCNavigator".equals(name) ) {
                value = row.getAFCNavigator();
            } else if ( "ID".equals(name) ) {
                value = row.getID();
            } else if ( "AB".equals(name) ) {
                value = row.getAB();
            } else if ( "ABILITAZIONE".equals(name) ) {
                value = row.getABILITAZIONE();
            }
            return value;
        }
//End AD4_RICHIESTE_SERVIZIO Directory: getRowFieldByName

//AD4_RICHIESTE_SERVIZIO Grid: method validate @123-104025BA
        boolean validate() {
            return true;
        }
//End AD4_RICHIESTE_SERVIZIO Grid: method validate

//AD4_RICHIESTE_SERVIZIO Grid Tail @123-FCB6E20C
    }
//End AD4_RICHIESTE_SERVIZIO Grid Tail

//AdmRichieste Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AdmRichieste Page: method validate

//AdmRichiesteAction Tail @1-FCB6E20C
}
//End AdmRichiesteAction Tail

