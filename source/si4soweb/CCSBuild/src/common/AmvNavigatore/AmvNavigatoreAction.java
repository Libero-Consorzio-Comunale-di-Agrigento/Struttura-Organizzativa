//AmvNavigatoreAction imports @1-043E9F9C
package common.AmvNavigatore;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvNavigatoreAction imports

//AmvNavigatoreAction class @1-145C4AE4
public class AmvNavigatoreAction extends Action {

//End AmvNavigatoreAction class

//AmvNavigatoreAction: method perform @1-CC945452
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvNavigatoreModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvNavigatoreModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvNavigatoreAction: method perform

//AmvNavigatoreAction: call children actions @1-467C0910
        if (result == null) {
            NAVIGATOREClass NAVIGATORE = new NAVIGATOREClass();
            NAVIGATORE.perform(page.getGrid("NAVIGATORE"));
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvNavigatoreAction: call children actions

//NAVIGATORE Grid @2-1722F5BA
    final class NAVIGATOREClass {
        com.codecharge.components.Grid model;
        Event e;
//End NAVIGATORE Grid

//NAVIGATORE Grid: method perform @2-B48879D3
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
//End NAVIGATORE Grid: method perform

//NAVIGATORE Grid: method read: head @2-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End NAVIGATORE Grid: method read: head

//NAVIGATORE Grid: method read: init @2-4ABDC7A4
            if ( ! model.allowRead ) return true;
            NAVIGATOREDataObject ds = new NAVIGATOREDataObject(page);
            ds.setComponent( model );
//End NAVIGATORE Grid: method read: init

//NAVIGATORE Grid: set where parameters @2-0954FD5B
            try {
                ds.setUrlMVSZ( page.getHttpGetParams().getParameter("MVSZ"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVSZ'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVSZ'" );
                return false;
            }
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setSesModulo( SessionStorage.getInstance(req).getAttribute("Modulo") );
            ds.setSesMVVC( SessionStorage.getInstance(req).getAttribute("MVVC") );
            ds.setSesMVL1( SessionStorage.getInstance(req).getAttribute("MVL1") );
            ds.setSesMVL2( SessionStorage.getInstance(req).getAttribute("MVL2") );
            ds.setSesMVL3( SessionStorage.getInstance(req).getAttribute("MVL3") );
            ds.setUrlMVTD( page.getHttpGetParams().getParameter("MVTD") );
            ds.setSesMVCONTEXT( SessionStorage.getInstance(req).getAttribute("MVCONTEXT") );
//End NAVIGATORE Grid: set where parameters

//NAVIGATORE Grid: set grid properties @2-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End NAVIGATORE Grid: set grid properties

//NAVIGATORE Grid: retrieve data @2-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End NAVIGATORE Grid: retrieve data

//NAVIGATORE Grid: check errors @2-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End NAVIGATORE Grid: check errors

//NAVIGATORE Grid: method read: tail @2-F575E732
            return ( ! isErrors );
        }
//End NAVIGATORE Grid: method read: tail

//NAVIGATORE Grid: method bind @2-DAF11CC8
        public void bind(com.codecharge.components.Component model, NAVIGATORERow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            NAVIGATORERow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("NAVIGATORE_SEZIONI");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("NAVIGATORE_SEZIONI").clone();
                    c.setValue(row.getNAVIGATORE_SEZIONI());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End NAVIGATORE Grid: method bind

//NAVIGATORE Directory: getRowFieldByName @2-2F81DDB3
        public Object getRowFieldByName( String name, NAVIGATORERow row ) {
            Object value = null;
            if ( "NAVIGATORE_SEZIONI".equals(name) ) {
                value = row.getNAVIGATORE_SEZIONI();
            } else if ( "ID_ARTICOLO".equals(name) ) {
                value = row.getID_ARTICOLO();
            } else if ( "VIS_LINK".equals(name) ) {
                value = row.getVIS_LINK();
            }
            return value;
        }
//End NAVIGATORE Directory: getRowFieldByName

//NAVIGATORE Grid: method validate @2-104025BA
        boolean validate() {
            return true;
        }
//End NAVIGATORE Grid: method validate

//NAVIGATORE Grid Tail @2-FCB6E20C
    }
//End NAVIGATORE Grid Tail

//AmvNavigatore Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvNavigatore Page: method validate

//AmvNavigatoreAction Tail @1-FCB6E20C
}
//End AmvNavigatoreAction Tail

