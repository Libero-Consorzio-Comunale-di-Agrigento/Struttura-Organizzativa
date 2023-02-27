//AdmContenutiAction imports @1-C1875DEB
package amvadm.AdmContenuti;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmContenutiAction imports

//AdmContenutiAction class @1-5161C426
public class AdmContenutiAction extends Action {

//End AdmContenutiAction class

//AdmContenutiAction: method perform @1-99F18BFA
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AdmContenutiModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AdmContenutiModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AdmContenutiAction: method perform

//AdmContenutiAction: call children actions @1-D59ABEAA
        if ( page.getChild( "Header" ).isVisible() ) {
            page.getRequest().setAttribute("HeaderParent",page);
            common.Header.HeaderAction Header = new common.Header.HeaderAction();
            result = result != null ? result : Header.perform( req, resp,  context );
            page.setCookies();
        }
        if ( page.getChild( "Guida" ).isVisible() ) {
            page.getRequest().setAttribute("GuidaParent",page);
            common.Guida.GuidaAction Guida = new common.Guida.GuidaAction();
            result = result != null ? result : Guida.perform( req, resp,  context );
            page.setCookies();
        }
        if (result == null) {
            AlberoClass Albero = new AlberoClass();
            Albero.perform(page.getGrid("Albero"));
        }
        if ( page.getChild( "AdmContenutiElenco" ).isVisible() ) {
            page.getRequest().setAttribute("AdmContenutiElencoParent",page);
            amvadm.AdmContenutiElenco.AdmContenutiElencoAction AdmContenutiElenco = new amvadm.AdmContenutiElenco.AdmContenutiElencoAction();
            result = result != null ? result : AdmContenutiElenco.perform( req, resp,  context );
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
//End AdmContenutiAction: call children actions

//Albero Grid @6-1F6F8394
    final class AlberoClass {
        com.codecharge.components.Grid model;
        Event e;
//End Albero Grid

//Albero Grid: method perform @6-B48879D3
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
//End Albero Grid: method perform

//Albero Grid: method read: head @6-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End Albero Grid: method read: head

//Albero Grid: method read: init @6-F63E90EB
            if ( ! model.allowRead ) return true;
            AlberoDataObject ds = new AlberoDataObject(page);
            ds.setComponent( model );
//End Albero Grid: method read: init

//Albero Grid: set where parameters @6-10753791
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            try {
                ds.setUrlSZ( page.getHttpGetParams().getParameter("SZ"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'SZ'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'SZ'" );
                return false;
            }
            ds.setSesMVPC( SessionStorage.getInstance(req).getAttribute("MVPC") );
//End Albero Grid: set where parameters

//Albero Grid: set grid properties @6-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End Albero Grid: set grid properties

//Albero Grid: retrieve data @6-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End Albero Grid: retrieve data

//Albero Grid: check errors @6-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End Albero Grid: check errors

//Albero Grid: method read: tail @6-F575E732
            return ( ! isErrors );
        }
//End Albero Grid: method read: tail

//Albero Grid: method bind @6-D9B8711B
        public void bind(com.codecharge.components.Component model, AlberoRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            AlberoRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("MENU");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("MENU").clone();
                    c.setValue(row.getMENU());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End Albero Grid: method bind

//Albero Directory: getRowFieldByName @6-70F5DF3D
        public Object getRowFieldByName( String name, AlberoRow row ) {
            Object value = null;
            if ( "MENU".equals(name) ) {
                value = row.getMENU();
            }
            return value;
        }
//End Albero Directory: getRowFieldByName

//Albero Grid: method validate @6-104025BA
        boolean validate() {
            return true;
        }
//End Albero Grid: method validate

//Albero Grid Tail @6-FCB6E20C
    }
//End Albero Grid Tail

//AdmContenuti Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AdmContenuti Page: method validate

//AdmContenutiAction Tail @1-FCB6E20C
}
//End AdmContenutiAction Tail
