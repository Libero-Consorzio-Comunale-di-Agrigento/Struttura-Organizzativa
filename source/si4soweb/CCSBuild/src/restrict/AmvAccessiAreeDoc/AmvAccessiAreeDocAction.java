//AmvAccessiAreeDocAction imports @1-6E9CF6A2
package restrict.AmvAccessiAreeDoc;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvAccessiAreeDocAction imports

//AmvAccessiAreeDocAction class @1-A4225C0A
public class AmvAccessiAreeDocAction extends Action {

//End AmvAccessiAreeDocAction class

//AmvAccessiAreeDocAction: method perform @1-9DF8A10C
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvAccessiAreeDocModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvAccessiAreeDocModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvAccessiAreeDocAction: method perform

//AmvAccessiAreeDocAction: call children actions @1-88645CBF
        if ( page.getChild( "Header" ).isVisible() ) {
            page.getRequest().setAttribute("HeaderParent",page);
            common.Header.HeaderAction Header = new common.Header.HeaderAction();
            result = result != null ? result : Header.perform( req, resp,  context );
            page.setCookies();
        }
        if ( page.getChild( "Left" ).isVisible() ) {
            page.getRequest().setAttribute("LeftParent",page);
            common.Left.LeftAction Left = new common.Left.LeftAction();
            result = result != null ? result : Left.perform( req, resp,  context );
            page.setCookies();
        }
        if ( page.getChild( "AmvGuida" ).isVisible() ) {
            page.getRequest().setAttribute("AmvGuidaParent",page);
            common.AmvGuida.AmvGuidaAction AmvGuida = new common.AmvGuida.AmvGuidaAction();
            result = result != null ? result : AmvGuida.perform( req, resp,  context );
            page.setCookies();
        }
        if (result == null) {
            AMV_DIRITTIClass AMV_DIRITTI = new AMV_DIRITTIClass();
            AMV_DIRITTI.perform(page.getGrid("AMV_DIRITTI"));
        }
        if ( page.getChild( "Footer" ).isVisible() ) {
            page.getRequest().setAttribute("FooterParent",page);
            common.Footer.FooterAction Footer = new common.Footer.FooterAction();
            result = result != null ? result : Footer.perform( req, resp,  context );
            page.setCookies();
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvAccessiAreeDocAction: call children actions

//AMV_DIRITTI Grid @6-C11B00EC
    final class AMV_DIRITTIClass {
        com.codecharge.components.Grid model;
        Event e;
//End AMV_DIRITTI Grid

//AMV_DIRITTI Grid: method perform @6-B48879D3
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
//End AMV_DIRITTI Grid: method perform

//AMV_DIRITTI Grid: method read: head @6-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End AMV_DIRITTI Grid: method read: head

//AMV_DIRITTI Grid: method read: init @6-9BA574F8
            if ( ! model.allowRead ) return true;
            AMV_DIRITTIDataObject ds = new AMV_DIRITTIDataObject(page);
            ds.setComponent( model );
//End AMV_DIRITTI Grid: method read: init

//AMV_DIRITTI Grid: set where parameters @6-D786DA30
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
//End AMV_DIRITTI Grid: set where parameters

//AMV_DIRITTI Grid: set grid properties @6-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End AMV_DIRITTI Grid: set grid properties

//AMV_DIRITTI Grid: retrieve data @6-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End AMV_DIRITTI Grid: retrieve data

//AMV_DIRITTI Grid: check errors @6-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End AMV_DIRITTI Grid: check errors

//AMV_DIRITTI Grid: method read: tail @6-F575E732
            return ( ! isErrors );
        }
//End AMV_DIRITTI Grid: method read: tail

//AMV_DIRITTI Grid: method bind @6-2844549A
        public void bind(com.codecharge.components.Component model, AMV_DIRITTIRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            AMV_DIRITTIRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("AREA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("AREA").clone();
                    c.setValue(row.getAREA());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("TIPOLOGIA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("TIPOLOGIA").clone();
                    c.setValue(row.getTIPOLOGIA());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("DES_ACCESSO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("DES_ACCESSO").clone();
                    c.setValue(row.getDES_ACCESSO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("GRUPPO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("GRUPPO").clone();
                    c.setValue(row.getGRUPPO());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End AMV_DIRITTI Grid: method bind

//AMV_DIRITTI Directory: getRowFieldByName @6-4C8CD612
        public Object getRowFieldByName( String name, AMV_DIRITTIRow row ) {
            Object value = null;
            if ( "AREA".equals(name) ) {
                value = row.getAREA();
            } else if ( "TIPOLOGIA".equals(name) ) {
                value = row.getTIPOLOGIA();
            } else if ( "DES_ACCESSO".equals(name) ) {
                value = row.getDES_ACCESSO();
            } else if ( "GRUPPO".equals(name) ) {
                value = row.getGRUPPO();
            } else if ( "AFCNavigator".equals(name) ) {
                value = row.getAFCNavigator();
            }
            return value;
        }
//End AMV_DIRITTI Directory: getRowFieldByName

//AMV_DIRITTI Grid: method validate @6-104025BA
        boolean validate() {
            return true;
        }
//End AMV_DIRITTI Grid: method validate

//AMV_DIRITTI Grid Tail @6-FCB6E20C
    }
//End AMV_DIRITTI Grid Tail

//AmvAccessiAreeDoc Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvAccessiAreeDoc Page: method validate

//AmvAccessiAreeDocAction Tail @1-FCB6E20C
}
//End AmvAccessiAreeDocAction Tail

