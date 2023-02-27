//AmvFooterAction imports @1-E7619D06
package common.AmvFooter;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvFooterAction imports

//AmvFooterAction class @1-CF675420
public class AmvFooterAction extends Action {

//End AmvFooterAction class

//AmvFooterAction: method perform @1-89EF9FBA
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvFooterModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvFooterModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvFooterAction: method perform

//AmvFooterAction: call children actions @1-29B84F29
        if (result == null) {
            copyrightClass copyright = new copyrightClass();
            copyright.perform(page.getGrid("copyright"));
        }
        if ( page.getChild( "AmvStyle" ).isVisible() ) {
            page.getRequest().setAttribute("AmvStyleParent",page);
            common.AmvStyle.AmvStyleAction AmvStyle = new common.AmvStyle.AmvStyleAction();
            result = result != null ? result : AmvStyle.perform( req, resp,  context );
            page.setCookies();
        }
        if ( page.getChild( "Versione" ).isVisible() ) {
            page.getRequest().setAttribute("VersioneParent",page);
            common.Versione.VersioneAction Versione = new common.Versione.VersioneAction();
            result = result != null ? result : Versione.perform( req, resp,  context );
            page.setCookies();
        }
        if ( page.getChild( "AmvVersione" ).isVisible() ) {
            page.getRequest().setAttribute("AmvVersioneParent",page);
            common.AmvVersione.AmvVersioneAction AmvVersione = new common.AmvVersione.AmvVersioneAction();
            result = result != null ? result : AmvVersione.perform( req, resp,  context );
            page.setCookies();
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvFooterAction: call children actions

//copyright Grid @2-A7DD67FE
    final class copyrightClass {
        com.codecharge.components.Grid model;
        Event e;
//End copyright Grid

//copyright Grid: method perform @2-B48879D3
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
//End copyright Grid: method perform

//copyright Grid: method read: head @2-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End copyright Grid: method read: head

//copyright Grid: method read: init @2-03D75372
            if ( ! model.allowRead ) return true;
            copyrightDataObject ds = new copyrightDataObject(page);
            ds.setComponent( model );
//End copyright Grid: method read: init

//copyright Grid: set where parameters @2-EF60F66C
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setSesModulo( SessionStorage.getInstance(req).getAttribute("Modulo") );
            try {
                ds.setUrlMVSZ( page.getHttpGetParams().getParameter("MVSZ"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVSZ'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVSZ'" );
                return false;
            }
//End copyright Grid: set where parameters

//copyright Grid: set grid properties @2-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End copyright Grid: set grid properties

//copyright Grid: retrieve data @2-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End copyright Grid: retrieve data

//copyright Grid: check errors @2-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End copyright Grid: check errors

//copyright Grid: method read: tail @2-F575E732
            return ( ! isErrors );
        }
//End copyright Grid: method read: tail

//copyright Grid: method bind @2-03A678AE
        public void bind(com.codecharge.components.Component model, copyrightRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            copyrightRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("MVDIRUPLOAD");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("MVDIRUPLOAD").clone();
                    c.setValue(row.getMVDIRUPLOAD());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End copyright Grid: method bind

//copyright Directory: getRowFieldByName @2-F4FE9ACE
        public Object getRowFieldByName( String name, copyrightRow row ) {
            Object value = null;
            if ( "MESSAGGIO".equals(name) ) {
                value = row.getMESSAGGIO();
            } else if ( "MVDIRUPLOAD".equals(name) ) {
                value = row.getMVDIRUPLOAD();
            }
            return value;
        }
//End copyright Directory: getRowFieldByName

//copyright Grid: method validate @2-104025BA
        boolean validate() {
            return true;
        }
//End copyright Grid: method validate

//copyright Grid Tail @2-FCB6E20C
    }
//End copyright Grid Tail

//AmvFooter Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvFooter Page: method validate

//AmvFooterAction Tail @1-FCB6E20C
}
//End AmvFooterAction Tail

