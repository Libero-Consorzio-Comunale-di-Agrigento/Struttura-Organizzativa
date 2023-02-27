//ServletModulisticaAction imports @1-5350FCDC
package restrict.ServletModulistica;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End ServletModulisticaAction imports

//ServletModulisticaAction class @1-6396355C
public class ServletModulisticaAction extends Action {

//End ServletModulisticaAction class

//ServletModulisticaAction: method perform @1-7C2F9277
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new ServletModulisticaModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "ServletModulisticaModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End ServletModulisticaAction: method perform

//ServletModulisticaAction: call children actions @1-B2A4C860
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
        if (result == null) {
            AMV_VISTA_DOCUMENTIClass AMV_VISTA_DOCUMENTI = new AMV_VISTA_DOCUMENTIClass();
            AMV_VISTA_DOCUMENTI.perform(page.getGrid("AMV_VISTA_DOCUMENTI"));
        }
        if (result == null) {
            INSERISCI_RICHIESTAClass INSERISCI_RICHIESTA = new INSERISCI_RICHIESTAClass();
            INSERISCI_RICHIESTA.perform(page.getGrid("INSERISCI_RICHIESTA"));
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
//End ServletModulisticaAction: call children actions

//AMV_VISTA_DOCUMENTI Grid @9-DC9A4FE9
    final class AMV_VISTA_DOCUMENTIClass {
        com.codecharge.components.Grid model;
        Event e;
//End AMV_VISTA_DOCUMENTI Grid

//AMV_VISTA_DOCUMENTI Grid: method perform @9-B48879D3
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
//End AMV_VISTA_DOCUMENTI Grid: method perform

//AMV_VISTA_DOCUMENTI Grid: method read: head @9-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End AMV_VISTA_DOCUMENTI Grid: method read: head

//AMV_VISTA_DOCUMENTI Grid: method read: init @9-B1FFABD9
            if ( ! model.allowRead ) return true;
            AMV_VISTA_DOCUMENTIDataObject ds = new AMV_VISTA_DOCUMENTIDataObject(page);
            ds.setComponent( model );
//End AMV_VISTA_DOCUMENTI Grid: method read: init

//AMV_VISTA_DOCUMENTI Grid: set where parameters @9-38693162
            try {
                ds.setUrlIDPD( page.getHttpGetParams().getParameter("IDPD"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'IDPD'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'IDPD'" );
                return false;
            }
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            try {
                ds.setUrlREV( page.getHttpGetParams().getParameter("REV"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'REV'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'REV'" );
                return false;
            }
            try {
                ds.setSesMVIDPDRIC( SessionStorage.getInstance(req).getAttribute("MVIDPDRIC"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVIDPDRIC'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVIDPDRIC'" );
                return false;
            }
            try {
                ds.setUrlID( page.getHttpGetParams().getParameter("ID"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID'" );
                return false;
            }
            try {
                ds.setSesMVIDRIC( SessionStorage.getInstance(req).getAttribute("MVIDRIC"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVIDRIC'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVIDRIC'" );
                return false;
            }
            try {
                ds.setSesMVREVRIC( SessionStorage.getInstance(req).getAttribute("MVREVRIC"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVREVRIC'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVREVRIC'" );
                return false;
            }
            ds.setUrlCr( page.getHttpGetParams().getParameter("cr") );
            ds.setPostCr( page.getHttpPostParams().getParameter("cr") );
//End AMV_VISTA_DOCUMENTI Grid: set where parameters

//AMV_VISTA_DOCUMENTI Grid: set grid properties @9-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End AMV_VISTA_DOCUMENTI Grid: set grid properties

//AMV_VISTA_DOCUMENTI Grid: retrieve data @9-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End AMV_VISTA_DOCUMENTI Grid: retrieve data

//AMV_VISTA_DOCUMENTI Grid: check errors @9-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End AMV_VISTA_DOCUMENTI Grid: check errors

//AMV_VISTA_DOCUMENTI Grid: method read: tail @9-F575E732
            return ( ! isErrors );
        }
//End AMV_VISTA_DOCUMENTI Grid: method read: tail

//AMV_VISTA_DOCUMENTI Grid: method bind @9-68EC04AB
        public void bind(com.codecharge.components.Component model, AMV_VISTA_DOCUMENTIRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            AMV_VISTA_DOCUMENTIRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("TITOLO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("TITOLO").clone();
                    c.setValue(row.getTITOLO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("MODIFICA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("MODIFICA").clone();
                    c.setValue(row.getMODIFICA());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("STATO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("STATO").clone();
                    c.setValue(row.getSTATO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("COD_STATO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("COD_STATO").clone();
                    c.setValue(row.getCOD_STATO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("DATA_ULTIMA_MODIFICA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("DATA_ULTIMA_MODIFICA").clone();
                    c.setValue(row.getDATA_ULTIMA_MODIFICA());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("TESTO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("TESTO").clone();
                    c.setValue(row.getTESTO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("ALLEGATI");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("ALLEGATI").clone();
                    c.setValue(row.getALLEGATI());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End AMV_VISTA_DOCUMENTI Grid: method bind

//AMV_VISTA_DOCUMENTI Directory: getRowFieldByName @9-08E3ED80
        public Object getRowFieldByName( String name, AMV_VISTA_DOCUMENTIRow row ) {
            Object value = null;
            if ( "TITOLO".equals(name) ) {
                value = row.getTITOLO();
            } else if ( "MODIFICA".equals(name) ) {
                value = row.getMODIFICA();
            } else if ( "STATO".equals(name) ) {
                value = row.getSTATO();
            } else if ( "COD_STATO".equals(name) ) {
                value = row.getCOD_STATO();
            } else if ( "DATA_ULTIMA_MODIFICA".equals(name) ) {
                value = row.getDATA_ULTIMA_MODIFICA();
            } else if ( "TESTO".equals(name) ) {
                value = row.getTESTO();
            } else if ( "ALLEGATI".equals(name) ) {
                value = row.getALLEGATI();
            } else if ( "ID".equals(name) ) {
                value = row.getID();
            } else if ( "ID_DOCUMENTO".equals(name) ) {
                value = row.getID_DOCUMENTO();
            } else if ( "REV".equals(name) ) {
                value = row.getREV();
            } else if ( "REVISIONE".equals(name) ) {
                value = row.getREVISIONE();
            } else if ( "MOD_HREF".equals(name) ) {
                value = row.getMOD_HREF();
            }
            return value;
        }
//End AMV_VISTA_DOCUMENTI Directory: getRowFieldByName

//AMV_VISTA_DOCUMENTI Grid: method validate @9-104025BA
        boolean validate() {
            return true;
        }
//End AMV_VISTA_DOCUMENTI Grid: method validate

//AMV_VISTA_DOCUMENTI Grid Tail @9-FCB6E20C
    }
//End AMV_VISTA_DOCUMENTI Grid Tail

//INSERISCI_RICHIESTA Grid @29-23F6D402
    final class INSERISCI_RICHIESTAClass {
        com.codecharge.components.Grid model;
        Event e;
//End INSERISCI_RICHIESTA Grid

//INSERISCI_RICHIESTA Grid: method perform @29-B48879D3
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
//End INSERISCI_RICHIESTA Grid: method perform

//INSERISCI_RICHIESTA Grid: method read: head @29-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End INSERISCI_RICHIESTA Grid: method read: head

//INSERISCI_RICHIESTA Grid: method read: init @29-47DED37C
            if ( ! model.allowRead ) return true;
            INSERISCI_RICHIESTADataObject ds = new INSERISCI_RICHIESTADataObject(page);
            ds.setComponent( model );
//End INSERISCI_RICHIESTA Grid: method read: init

//INSERISCI_RICHIESTA Grid: set where parameters @29-EF1090B5
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            try {
                ds.setSesMVIDRIC( SessionStorage.getInstance(req).getAttribute("MVIDRIC"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVIDRIC'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVIDRIC'" );
                return false;
            }
            ds.setPostCr( page.getHttpPostParams().getParameter("cr") );
            ds.setSesMVEXE( SessionStorage.getInstance(req).getAttribute("MVEXE") );
            try {
                ds.setSesMVIDPDRIC( SessionStorage.getInstance(req).getAttribute("MVIDPDRIC"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVIDPDRIC'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVIDPDRIC'" );
                return false;
            }
//End INSERISCI_RICHIESTA Grid: set where parameters

//INSERISCI_RICHIESTA Grid: set grid properties @29-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End INSERISCI_RICHIESTA Grid: set grid properties

//INSERISCI_RICHIESTA Grid: retrieve data @29-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End INSERISCI_RICHIESTA Grid: retrieve data

//INSERISCI_RICHIESTA Grid: check errors @29-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End INSERISCI_RICHIESTA Grid: check errors

//INSERISCI_RICHIESTA Grid: method read: tail @29-F575E732
            return ( ! isErrors );
        }
//End INSERISCI_RICHIESTA Grid: method read: tail

//INSERISCI_RICHIESTA Grid: method bind @29-032CACCB
        public void bind(com.codecharge.components.Component model, INSERISCI_RICHIESTARow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            INSERISCI_RICHIESTARow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("MESSAGGIO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("MESSAGGIO").clone();
                    c.setValue(row.getMESSAGGIO());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End INSERISCI_RICHIESTA Grid: method bind

//INSERISCI_RICHIESTA Directory: getRowFieldByName @29-B4E1B555
        public Object getRowFieldByName( String name, INSERISCI_RICHIESTARow row ) {
            Object value = null;
            if ( "MESSAGGIO".equals(name) ) {
                value = row.getMESSAGGIO();
            }
            return value;
        }
//End INSERISCI_RICHIESTA Directory: getRowFieldByName

//INSERISCI_RICHIESTA Grid: method validate @29-104025BA
        boolean validate() {
            return true;
        }
//End INSERISCI_RICHIESTA Grid: method validate

//INSERISCI_RICHIESTA Grid Tail @29-FCB6E20C
    }
//End INSERISCI_RICHIESTA Grid Tail

//ServletModulistica Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End ServletModulistica Page: method validate

//ServletModulisticaAction Tail @1-FCB6E20C
}
//End ServletModulisticaAction Tail
