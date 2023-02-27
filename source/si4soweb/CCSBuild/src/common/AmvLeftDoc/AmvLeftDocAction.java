//AmvLeftDocAction imports @1-2A28FD80
package common.AmvLeftDoc;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvLeftDocAction imports

//AmvLeftDocAction class @1-E0DCFBCD
public class AmvLeftDocAction extends Action {

//End AmvLeftDocAction class

//AmvLeftDocAction: method perform @1-D8DB4529
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvLeftDocModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvLeftDocModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvLeftDocAction: method perform

//AmvLeftDocAction: call children actions @1-788645EA
        if (result == null) {
            Zona_SClass Zona_S = new Zona_SClass();
            Zona_S.perform(page.getGrid("Zona_S"));
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvLeftDocAction: call children actions

//Zona_S Grid @34-8C36665E
    final class Zona_SClass {
        com.codecharge.components.Grid model;
        Event e;
//End Zona_S Grid

//Zona_S Grid: method perform @34-B48879D3
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
//End Zona_S Grid: method perform

//Zona_S Grid: method read: head @34-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End Zona_S Grid: method read: head

//Zona_S Grid: method read: init @34-187F5C64
            if ( ! model.allowRead ) return true;
            Zona_SDataObject ds = new Zona_SDataObject(page);
            ds.setComponent( model );
//End Zona_S Grid: method read: init

//Zona_S Grid: set where parameters @34-BAC1460D
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            try {
                ds.setUrlMVSZ( page.getHttpGetParams().getParameter("MVSZ"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVSZ'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVSZ'" );
                return false;
            }
//End Zona_S Grid: set where parameters

//Zona_S Grid: set grid properties @34-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End Zona_S Grid: set grid properties

//Zona_S Grid: retrieve data @34-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End Zona_S Grid: retrieve data

//Zona_S Grid: check errors @34-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End Zona_S Grid: check errors

//Zona_S Grid: method read: tail @34-F575E732
            return ( ! isErrors );
        }
//End Zona_S Grid: method read: tail

//Zona_S Grid: method bind @34-7000329A
        public void bind(com.codecharge.components.Component model, Zona_SRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            Zona_SRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("ZONA_S");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("ZONA_S").clone();
                    c.setValue(row.getZONA_S());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End Zona_S Grid: method bind

//Zona_S Directory: getRowFieldByName @34-4166ECFA
        public Object getRowFieldByName( String name, Zona_SRow row ) {
            Object value = null;
            if ( "ZONA_S".equals(name) ) {
                value = row.getZONA_S();
            } else if ( "ID_ARTICOLO".equals(name) ) {
                value = row.getID_ARTICOLO();
            } else if ( "VIS_LINK".equals(name) ) {
                value = row.getVIS_LINK();
            }
            return value;
        }
//End Zona_S Directory: getRowFieldByName

//Zona_S Grid: method validate @34-104025BA
        boolean validate() {
            return true;
        }
//End Zona_S Grid: method validate

//Zona_S Grid Tail @34-FCB6E20C
    }
//End Zona_S Grid Tail

//AmvLeftDoc Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvLeftDoc Page: method validate

//AmvLeftDocAction Tail @1-FCB6E20C
}
//End AmvLeftDocAction Tail

