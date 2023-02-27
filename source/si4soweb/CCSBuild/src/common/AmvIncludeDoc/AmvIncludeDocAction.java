//AmvIncludeDocAction imports @1-D5498CC9
package common.AmvIncludeDoc;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvIncludeDocAction imports

//AmvIncludeDocAction class @1-28EDBF42
public class AmvIncludeDocAction extends Action {

//End AmvIncludeDocAction class

//AmvIncludeDocAction: method perform @1-27D840DE
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvIncludeDocModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvIncludeDocModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvIncludeDocAction: method perform

//AmvIncludeDocAction: call children actions @1-381D290A
        if (result == null) {
            DocClass Doc = new DocClass();
            Doc.perform(page.getGrid("Doc"));
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvIncludeDocAction: call children actions

//Doc Grid @3-B101632A
    final class DocClass {
        com.codecharge.components.Grid model;
        Event e;
//End Doc Grid

//Doc Grid: method perform @3-B48879D3
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
//End Doc Grid: method perform

//Doc Grid: method read: head @3-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End Doc Grid: method read: head

//Doc Grid: method read: init @3-F0F15D86
            if ( ! model.allowRead ) return true;
            DocDataObject ds = new DocDataObject(page);
            ds.setComponent( model );
//End Doc Grid: method read: init

//Doc Grid: set where parameters @3-CF6855D1
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
//End Doc Grid: set where parameters

//Doc Grid: set grid properties @3-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End Doc Grid: set grid properties

//Doc Grid: retrieve data @3-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End Doc Grid: retrieve data

//Doc Grid: check errors @3-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End Doc Grid: check errors

//Doc Grid: method read: tail @3-F575E732
            return ( ! isErrors );
        }
//End Doc Grid: method read: tail

//Doc Grid: method bind @3-DFBFF7F8
        public void bind(com.codecharge.components.Component model, DocRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            DocRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("LINK");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("LINK").clone();
                    c.setValue(row.getLINK());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End Doc Grid: method bind

//Doc Directory: getRowFieldByName @3-3405FADD
        public Object getRowFieldByName( String name, DocRow row ) {
            Object value = null;
            if ( "LINK".equals(name) ) {
                value = row.getLINK();
            } else if ( "DOC_LINK".equals(name) ) {
                value = row.getDOC_LINK();
            }
            return value;
        }
//End Doc Directory: getRowFieldByName

//Doc Grid: method validate @3-104025BA
        boolean validate() {
            return true;
        }
//End Doc Grid: method validate

//Doc Grid Tail @3-FCB6E20C
    }
//End Doc Grid Tail

//AmvIncludeDoc Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvIncludeDoc Page: method validate

//AmvIncludeDocAction Tail @1-FCB6E20C
}
//End AmvIncludeDocAction Tail



