//AmvLeftMenuAction imports @1-E50BCF74
package common.AmvLeftMenu;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvLeftMenuAction imports

//AmvLeftMenuAction class @1-DB8E29B4
public class AmvLeftMenuAction extends Action {

//End AmvLeftMenuAction class

//AmvLeftMenuAction: method perform @1-46B79CB7
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvLeftMenuModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvLeftMenuModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvLeftMenuAction: method perform

//AmvLeftMenuAction: call children actions @1-6C4644CE
        if (result == null) {
            MenuClass Menu = new MenuClass();
            Menu.perform(page.getGrid("Menu"));
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvLeftMenuAction: call children actions

//Menu Grid @103-5E647A22
    final class MenuClass {
        com.codecharge.components.Grid model;
        Event e;
//End Menu Grid

//Menu Grid: method perform @103-B48879D3
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
//End Menu Grid: method perform

//Menu Grid: method read: head @103-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End Menu Grid: method read: head

//Menu Grid: method read: init @103-BF687D2F
            if ( ! model.allowRead ) return true;
            MenuDataObject ds = new MenuDataObject(page);
            ds.setComponent( model );
//End Menu Grid: method read: init

//Menu Grid: set where parameters @103-77C1A5CB
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setSesIstanza( SessionStorage.getInstance(req).getAttribute("Istanza") );
            ds.setSesModulo( SessionStorage.getInstance(req).getAttribute("Modulo") );
            ds.setSesMVL2( SessionStorage.getInstance(req).getAttribute("MVL2") );
            ds.setSesMVL3( SessionStorage.getInstance(req).getAttribute("MVL3") );
            ds.setSesRuolo( SessionStorage.getInstance(req).getAttribute("Ruolo") );
            ds.setSesMVURL( SessionStorage.getInstance(req).getAttribute("MVURL") );
            ds.setSesMVRP( SessionStorage.getInstance(req).getAttribute("MVRP") );
            ds.setSesMVCONTEXT( SessionStorage.getInstance(req).getAttribute("MVCONTEXT") );
            ds.setSesMVL1( SessionStorage.getInstance(req).getAttribute("MVL1") );
            ds.setSesMVVC( SessionStorage.getInstance(req).getAttribute("MVVC") );
//End Menu Grid: set where parameters

//Menu Grid: set grid properties @103-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End Menu Grid: set grid properties

//Menu Grid: retrieve data @103-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End Menu Grid: retrieve data

//Menu Grid: check errors @103-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End Menu Grid: check errors

//Menu Grid: method read: tail @103-F575E732
            return ( ! isErrors );
        }
//End Menu Grid: method read: tail

//Menu Grid: method bind @103-48F174C4
        public void bind(com.codecharge.components.Component model, MenuRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            MenuRow row = null;
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
//End Menu Grid: method bind

//Menu Directory: getRowFieldByName @103-24F61946
        public Object getRowFieldByName( String name, MenuRow row ) {
            Object value = null;
            if ( "MENU".equals(name) ) {
                value = row.getMENU();
            }
            return value;
        }
//End Menu Directory: getRowFieldByName

//Menu Grid: method validate @103-104025BA
        boolean validate() {
            return true;
        }
//End Menu Grid: method validate

//Menu Grid Tail @103-FCB6E20C
    }
//End Menu Grid Tail

//AmvLeftMenu Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvLeftMenu Page: method validate

//AmvLeftMenuAction Tail @1-FCB6E20C
}
//End AmvLeftMenuAction Tail

