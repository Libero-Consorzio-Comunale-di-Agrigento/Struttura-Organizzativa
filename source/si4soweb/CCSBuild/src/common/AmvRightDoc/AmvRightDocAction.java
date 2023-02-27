//AmvRightDocAction imports @1-AD3E4D4D
package common.AmvRightDoc;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvRightDocAction imports

//AmvRightDocAction class @1-E24FB6C0
public class AmvRightDocAction extends Action {

//End AmvRightDocAction class

//AmvRightDocAction: method perform @1-B18F9B3E
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvRightDocModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvRightDocModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvRightDocAction: method perform

//AmvRightDocAction: call children actions @1-714B7FEB
        if (result == null) {
            Zona_DClass Zona_D = new Zona_DClass();
            Zona_D.perform(page.getGrid("Zona_D"));
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvRightDocAction: call children actions

//Zona_D Grid @34-886F9556
    final class Zona_DClass {
        com.codecharge.components.Grid model;
        Event e;
//End Zona_D Grid

//Zona_D Grid: method perform @34-B48879D3
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
//End Zona_D Grid: method perform

//Zona_D Grid: method read: head @34-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End Zona_D Grid: method read: head

//Zona_D Grid: method read: init @34-D473318A
            if ( ! model.allowRead ) return true;
            Zona_DDataObject ds = new Zona_DDataObject(page);
            ds.setComponent( model );
//End Zona_D Grid: method read: init

//Zona_D Grid: set where parameters @34-BAC1460D
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
//End Zona_D Grid: set where parameters

//Zona_D Grid: set grid properties @34-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End Zona_D Grid: set grid properties

//Zona_D Grid: retrieve data @34-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End Zona_D Grid: retrieve data

//Zona_D Grid: check errors @34-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End Zona_D Grid: check errors

//Zona_D Grid: method read: tail @34-F575E732
            return ( ! isErrors );
        }
//End Zona_D Grid: method read: tail

//Zona_D Grid: method bind @34-EC186BB2
        public void bind(com.codecharge.components.Component model, Zona_DRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            Zona_DRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("ZONA_D");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("ZONA_D").clone();
                    c.setValue(row.getZONA_D());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End Zona_D Grid: method bind

//Zona_D Directory: getRowFieldByName @34-40B352D1
        public Object getRowFieldByName( String name, Zona_DRow row ) {
            Object value = null;
            if ( "ZONA_D".equals(name) ) {
                value = row.getZONA_D();
            } else if ( "ID_ARTICOLO".equals(name) ) {
                value = row.getID_ARTICOLO();
            } else if ( "VIS_LINK".equals(name) ) {
                value = row.getVIS_LINK();
            }
            return value;
        }
//End Zona_D Directory: getRowFieldByName

//Zona_D Grid: method validate @34-104025BA
        boolean validate() {
            return true;
        }
//End Zona_D Grid: method validate

//Zona_D Grid Tail @34-FCB6E20C
    }
//End Zona_D Grid Tail

//AmvRightDoc Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvRightDoc Page: method validate

//AmvRightDocAction Tail @1-FCB6E20C
}
//End AmvRightDocAction Tail


