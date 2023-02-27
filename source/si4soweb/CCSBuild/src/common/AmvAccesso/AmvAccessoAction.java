//AmvAccessoAction imports @1-6A3E6EBB
package common.AmvAccesso;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvAccessoAction imports

//AmvAccessoAction class @1-BC05A0EB
public class AmvAccessoAction extends Action {

//End AmvAccessoAction class

//AmvAccessoAction: method perform @1-6F5ED72C
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvAccessoModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvAccessoModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvAccessoAction: method perform

//AmvAccessoAction: call children actions @1-5CA9256F
        if (result == null) {
            CONTROLLO_PASSWORDClass CONTROLLO_PASSWORD = new CONTROLLO_PASSWORDClass();
            CONTROLLO_PASSWORD.perform(page.getGrid("CONTROLLO_PASSWORD"));
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvAccessoAction: call children actions

//CONTROLLO_PASSWORD Grid @9-06887C75
    final class CONTROLLO_PASSWORDClass {
        com.codecharge.components.Grid model;
        Event e;
//End CONTROLLO_PASSWORD Grid

//CONTROLLO_PASSWORD Grid: method perform @9-B48879D3
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
//End CONTROLLO_PASSWORD Grid: method perform

//CONTROLLO_PASSWORD Grid: method read: head @9-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End CONTROLLO_PASSWORD Grid: method read: head

//CONTROLLO_PASSWORD Grid: method read: init @9-4DB11069
            if ( ! model.allowRead ) return true;
            CONTROLLO_PASSWORDDataObject ds = new CONTROLLO_PASSWORDDataObject(page);
            ds.setComponent( model );
//End CONTROLLO_PASSWORD Grid: method read: init

//CONTROLLO_PASSWORD Grid: set where parameters @9-C2E04A19
            ds.setSesModulo( SessionStorage.getInstance(req).getAttribute("Modulo") );
            ds.setSesIstanza( SessionStorage.getInstance(req).getAttribute("Istanza") );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setSesProgetto( SessionStorage.getInstance(req).getAttribute("Progetto") );
//End CONTROLLO_PASSWORD Grid: set where parameters

//CONTROLLO_PASSWORD Grid: set grid properties @9-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End CONTROLLO_PASSWORD Grid: set grid properties

//CONTROLLO_PASSWORD Grid: retrieve data @9-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End CONTROLLO_PASSWORD Grid: retrieve data

//CONTROLLO_PASSWORD Grid: check errors @9-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End CONTROLLO_PASSWORD Grid: check errors

//CONTROLLO_PASSWORD Grid: method read: tail @9-F575E732
            return ( ! isErrors );
        }
//End CONTROLLO_PASSWORD Grid: method read: tail

//CONTROLLO_PASSWORD Grid: method bind @9-FF69C15A
        public void bind(com.codecharge.components.Component model, CONTROLLO_PASSWORDRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            CONTROLLO_PASSWORDRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("PWD");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("PWD").clone();
                    c.setValue(row.getPWD());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End CONTROLLO_PASSWORD Grid: method bind

//CONTROLLO_PASSWORD Directory: getRowFieldByName @9-F3AE5BD1
        public Object getRowFieldByName( String name, CONTROLLO_PASSWORDRow row ) {
            Object value = null;
            if ( "PWD".equals(name) ) {
                value = row.getPWD();
            }
            return value;
        }
//End CONTROLLO_PASSWORD Directory: getRowFieldByName

//CONTROLLO_PASSWORD Grid: method validate @9-104025BA
        boolean validate() {
            return true;
        }
//End CONTROLLO_PASSWORD Grid: method validate

//CONTROLLO_PASSWORD Grid Tail @9-FCB6E20C
    }
//End CONTROLLO_PASSWORD Grid Tail

//AmvAccesso Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvAccesso Page: method validate

//AmvAccessoAction Tail @1-FCB6E20C
}
//End AmvAccessoAction Tail

