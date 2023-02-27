//AmvDocumentoInfoAction imports @1-39A70BCA
package common.AmvDocumentoInfo;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvDocumentoInfoAction imports

//AmvDocumentoInfoAction class @1-CB2A085A
public class AmvDocumentoInfoAction extends Action {

//End AmvDocumentoInfoAction class

//AmvDocumentoInfoAction: method perform @1-5878EBBC
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvDocumentoInfoModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvDocumentoInfoModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvDocumentoInfoAction: method perform

//AmvDocumentoInfoAction: call children actions @1-7746BE25
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
        if ( page.getChild( "AmvNavigatore" ).isVisible() ) {
            page.getRequest().setAttribute("AmvNavigatoreParent",page);
            common.AmvNavigatore.AmvNavigatoreAction AmvNavigatore = new common.AmvNavigatore.AmvNavigatoreAction();
            result = result != null ? result : AmvNavigatore.perform( req, resp,  context );
            page.setCookies();
        }
        if (result == null) {
            AMV_VISTA_DOCUMENTIClass AMV_VISTA_DOCUMENTI = new AMV_VISTA_DOCUMENTIClass();
            AMV_VISTA_DOCUMENTI.perform(page.getGrid("AMV_VISTA_DOCUMENTI"));
        }
        if ( page.getChild( "Right" ).isVisible() ) {
            page.getRequest().setAttribute("RightParent",page);
            common.Right.RightAction Right = new common.Right.RightAction();
            result = result != null ? result : Right.perform( req, resp,  context );
            page.setCookies();
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
//End AmvDocumentoInfoAction: call children actions

//AMV_VISTA_DOCUMENTI Grid @5-DC9A4FE9
    final class AMV_VISTA_DOCUMENTIClass {
        com.codecharge.components.Grid model;
        Event e;
//End AMV_VISTA_DOCUMENTI Grid

//AMV_VISTA_DOCUMENTI Grid: method perform @5-B48879D3
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

//AMV_VISTA_DOCUMENTI Grid: method read: head @5-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End AMV_VISTA_DOCUMENTI Grid: method read: head

//AMV_VISTA_DOCUMENTI Grid: method read: init @5-B1FFABD9
            if ( ! model.allowRead ) return true;
            AMV_VISTA_DOCUMENTIDataObject ds = new AMV_VISTA_DOCUMENTIDataObject(page);
            ds.setComponent( model );
//End AMV_VISTA_DOCUMENTI Grid: method read: init

//AMV_VISTA_DOCUMENTI Grid: set where parameters @5-CF6855D1
            try {
                ds.setUrlID( page.getHttpGetParams().getParameter("ID"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID'" );
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
//End AMV_VISTA_DOCUMENTI Grid: set where parameters

//AMV_VISTA_DOCUMENTI Grid: set grid properties @5-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End AMV_VISTA_DOCUMENTI Grid: set grid properties

//AMV_VISTA_DOCUMENTI Grid: retrieve data @5-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End AMV_VISTA_DOCUMENTI Grid: retrieve data

//AMV_VISTA_DOCUMENTI Grid: check errors @5-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End AMV_VISTA_DOCUMENTI Grid: check errors

//AMV_VISTA_DOCUMENTI Grid: method read: tail @5-F575E732
            return ( ! isErrors );
        }
//End AMV_VISTA_DOCUMENTI Grid: method read: tail

//AMV_VISTA_DOCUMENTI Grid: method bind @5-D08C9D32
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

                c = (com.codecharge.components.Control) hashRow.get("IMG_LINK");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("IMG_LINK").clone();
                    c.setValue(row.getIMG_LINK());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("STORICO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("STORICO").clone();
                    c.setValue(row.getSTORICO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("REVISIONA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("REVISIONA").clone();
                    c.setValue(row.getREVISIONA());
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

                c = (com.codecharge.components.Control) hashRow.get("INIZIO_PUBBLICAZIONE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("INIZIO_PUBBLICAZIONE").clone();
                    c.setValue(row.getINIZIO_PUBBLICAZIONE());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("DSP_FINE_PUBBLICAZIONE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("DSP_FINE_PUBBLICAZIONE").clone();
                    c.setValue(row.getDSP_FINE_PUBBLICAZIONE());
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

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End AMV_VISTA_DOCUMENTI Grid: method bind

//AMV_VISTA_DOCUMENTI Directory: getRowFieldByName @5-87EEAE96
        public Object getRowFieldByName( String name, AMV_VISTA_DOCUMENTIRow row ) {
            Object value = null;
            if ( "TITOLO".equals(name) ) {
                value = row.getTITOLO();
            } else if ( "IMG_LINK".equals(name) ) {
                value = row.getIMG_LINK();
            } else if ( "STORICO".equals(name) ) {
                value = row.getSTORICO();
            } else if ( "REVISIONA".equals(name) ) {
                value = row.getREVISIONA();
            } else if ( "MODIFICA".equals(name) ) {
                value = row.getMODIFICA();
            } else if ( "STATO".equals(name) ) {
                value = row.getSTATO();
            } else if ( "INIZIO_PUBBLICAZIONE".equals(name) ) {
                value = row.getINIZIO_PUBBLICAZIONE();
            } else if ( "DSP_FINE_PUBBLICAZIONE".equals(name) ) {
                value = row.getDSP_FINE_PUBBLICAZIONE();
            } else if ( "DATA_ULTIMA_MODIFICA".equals(name) ) {
                value = row.getDATA_ULTIMA_MODIFICA();
            } else if ( "TESTO".equals(name) ) {
                value = row.getTESTO();
            } else if ( "ID".equals(name) ) {
                value = row.getID();
            } else if ( "ID_DOCUMENTO".equals(name) ) {
                value = row.getID_DOCUMENTO();
            } else if ( "REV".equals(name) ) {
                value = row.getREV();
            } else if ( "REVISIONE".equals(name) ) {
                value = row.getREVISIONE();
            } else if ( "REV_HREF".equals(name) ) {
                value = row.getREV_HREF();
            } else if ( "MOD_HREF".equals(name) ) {
                value = row.getMOD_HREF();
            }
            return value;
        }
//End AMV_VISTA_DOCUMENTI Directory: getRowFieldByName

//AMV_VISTA_DOCUMENTI Grid: method validate @5-104025BA
        boolean validate() {
            return true;
        }
//End AMV_VISTA_DOCUMENTI Grid: method validate

//AMV_VISTA_DOCUMENTI Grid Tail @5-FCB6E20C
    }
//End AMV_VISTA_DOCUMENTI Grid Tail

//AmvDocumentoInfo Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvDocumentoInfo Page: method validate

//AmvDocumentoInfoAction Tail @1-FCB6E20C
}
//End AmvDocumentoInfoAction Tail

