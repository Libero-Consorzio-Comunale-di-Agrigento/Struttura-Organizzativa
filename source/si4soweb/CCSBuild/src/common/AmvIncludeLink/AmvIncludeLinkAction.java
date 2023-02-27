//AmvIncludeLinkAction imports @1-EC161491
package common.AmvIncludeLink;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvIncludeLinkAction imports

//AmvIncludeLinkAction class @1-BFAA1F8F
public class AmvIncludeLinkAction extends Action {

//End AmvIncludeLinkAction class

//AmvIncludeLinkAction: method perform @1-4F55FDC8
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvIncludeLinkModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvIncludeLinkModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvIncludeLinkAction: method perform

//AmvIncludeLinkAction: call children actions @1-A100B6A3
        if (result == null) {
            PaginaClass Pagina = new PaginaClass();
            Pagina.perform(page.getGrid("Pagina"));
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvIncludeLinkAction: call children actions

//Pagina Grid @3-9893E640
    final class PaginaClass {
        com.codecharge.components.Grid model;
        Event e;
//End Pagina Grid

//Pagina Grid: method perform @3-B48879D3
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
//End Pagina Grid: method perform

//Pagina Grid: method read: head @3-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End Pagina Grid: method read: head

//Pagina Grid: method read: init @3-C941F598
            if ( ! model.allowRead ) return true;
            PaginaDataObject ds = new PaginaDataObject(page);
            ds.setComponent( model );
//End Pagina Grid: method read: init

//Pagina Grid: set grid properties @3-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End Pagina Grid: set grid properties

//Pagina Grid: retrieve data @3-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End Pagina Grid: retrieve data

//Pagina Grid: check errors @3-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End Pagina Grid: check errors

//Pagina Grid: method read: tail @3-F575E732
            return ( ! isErrors );
        }
//End Pagina Grid: method read: tail

//Pagina Grid: method bind @3-09F3BBB1
        public void bind(com.codecharge.components.Component model, PaginaRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            PaginaRow row = null;
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
//End Pagina Grid: method bind

//Pagina Directory: getRowFieldByName @3-382CF3D3
        public Object getRowFieldByName( String name, PaginaRow row ) {
            Object value = null;
            if ( "PAGE_LINK".equals(name) ) {
                value = row.getPAGE_LINK();
            }
            return value;
        }
//End Pagina Directory: getRowFieldByName

//Pagina Grid: method validate @3-104025BA
        boolean validate() {
            return true;
        }
//End Pagina Grid: method validate

//Pagina Grid Tail @3-FCB6E20C
    }
//End Pagina Grid Tail

//AmvIncludeLink Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvIncludeLink Page: method validate

//AmvIncludeLinkAction Tail @1-FCB6E20C
}
//End AmvIncludeLinkAction Tail


