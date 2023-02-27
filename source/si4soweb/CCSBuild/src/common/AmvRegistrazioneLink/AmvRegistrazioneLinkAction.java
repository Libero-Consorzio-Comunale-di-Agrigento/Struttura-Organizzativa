//AmvRegistrazioneLinkAction imports @1-1B5F4064
package common.AmvRegistrazioneLink;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvRegistrazioneLinkAction imports

//AmvRegistrazioneLinkAction class @1-896A17DE
public class AmvRegistrazioneLinkAction extends Action {

//End AmvRegistrazioneLinkAction class

//AmvRegistrazioneLinkAction: method perform @1-BB9464DE
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvRegistrazioneLinkModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvRegistrazioneLinkModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvRegistrazioneLinkAction: method perform

//AmvRegistrazioneLinkAction: call children actions @1-D4C5A039
        if (result == null) {
            registrazione_servizioClass registrazione_servizio = new registrazione_servizioClass();
            registrazione_servizio.perform(page.getGrid("registrazione_servizio"));
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvRegistrazioneLinkAction: call children actions

//registrazione_servizio Grid @2-FA1D0C11
    final class registrazione_servizioClass {
        com.codecharge.components.Grid model;
        Event e;
//End registrazione_servizio Grid

//registrazione_servizio Grid: method perform @2-B48879D3
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
//End registrazione_servizio Grid: method perform

//registrazione_servizio Grid: method read: head @2-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End registrazione_servizio Grid: method read: head

//registrazione_servizio Grid: method read: init @2-093C8C01
            if ( ! model.allowRead ) return true;
            registrazione_servizioDataObject ds = new registrazione_servizioDataObject(page);
            ds.setComponent( model );
//End registrazione_servizio Grid: method read: init

//registrazione_servizio Grid: set where parameters @2-6F91FF4A
            ds.setSesIstanza( SessionStorage.getInstance(req).getAttribute("Istanza") );
            ds.setSesModulo( SessionStorage.getInstance(req).getAttribute("Modulo") );
            ds.setSesUserLogin( SessionStorage.getInstance(req).getAttribute("UserLogin") );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setSesRuolo( SessionStorage.getInstance(req).getAttribute("Ruolo") );
//End registrazione_servizio Grid: set where parameters

//registrazione_servizio Grid: set grid properties @2-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End registrazione_servizio Grid: set grid properties

//registrazione_servizio Grid: retrieve data @2-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End registrazione_servizio Grid: retrieve data

//registrazione_servizio Grid: check errors @2-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End registrazione_servizio Grid: check errors

//registrazione_servizio Grid: method read: tail @2-F575E732
            return ( ! isErrors );
        }
//End registrazione_servizio Grid: method read: tail

//registrazione_servizio Grid: method bind @2-C1ABF2E8
        public void bind(com.codecharge.components.Component model, registrazione_servizioRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            registrazione_servizioRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("SERVIZIO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("SERVIZIO").clone();
                    c.setValue(row.getSERVIZIO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("NOMINATIVO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("NOMINATIVO").clone();
                    c.setValue(row.getNOMINATIVO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("REGISTRAZIONE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("REGISTRAZIONE").clone();
                    c.setValue(row.getREGISTRAZIONE());
                    hashRow.put( c.getName(), c );
                }
                ((com.codecharge.components.Link) c).getParameter("MODULO").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("MODULO").getSourceName(), row ));
                ((com.codecharge.components.Link) c).getParameter("ISTANZA").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("ISTANZA").getSourceName(), row ));

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End registrazione_servizio Grid: method bind

//registrazione_servizio Directory: getRowFieldByName @2-FEEC9A5C
        public Object getRowFieldByName( String name, registrazione_servizioRow row ) {
            Object value = null;
            if ( "SERVIZIO".equals(name) ) {
                value = row.getSERVIZIO();
            } else if ( "NOMINATIVO".equals(name) ) {
                value = row.getNOMINATIVO();
            } else if ( "REGISTRAZIONE".equals(name) ) {
                value = row.getREGISTRAZIONE();
            } else if ( "MODULO".equals(name) ) {
                value = row.getMODULO();
            } else if ( "ISTANZA".equals(name) ) {
                value = row.getISTANZA();
            }
            return value;
        }
//End registrazione_servizio Directory: getRowFieldByName

//registrazione_servizio Grid: method validate @2-104025BA
        boolean validate() {
            return true;
        }
//End registrazione_servizio Grid: method validate

//registrazione_servizio Grid Tail @2-FCB6E20C
    }
//End registrazione_servizio Grid Tail

//AmvRegistrazioneLink Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvRegistrazioneLink Page: method validate

//AmvRegistrazioneLinkAction Tail @1-FCB6E20C
}
//End AmvRegistrazioneLinkAction Tail

