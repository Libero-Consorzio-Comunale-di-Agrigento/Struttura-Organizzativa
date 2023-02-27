//AmvStyleAction imports @1-8F434BF9
package common.AmvStyle;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvStyleAction imports

//AmvStyleAction class @1-42E4C124
public class AmvStyleAction extends Action {

//End AmvStyleAction class

//AmvStyleAction: method perform @1-DC99F6D8
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvStyleModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvStyleModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvStyleAction: method perform

//AmvStyleAction: call children actions @1-45A65C78
        if (result == null) {
            styleClass style = new styleClass();
            style.perform(page.getGrid("style"));
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvStyleAction: call children actions

//style Grid @2-D497595C
    final class styleClass {
        com.codecharge.components.Grid model;
        Event e;
//End style Grid

//style Grid: method perform @2-B48879D3
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

//style Grid: method read: head @2-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End style Grid: method read: head

//style Grid: method read: init @2-3F136F9A
            if ( ! model.allowRead ) return true;
            styleDataObject ds = new styleDataObject(page);
            ds.setComponent( model );
//End style Grid: method read: init

//style Grid: set where parameters @2-EF60F66C
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
//End style Grid: set where parameters

//style Grid: set grid properties @2-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End style Grid: set grid properties

//style Grid: retrieve data @2-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End style Grid: retrieve data

//style Grid: check errors @2-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End style Grid: check errors

//style Grid: method read: tail @2-F575E732
            return ( ! isErrors );
        }
//End style Grid: method read: tail

//style Grid: method bind @2-B26C9AA5
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

                c = (com.codecharge.components.Control) hashRow.get("STILE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("STILE").clone();
                    c.setValue(row.getSTILE());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End style Grid: method bind

//style Directory: getRowFieldByName @2-4D951ED2
        public Object getRowFieldByName( String name, styleRow row ) {
            Object value = null;
            if ( "STILE".equals(name) ) {
                value = row.getSTILE();
            }
            return value;
        }
//End style Directory: getRowFieldByName

//style Grid: method validate @2-104025BA
        boolean validate() {
            return true;
        }
//End style Grid: method validate

//style Grid Tail @2-FCB6E20C
    }
//End style Grid Tail

//AmvStyle Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvStyle Page: method validate

//AmvStyleAction Tail @1-FCB6E20C
}
//End AmvStyleAction Tail

