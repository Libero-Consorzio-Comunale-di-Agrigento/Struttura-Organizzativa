//AmvLeftSezioneAction imports @1-FB8D56E1
package common.AmvLeftSezione;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvLeftSezioneAction imports

//AmvLeftSezioneAction class @1-A18D738D
public class AmvLeftSezioneAction extends Action {

//End AmvLeftSezioneAction class

//AmvLeftSezioneAction: method perform @1-EB1C771E
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvLeftSezioneModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvLeftSezioneModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvLeftSezioneAction: method perform

//AmvLeftSezioneAction: call children actions @1-FF7D5933
        if (result == null) {
            SEZIONI_SClass SEZIONI_S = new SEZIONI_SClass();
            SEZIONI_S.perform(page.getGrid("SEZIONI_S"));
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvLeftSezioneAction: call children actions

//SEZIONI_S Grid @72-6073C819
    final class SEZIONI_SClass {
        com.codecharge.components.Grid model;
        Event e;
//End SEZIONI_S Grid

//SEZIONI_S Grid: method perform @72-B48879D3
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
//End SEZIONI_S Grid: method perform

//SEZIONI_S Grid: method read: head @72-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End SEZIONI_S Grid: method read: head

//SEZIONI_S Grid: method read: init @72-BFA244BE
            if ( ! model.allowRead ) return true;
            SEZIONI_SDataObject ds = new SEZIONI_SDataObject(page);
            ds.setComponent( model );
//End SEZIONI_S Grid: method read: init

//SEZIONI_S Grid: set where parameters @72-BAC1460D
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
//End SEZIONI_S Grid: set where parameters

//SEZIONI_S Grid: set grid properties @72-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End SEZIONI_S Grid: set grid properties

//SEZIONI_S Grid: retrieve data @72-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End SEZIONI_S Grid: retrieve data

//SEZIONI_S Grid: check errors @72-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End SEZIONI_S Grid: check errors

//SEZIONI_S Grid: method read: tail @72-F575E732
            return ( ! isErrors );
        }
//End SEZIONI_S Grid: method read: tail

//SEZIONI_S Grid: method bind @72-A7143355
        public void bind(com.codecharge.components.Component model, SEZIONI_SRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            SEZIONI_SRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("BLOCCO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("BLOCCO").clone();
                    c.setValue(row.getBLOCCO());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End SEZIONI_S Grid: method bind

//SEZIONI_S Directory: getRowFieldByName @72-28F99E4D
        public Object getRowFieldByName( String name, SEZIONI_SRow row ) {
            Object value = null;
            if ( "BLOCCO".equals(name) ) {
                value = row.getBLOCCO();
            } else if ( "ID_ARTICOLO".equals(name) ) {
                value = row.getID_ARTICOLO();
            } else if ( "VIS_LINK".equals(name) ) {
                value = row.getVIS_LINK();
            }
            return value;
        }
//End SEZIONI_S Directory: getRowFieldByName

//SEZIONI_S Grid: method validate @72-104025BA
        boolean validate() {
            return true;
        }
//End SEZIONI_S Grid: method validate

//SEZIONI_S Grid Tail @72-FCB6E20C
    }
//End SEZIONI_S Grid Tail

//AmvLeftSezione Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvLeftSezione Page: method validate

//AmvLeftSezioneAction Tail @1-FCB6E20C
}
//End AmvLeftSezioneAction Tail
