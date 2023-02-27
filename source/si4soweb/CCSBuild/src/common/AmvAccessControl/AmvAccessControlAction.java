//AmvAccessControlAction imports @1-E93AF723
package common.AmvAccessControl;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvAccessControlAction imports

//AmvAccessControlAction class @1-D58697F4
public class AmvAccessControlAction extends Action {

//End AmvAccessControlAction class

//AmvAccessControlAction: method perform @1-48638A87
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvAccessControlModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvAccessControlModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvAccessControlAction: method perform

//AmvAccessControlAction: call children actions @1-2982FB8B
        if (result == null) {
            ACCESSOClass ACCESSO = new ACCESSOClass();
            ACCESSO.perform(page.getGrid("ACCESSO"));
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvAccessControlAction: call children actions

//ACCESSO Grid @3-A5EA78A9
    final class ACCESSOClass {
        com.codecharge.components.Grid model;
        Event e;
//End ACCESSO Grid

//ACCESSO Grid: method perform @3-B48879D3
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
//End ACCESSO Grid: method perform

//ACCESSO Grid: method read: head @3-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End ACCESSO Grid: method read: head

//ACCESSO Grid: method read: init @3-9763C6BA
            if ( ! model.allowRead ) return true;
            ACCESSODataObject ds = new ACCESSODataObject(page);
            ds.setComponent( model );
//End ACCESSO Grid: method read: init

//ACCESSO Grid: set where parameters @3-886864C0
            ds.setSesModulo( SessionStorage.getInstance(req).getAttribute("Modulo") );
            ds.setSesRuolo( SessionStorage.getInstance(req).getAttribute("Ruolo") );
            ds.setSesMVURL( SessionStorage.getInstance(req).getAttribute("MVURL") );
            ds.setSesMVCONTEXT( SessionStorage.getInstance(req).getAttribute("MVCONTEXT") );
            ds.setSesMVPATH( SessionStorage.getInstance(req).getAttribute("MVPATH") );
//End ACCESSO Grid: set where parameters

//ACCESSO Grid: set grid properties @3-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End ACCESSO Grid: set grid properties

//ACCESSO Grid: retrieve data @3-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End ACCESSO Grid: retrieve data

//ACCESSO Grid: check errors @3-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End ACCESSO Grid: check errors

//ACCESSO Grid: method read: tail @3-F575E732
            return ( ! isErrors );
        }
//End ACCESSO Grid: method read: tail

//ACCESSO Grid: method bind @3-9FA82970
        public void bind(com.codecharge.components.Component model, ACCESSORow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            ACCESSORow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("VOCE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("VOCE").clone();
                    c.setValue(row.getVOCE());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End ACCESSO Grid: method bind

//ACCESSO Directory: getRowFieldByName @3-E23912B7
        public Object getRowFieldByName( String name, ACCESSORow row ) {
            Object value = null;
            if ( "VOCE".equals(name) ) {
                value = row.getVOCE();
            }
            return value;
        }
//End ACCESSO Directory: getRowFieldByName

//ACCESSO Grid: method validate @3-104025BA
        boolean validate() {
            return true;
        }
//End ACCESSO Grid: method validate

//ACCESSO Grid Tail @3-FCB6E20C
    }
//End ACCESSO Grid Tail

//AmvAccessControl Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvAccessControl Page: method validate

//AmvAccessControlAction Tail @1-FCB6E20C
}
//End AmvAccessControlAction Tail

