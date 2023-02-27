//AmvRedirectAction imports @1-B6B5DF27
package common.AmvRedirect;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvRedirectAction imports

//AmvRedirectAction class @1-F81AE351
public class AmvRedirectAction extends Action {

//End AmvRedirectAction class

//AmvRedirectAction: method perform @1-FFF522CE
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvRedirectModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvRedirectModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvRedirectAction: method perform

//AmvRedirectAction: call children actions @1-0C463DA0
        if (result == null) {
            REDIRECT_TAGClass REDIRECT_TAG = new REDIRECT_TAGClass();
            REDIRECT_TAG.perform(page.getGrid("REDIRECT_TAG"));
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvRedirectAction: call children actions

//REDIRECT_TAG Grid @2-DDF81ADD
    final class REDIRECT_TAGClass {
        com.codecharge.components.Grid model;
        Event e;
//End REDIRECT_TAG Grid

//REDIRECT_TAG Grid: method perform @2-B48879D3
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
//End REDIRECT_TAG Grid: method perform

//REDIRECT_TAG Grid: method read: head @2-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End REDIRECT_TAG Grid: method read: head

//REDIRECT_TAG Grid: method read: init @2-7CBA3235
            if ( ! model.allowRead ) return true;
            REDIRECT_TAGDataObject ds = new REDIRECT_TAGDataObject(page);
            ds.setComponent( model );
//End REDIRECT_TAG Grid: method read: init

//REDIRECT_TAG Grid: set where parameters @2-E5587D52
            ds.setPostMVPAGETYPE( page.getHttpPostParams().getParameter("MVPAGETYPE") );
            ds.setPostMVPAGES( page.getHttpPostParams().getParameter("MVPAGES") );
            try {
                ds.setPostMVPAGEINDEX( page.getHttpPostParams().getParameter("MVPAGEINDEX"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVPAGEINDEX'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVPAGEINDEX'" );
                return false;
            }
            ds.setUrlMVPAGETYPE( page.getHttpGetParams().getParameter("MVPAGETYPE") );
            ds.setUrlMVPAGES( page.getHttpGetParams().getParameter("MVPAGES") );
            try {
                ds.setUrlMVPAGEINDEXURL( page.getHttpGetParams().getParameter("MVPAGEINDEXURL"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVPAGEINDEXURL'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVPAGEINDEXURL'" );
                return false;
            }
            ds.setSesMVPP( SessionStorage.getInstance(req).getAttribute("MVPP") );
//End REDIRECT_TAG Grid: set where parameters

//REDIRECT_TAG Grid: set grid properties @2-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End REDIRECT_TAG Grid: set grid properties

//REDIRECT_TAG Grid: retrieve data @2-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End REDIRECT_TAG Grid: retrieve data

//REDIRECT_TAG Grid: check errors @2-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End REDIRECT_TAG Grid: check errors

//REDIRECT_TAG Grid: method read: tail @2-F575E732
            return ( ! isErrors );
        }
//End REDIRECT_TAG Grid: method read: tail

//REDIRECT_TAG Grid: method bind @2-151C04B1
        public void bind(com.codecharge.components.Component model, REDIRECT_TAGRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            REDIRECT_TAGRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("Redirection");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("Redirection").clone();
                    c.setValue(row.getRedirection());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End REDIRECT_TAG Grid: method bind

//REDIRECT_TAG Directory: getRowFieldByName @2-A95D9E88
        public Object getRowFieldByName( String name, REDIRECT_TAGRow row ) {
            Object value = null;
            if ( "Redirection".equals(name) ) {
                value = row.getRedirection();
            }
            return value;
        }
//End REDIRECT_TAG Directory: getRowFieldByName

//REDIRECT_TAG Grid: method validate @2-104025BA
        boolean validate() {
            return true;
        }
//End REDIRECT_TAG Grid: method validate

//REDIRECT_TAG Grid Tail @2-FCB6E20C
    }
//End REDIRECT_TAG Grid Tail

//AmvRedirect Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvRedirect Page: method validate

//AmvRedirectAction Tail @1-FCB6E20C
}
//End AmvRedirectAction Tail

