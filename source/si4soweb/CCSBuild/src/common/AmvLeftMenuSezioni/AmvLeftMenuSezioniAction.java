//AmvLeftMenuSezioniAction imports @1-66891B25
package common.AmvLeftMenuSezioni;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvLeftMenuSezioniAction imports

//AmvLeftMenuSezioniAction class @1-7F668D62
public class AmvLeftMenuSezioniAction extends Action {

//End AmvLeftMenuSezioniAction class

//AmvLeftMenuSezioniAction: method perform @1-4AB84484
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvLeftMenuSezioniModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvLeftMenuSezioniModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvLeftMenuSezioniAction: method perform

//AmvLeftMenuSezioniAction: call children actions @1-5EFC100A
        if (result == null) {
            MENU_SEZIONIClass MENU_SEZIONI = new MENU_SEZIONIClass();
            MENU_SEZIONI.perform(page.getGrid("MENU_SEZIONI"));
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvLeftMenuSezioniAction: call children actions

//MENU_SEZIONI Grid @79-A5CDCF22
    final class MENU_SEZIONIClass {
        com.codecharge.components.Grid model;
        Event e;
//End MENU_SEZIONI Grid

//MENU_SEZIONI Grid: method perform @79-B48879D3
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
//End MENU_SEZIONI Grid: method perform

//MENU_SEZIONI Grid: method read: head @79-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End MENU_SEZIONI Grid: method read: head

//MENU_SEZIONI Grid: method read: init @79-1362FE1A
            if ( ! model.allowRead ) return true;
            MENU_SEZIONIDataObject ds = new MENU_SEZIONIDataObject(page);
            ds.setComponent( model );
//End MENU_SEZIONI Grid: method read: init

//MENU_SEZIONI Grid: set where parameters @79-C1D909A7
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
            ds.setSesMVPC( SessionStorage.getInstance(req).getAttribute("MVPC") );
//End MENU_SEZIONI Grid: set where parameters

//MENU_SEZIONI Grid: set grid properties @79-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End MENU_SEZIONI Grid: set grid properties

//MENU_SEZIONI Grid: retrieve data @79-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End MENU_SEZIONI Grid: retrieve data

//MENU_SEZIONI Grid: check errors @79-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End MENU_SEZIONI Grid: check errors

//MENU_SEZIONI Grid: method read: tail @79-F575E732
            return ( ! isErrors );
        }
//End MENU_SEZIONI Grid: method read: tail

//MENU_SEZIONI Grid: method bind @79-1479E828
        public void bind(com.codecharge.components.Component model, MENU_SEZIONIRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            MENU_SEZIONIRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("MENU_SEZ");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("MENU_SEZ").clone();
                    c.setValue(row.getMENU_SEZ());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End MENU_SEZIONI Grid: method bind

//MENU_SEZIONI Directory: getRowFieldByName @79-7A15C3CC
        public Object getRowFieldByName( String name, MENU_SEZIONIRow row ) {
            Object value = null;
            if ( "MENU_SEZ".equals(name) ) {
                value = row.getMENU_SEZ();
            } else if ( "ID_ARTICOLO".equals(name) ) {
                value = row.getID_ARTICOLO();
            } else if ( "VIS_LINK".equals(name) ) {
                value = row.getVIS_LINK();
            }
            return value;
        }
//End MENU_SEZIONI Directory: getRowFieldByName

//MENU_SEZIONI Grid: method validate @79-104025BA
        boolean validate() {
            return true;
        }
//End MENU_SEZIONI Grid: method validate

//MENU_SEZIONI Grid Tail @79-FCB6E20C
    }
//End MENU_SEZIONI Grid Tail

//AmvLeftMenuSezioni Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvLeftMenuSezioni Page: method validate

//AmvLeftMenuSezioniAction Tail @1-FCB6E20C
}
//End AmvLeftMenuSezioniAction Tail
