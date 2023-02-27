//AmvStiliAction imports @1-2B76BECE
package restrict.AmvStili;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvStiliAction imports

//AmvStiliAction class @1-749D4AA5
public class AmvStiliAction extends Action {

//End AmvStiliAction class

//AmvStiliAction: method perform @1-777C2CFC
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvStiliModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvStiliModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvStiliAction: method perform

//AmvStiliAction: call children actions @1-45A65C78
        if (result == null) {
            styleClass style = new styleClass();
            style.perform(page.getGrid("style"));
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvStiliAction: call children actions

//style Grid @3-D497595C
    final class styleClass {
        com.codecharge.components.Grid model;
        Event e;
//End style Grid

//style Grid: method perform @3-B48879D3
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
//End style Grid: method perform

//style Grid: method read: head @3-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End style Grid: method read: head

//style Grid: method read: init @3-3F136F9A
            if ( ! model.allowRead ) return true;
            styleDataObject ds = new styleDataObject(page);
            ds.setComponent( model );
//End style Grid: method read: init

//style Grid: set grid properties @3-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End style Grid: set grid properties

//style Grid: retrieve data @3-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End style Grid: retrieve data

//style Grid: check errors @3-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End style Grid: check errors

//style Grid: method read: tail @3-F575E732
            return ( ! isErrors );
        }
//End style Grid: method read: tail

//style Grid: method bind @3-E931B1CC
        public void bind(com.codecharge.components.Component model, styleRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            styleRow row = null;
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
                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End style Grid: method bind

//style Directory: getRowFieldByName @3-4D951ED2
        public Object getRowFieldByName( String name, styleRow row ) {
            Object value = null;
            if ( "STILE".equals(name) ) {
                value = row.getSTILE();
            }
            return value;
        }
//End style Directory: getRowFieldByName

//style Grid: method validate @3-104025BA
        boolean validate() {
            return true;
        }
//End style Grid: method validate

//style Grid Tail @3-FCB6E20C
    }
//End style Grid Tail

//AmvStili Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvStili Page: method validate

//AmvStiliAction Tail @1-FCB6E20C
}
//End AmvStiliAction Tail

