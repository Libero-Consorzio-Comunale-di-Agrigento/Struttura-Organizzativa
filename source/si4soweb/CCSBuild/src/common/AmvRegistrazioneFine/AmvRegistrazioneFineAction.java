//AmvRegistrazioneFineAction imports @1-AD5404DA
package common.AmvRegistrazioneFine;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvRegistrazioneFineAction imports

//AmvRegistrazioneFineAction class @1-5193EBDF
public class AmvRegistrazioneFineAction extends Action {

//End AmvRegistrazioneFineAction class

//AmvRegistrazioneFineAction: method perform @1-06FAD373
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvRegistrazioneFineModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvRegistrazioneFineModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvRegistrazioneFineAction: method perform

//AmvRegistrazioneFineAction: call children actions @1-B21DB378
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
        if ( page.getChild( "Guida" ).isVisible() ) {
            page.getRequest().setAttribute("GuidaParent",page);
            common.Guida.GuidaAction Guida = new common.Guida.GuidaAction();
            result = result != null ? result : Guida.perform( req, resp,  context );
            page.setCookies();
        }
        if (result == null) {
            MESSAGGIO_RICHIESTAClass MESSAGGIO_RICHIESTA = new MESSAGGIO_RICHIESTAClass();
            MESSAGGIO_RICHIESTA.perform(page.getGrid("MESSAGGIO_RICHIESTA"));
        }
        if ( page.getChild( "AmvServiziElenco" ).isVisible() ) {
            page.getRequest().setAttribute("AmvServiziElencoParent",page);
            common.AmvServiziElenco_i.AmvServiziElenco_iAction AmvServiziElenco = new common.AmvServiziElenco_i.AmvServiziElenco_iAction();
            result = result != null ? result : AmvServiziElenco.perform( req, resp,  context );
            page.setCookies();
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
//End AmvRegistrazioneFineAction: call children actions

//MESSAGGIO_RICHIESTA Grid @7-3D8A91BF
    final class MESSAGGIO_RICHIESTAClass {
        com.codecharge.components.Grid model;
        Event e;
//End MESSAGGIO_RICHIESTA Grid

//MESSAGGIO_RICHIESTA Grid: method perform @7-B48879D3
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
//End MESSAGGIO_RICHIESTA Grid: method perform

//MESSAGGIO_RICHIESTA Grid: method read: head @7-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End MESSAGGIO_RICHIESTA Grid: method read: head

//MESSAGGIO_RICHIESTA Grid: method read: init @7-11B85D1F
            if ( ! model.allowRead ) return true;
            MESSAGGIO_RICHIESTADataObject ds = new MESSAGGIO_RICHIESTADataObject(page);
            ds.setComponent( model );
//End MESSAGGIO_RICHIESTA Grid: method read: init

//MESSAGGIO_RICHIESTA Grid: set where parameters @7-9CB26746
            try {
                ds.setSesMVRIC( SessionStorage.getInstance(req).getAttribute("MVRIC"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVRIC'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVRIC'" );
                return false;
            }
//End MESSAGGIO_RICHIESTA Grid: set where parameters

//MESSAGGIO_RICHIESTA Grid: set grid properties @7-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End MESSAGGIO_RICHIESTA Grid: set grid properties

//MESSAGGIO_RICHIESTA Grid: retrieve data @7-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End MESSAGGIO_RICHIESTA Grid: retrieve data

//MESSAGGIO_RICHIESTA Grid: check errors @7-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End MESSAGGIO_RICHIESTA Grid: check errors

//MESSAGGIO_RICHIESTA Grid: method read: tail @7-F575E732
            return ( ! isErrors );
        }
//End MESSAGGIO_RICHIESTA Grid: method read: tail

//MESSAGGIO_RICHIESTA Grid: method bind @7-F508E595
        public void bind(com.codecharge.components.Component model, MESSAGGIO_RICHIESTARow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            MESSAGGIO_RICHIESTARow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("MSG");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("MSG").clone();
                    c.setValue(row.getMSG());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End MESSAGGIO_RICHIESTA Grid: method bind

//MESSAGGIO_RICHIESTA Directory: getRowFieldByName @7-0C06C36B
        public Object getRowFieldByName( String name, MESSAGGIO_RICHIESTARow row ) {
            Object value = null;
            if ( "MSG".equals(name) ) {
                value = row.getMSG();
            }
            return value;
        }
//End MESSAGGIO_RICHIESTA Directory: getRowFieldByName

//MESSAGGIO_RICHIESTA Grid: method validate @7-104025BA
        boolean validate() {
            return true;
        }
//End MESSAGGIO_RICHIESTA Grid: method validate

//MESSAGGIO_RICHIESTA Grid Tail @7-FCB6E20C
    }
//End MESSAGGIO_RICHIESTA Grid Tail

//AmvRegistrazioneFine Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvRegistrazioneFine Page: method validate

//AmvRegistrazioneFineAction Tail @1-FCB6E20C
}
//End AmvRegistrazioneFineAction Tail

