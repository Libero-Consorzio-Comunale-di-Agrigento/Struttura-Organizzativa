//AmvUtenteNominativo_iAction imports @1-C1CD33C5
package common.AmvUtenteNominativo_i;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvUtenteNominativo_iAction imports

//AmvUtenteNominativo_iAction class @1-902564C8
public class AmvUtenteNominativo_iAction extends Action {

//End AmvUtenteNominativo_iAction class

//AmvUtenteNominativo_iAction: method perform @1-AFFCCD51
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvUtenteNominativo_iModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvUtenteNominativo_iModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvUtenteNominativo_iAction: method perform

//AmvUtenteNominativo_iAction: call children actions @1-03B55C63
        if (result == null) {
            UTENTE_CONTROLClass UTENTE_CONTROL = new UTENTE_CONTROLClass();
            UTENTE_CONTROL.perform(page.getGrid("UTENTE_CONTROL"));
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvUtenteNominativo_iAction: call children actions

//UTENTE_CONTROL Grid @2-F2FFDF61
    final class UTENTE_CONTROLClass {
        com.codecharge.components.Grid model;
        Event e;
//End UTENTE_CONTROL Grid

//UTENTE_CONTROL Grid: method perform @2-B48879D3
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
//End UTENTE_CONTROL Grid: method perform

//UTENTE_CONTROL Grid: method read: head @2-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End UTENTE_CONTROL Grid: method read: head

//UTENTE_CONTROL Grid: method read: init @2-1F4D6EA7
            if ( ! model.allowRead ) return true;
            UTENTE_CONTROLDataObject ds = new UTENTE_CONTROLDataObject(page);
            ds.setComponent( model );
//End UTENTE_CONTROL Grid: method read: init

//UTENTE_CONTROL Grid: set where parameters @2-EE74B547
            ds.setUrlIDUTE( page.getHttpGetParams().getParameter("IDUTE") );
            ds.setSesMVUTE( SessionStorage.getInstance(req).getAttribute("MVUTE") );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setSesProgetto( SessionStorage.getInstance(req).getAttribute("Progetto") );
            ds.setSesGroupID( SessionStorage.getInstance(req).getAttribute("GroupID") );
//End UTENTE_CONTROL Grid: set where parameters

//UTENTE_CONTROL Grid: set grid properties @2-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End UTENTE_CONTROL Grid: set grid properties

//UTENTE_CONTROL Grid: retrieve data @2-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End UTENTE_CONTROL Grid: retrieve data

//UTENTE_CONTROL Grid: check errors @2-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End UTENTE_CONTROL Grid: check errors

//UTENTE_CONTROL Grid: method read: tail @2-F575E732
            return ( ! isErrors );
        }
//End UTENTE_CONTROL Grid: method read: tail

//UTENTE_CONTROL Grid: method bind @2-8153C9CC
        public void bind(com.codecharge.components.Component model, UTENTE_CONTROLRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            UTENTE_CONTROLRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("NOMINATIVO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("NOMINATIVO").clone();
                    c.setValue(row.getNOMINATIVO());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End UTENTE_CONTROL Grid: method bind

//UTENTE_CONTROL Directory: getRowFieldByName @2-A36F4DF1
        public Object getRowFieldByName( String name, UTENTE_CONTROLRow row ) {
            Object value = null;
            if ( "NOMINATIVO".equals(name) ) {
                value = row.getNOMINATIVO();
            }
            return value;
        }
//End UTENTE_CONTROL Directory: getRowFieldByName

//UTENTE_CONTROL Grid: method validate @2-104025BA
        boolean validate() {
            return true;
        }
//End UTENTE_CONTROL Grid: method validate

//UTENTE_CONTROL Grid Tail @2-FCB6E20C
    }
//End UTENTE_CONTROL Grid Tail

//AmvUtenteNominativo_i Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvUtenteNominativo_i Page: method validate

//AmvUtenteNominativo_iAction Tail @1-FCB6E20C
}
//End AmvUtenteNominativo_iAction Tail

