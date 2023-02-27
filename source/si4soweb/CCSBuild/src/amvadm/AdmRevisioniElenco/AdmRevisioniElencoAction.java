//AdmRevisioniElencoAction imports @1-87DEFEC1
package amvadm.AdmRevisioniElenco;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmRevisioniElencoAction imports

//AdmRevisioniElencoAction class @1-5B5FEC85
public class AdmRevisioniElencoAction extends Action {

//End AdmRevisioniElencoAction class

//AdmRevisioniElencoAction: method perform @1-B2043CCA
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AdmRevisioniElencoModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AdmRevisioniElencoModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AdmRevisioniElencoAction: method perform

//AdmRevisioniElencoAction: call children actions @1-B7690892
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
            ELENCO_REVISIONIClass ELENCO_REVISIONI = new ELENCO_REVISIONIClass();
            ELENCO_REVISIONI.perform(page.getGrid("ELENCO_REVISIONI"));
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
//End AdmRevisioniElencoAction: call children actions

//ELENCO_REVISIONI Grid @6-557C4B77
    final class ELENCO_REVISIONIClass {
        com.codecharge.components.Grid model;
        Event e;
//End ELENCO_REVISIONI Grid

//ELENCO_REVISIONI Grid: method perform @6-B48879D3
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
//End ELENCO_REVISIONI Grid: method perform

//ELENCO_REVISIONI Grid: method read: head @6-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End ELENCO_REVISIONI Grid: method read: head

//ELENCO_REVISIONI Grid: method read: init @6-B91F2D24
            if ( ! model.allowRead ) return true;
            ELENCO_REVISIONIDataObject ds = new ELENCO_REVISIONIDataObject(page);
            ds.setComponent( model );
//End ELENCO_REVISIONI Grid: method read: init

//ELENCO_REVISIONI Grid: set where parameters @6-D786DA30
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
//End ELENCO_REVISIONI Grid: set where parameters

//ELENCO_REVISIONI Grid: set grid properties @6-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End ELENCO_REVISIONI Grid: set grid properties

//ELENCO_REVISIONI Grid: retrieve data @6-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End ELENCO_REVISIONI Grid: retrieve data

//ELENCO_REVISIONI Grid: check errors @6-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End ELENCO_REVISIONI Grid: check errors

//ELENCO_REVISIONI Grid: method read: tail @6-F575E732
            return ( ! isErrors );
        }
//End ELENCO_REVISIONI Grid: method read: tail

//ELENCO_REVISIONI Grid: method bind @6-7B1E1E0C
        public void bind(com.codecharge.components.Component model, ELENCO_REVISIONIRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            ELENCO_REVISIONIRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("REVISIONE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("REVISIONE").clone();
                    c.setValue(row.getREVISIONE());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("CRONOLOGIA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("CRONOLOGIA").clone();
                    c.setValue(row.getCRONOLOGIA());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("STATO_DOCUMENTO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("STATO_DOCUMENTO").clone();
                    c.setValue(row.getSTATO_DOCUMENTO());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End ELENCO_REVISIONI Grid: method bind

//ELENCO_REVISIONI Directory: getRowFieldByName @6-8F863363
        public Object getRowFieldByName( String name, ELENCO_REVISIONIRow row ) {
            Object value = null;
            if ( "TITOLO".equals(name) ) {
                value = row.getTITOLO();
            } else if ( "REVISIONE".equals(name) ) {
                value = row.getREVISIONE();
            } else if ( "CRONOLOGIA".equals(name) ) {
                value = row.getCRONOLOGIA();
            } else if ( "STATO_DOCUMENTO".equals(name) ) {
                value = row.getSTATO_DOCUMENTO();
            } else if ( "AFCNavigator".equals(name) ) {
                value = row.getAFCNavigator();
            }
            return value;
        }
//End ELENCO_REVISIONI Directory: getRowFieldByName

//ELENCO_REVISIONI Grid: method validate @6-104025BA
        boolean validate() {
            return true;
        }
//End ELENCO_REVISIONI Grid: method validate

//ELENCO_REVISIONI Grid Tail @6-FCB6E20C
    }
//End ELENCO_REVISIONI Grid Tail

//AdmRevisioniElenco Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AdmRevisioniElenco Page: method validate

//AdmRevisioniElencoAction Tail @1-FCB6E20C
}
//End AdmRevisioniElencoAction Tail
