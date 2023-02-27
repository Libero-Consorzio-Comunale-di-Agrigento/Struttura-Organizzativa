//AmvHomeAction imports @1-FA9B4268
package common.AmvHome;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvHomeAction imports

//AmvHomeAction class @1-0A83F79F
public class AmvHomeAction extends Action {

//End AmvHomeAction class

//AmvHomeAction: method perform @1-85F0535B
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvHomeModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvHomeModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvHomeAction: method perform

//AmvHomeAction: call children actions @1-29A6DDCC
        if (result == null) {
            HOME_GRIDClass HOME_GRID = new HOME_GRIDClass();
            HOME_GRID.perform(page.getGrid("HOME_GRID"));
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvHomeAction: call children actions

//HOME_GRID Grid @2-9ADA24A5
    final class HOME_GRIDClass {
        com.codecharge.components.Grid model;
        Event e;
//End HOME_GRID Grid

//HOME_GRID Grid: method perform @2-B48879D3
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
//End HOME_GRID Grid: method perform

//HOME_GRID Grid: method read: head @2-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End HOME_GRID Grid: method read: head

//HOME_GRID Grid: method read: init @2-E987100D
            if ( ! model.allowRead ) return true;
            HOME_GRIDDataObject ds = new HOME_GRIDDataObject(page);
            ds.setComponent( model );
//End HOME_GRID Grid: method read: init

//HOME_GRID Grid: set where parameters @2-F17FFF38
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setSesModulo( SessionStorage.getInstance(req).getAttribute("Modulo") );
//End HOME_GRID Grid: set where parameters

//HOME_GRID Grid: set grid properties @2-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End HOME_GRID Grid: set grid properties

//HOME_GRID Grid: retrieve data @2-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End HOME_GRID Grid: retrieve data

//HOME_GRID Grid: check errors @2-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End HOME_GRID Grid: check errors

//HOME_GRID Grid: method read: tail @2-F575E732
            return ( ! isErrors );
        }
//End HOME_GRID Grid: method read: tail

//HOME_GRID Grid: method bind @2-2CBF3BD2
        public void bind(com.codecharge.components.Component model, HOME_GRIDRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            HOME_GRIDRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("HOME");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("HOME").clone();
                    c.setValue(row.getHOME());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End HOME_GRID Grid: method bind

//HOME_GRID Directory: getRowFieldByName @2-BB471AF9
        public Object getRowFieldByName( String name, HOME_GRIDRow row ) {
            Object value = null;
            if ( "HOME".equals(name) ) {
                value = row.getHOME();
            }
            return value;
        }
//End HOME_GRID Directory: getRowFieldByName

//HOME_GRID Grid: method validate @2-104025BA
        boolean validate() {
            return true;
        }
//End HOME_GRID Grid: method validate

//HOME_GRID Grid Tail @2-FCB6E20C
    }
//End HOME_GRID Grid Tail

//AmvHome Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvHome Page: method validate

//AmvHomeAction Tail @1-FCB6E20C
}
//End AmvHomeAction Tail

