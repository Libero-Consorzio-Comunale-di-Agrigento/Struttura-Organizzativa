//AdmUtenteAccessiAction imports @1-344078F2
package amvadm.AdmUtenteAccessi;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmUtenteAccessiAction imports

//AdmUtenteAccessiAction class @1-0252ABE7
public class AdmUtenteAccessiAction extends Action {

//End AdmUtenteAccessiAction class

//AdmUtenteAccessiAction: method perform @1-FFFBC2B9
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AdmUtenteAccessiModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AdmUtenteAccessiModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AdmUtenteAccessiAction: method perform

//AdmUtenteAccessiAction: call children actions @1-65D43CF2
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
        if ( page.getChild( "AmvUtenteNominativo_i" ).isVisible() ) {
            page.getRequest().setAttribute("AmvUtenteNominativo_iParent",page);
            common.AmvUtenteNominativo_i.AmvUtenteNominativo_iAction AmvUtenteNominativo_i = new common.AmvUtenteNominativo_i.AmvUtenteNominativo_iAction();
            result = result != null ? result : AmvUtenteNominativo_i.perform( req, resp,  context );
            page.setCookies();
        }
        if (result == null) {
            AD4_UTENTIClass AD4_UTENTI = new AD4_UTENTIClass();
            if ( ( redirect = AD4_UTENTI.perform( page.getRecord("AD4_UTENTI")) ) != null ) result = redirect;
        }
        if (result == null) {
            AD4_DIRITTI_ACCESSOClass AD4_DIRITTI_ACCESSO = new AD4_DIRITTI_ACCESSOClass();
            AD4_DIRITTI_ACCESSO.perform(page.getGrid("AD4_DIRITTI_ACCESSO"));
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
//End AdmUtenteAccessiAction: call children actions

//AD4_UTENTI Record @6-2850471E
    final class AD4_UTENTIClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AD4_UTENTI Record

//AD4_UTENTI Record: method perform @6-8A8B28B2
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AdmUtenteAccessi" + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
//End AD4_UTENTI Record: method perform

//AD4_UTENTI Record: children actions @6-8EC3EBE6
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("AD4_UTENTI".equals(formName)) {
                setProperties(model, Action.POST);
                if (mode != -1) { // Update mode
                    model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                } else { // Insert mode
                    model.setMode(com.codecharge.components.Record.INSERT_MODE);
                }
            }
            setProperties(model, Action.GET, true );
            read();
//End AD4_UTENTI Record: children actions

//AD4_UTENTI Record: method perform tail @6-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AD4_UTENTI Record: method perform tail

void read() { //AD4_UTENTI Record: method read @6-7F8AAE5A

//AD4_UTENTI Record: method read head @6-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AD4_UTENTI Record: method read head

//AD4_UTENTI Record: init DataSource @6-2AB68DC8
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AD4_UTENTIDataObject ds = new AD4_UTENTIDataObject(page);
            ds.setComponent( model );
            ds.setSesMVUTE( SessionStorage.getInstance(req).getAttribute("MVUTE") );
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End AD4_UTENTI Record: init DataSource

//AD4_UTENTI Record: check errors @6-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End AD4_UTENTI Record: check errors

} //AD4_UTENTI Record: method read tail @6-FCB6E20C

//AD4_UTENTI Record: bind @6-99C0D53B
            public void bind(com.codecharge.components.Component model, AD4_UTENTIRow row ) {
                if ( model == null || row == null ) return;
                model.getControl("NOMINATIVO").setValue(row.getNOMINATIVO());
                model.getControl("UTENTE").setValue(row.getUTENTE());
                model.getControl("DSP_ID_UTENTE").setValue(row.getDSP_ID_UTENTE());
                model.getControl("ULTIMO_TENTATIVO").setValue(row.getULTIMO_TENTATIVO());
                model.getControl("DSP_NUMERO_TENTATIVI").setValue(row.getDSP_NUMERO_TENTATIVI());
                model.getControl("DATA_INSERIMENTO").setValue(row.getDATA_INSERIMENTO());
                model.getControl("DATA_AGGIORNAMENTO").setValue(row.getDATA_AGGIORNAMENTO());
                model.getControl("UTENTE_AGGIORNAMENTO").setValue(row.getUTENTE_AGGIORNAMENTO());
                if ( this.valid ) {
                }
            }
//End AD4_UTENTI Record: bind

//AD4_UTENTI Record: getRowFieldByName @6-EEA9A1CC
            public Object getRowFieldByName( String name, AD4_UTENTIRow row ) {
                Object value = null;
                if ( "NOMINATIVO".equals(name) ) {
                    value = row.getNOMINATIVO();
                } else if ( "UTENTE".equals(name) ) {
                    value = row.getUTENTE();
                } else if ( "DSP_ID_UTENTE".equals(name) ) {
                    value = row.getDSP_ID_UTENTE();
                } else if ( "ULTIMO_TENTATIVO".equals(name) ) {
                    value = row.getULTIMO_TENTATIVO();
                } else if ( "DSP_NUMERO_TENTATIVI".equals(name) ) {
                    value = row.getDSP_NUMERO_TENTATIVI();
                } else if ( "DATA_INSERIMENTO".equals(name) ) {
                    value = row.getDATA_INSERIMENTO();
                } else if ( "DATA_AGGIORNAMENTO".equals(name) ) {
                    value = row.getDATA_AGGIORNAMENTO();
                } else if ( "UTENTE_AGGIORNAMENTO".equals(name) ) {
                    value = row.getUTENTE_AGGIORNAMENTO();
                }
                return value;
            }
//End AD4_UTENTI Record: getRowFieldByName

void InsertAction() { //AD4_UTENTI Record: method insert @6-11643485

//AD4_UTENTI Record: components insert actions @6-68525650
            if (! model.hasErrors()) {
            }
//End AD4_UTENTI Record: components insert actions

} //AD4_UTENTI Record: method insert tail @6-FCB6E20C

void UpdateAction() { //AD4_UTENTI Record: method update @6-5771D0AA

//AD4_UTENTI Record: components update actions @6-68525650
            if (! model.hasErrors()) {
            }
//End AD4_UTENTI Record: components update actions

} //AD4_UTENTI Record: method update tail @6-FCB6E20C

void DeleteAction() { //AD4_UTENTI Record: method delete @6-11FC2E1E

//AD4_UTENTI Record: components delete actions @6-68525650
            if (! model.hasErrors()) {
            }
//End AD4_UTENTI Record: components delete actions

} //AD4_UTENTI Record: method delete tail @6-FCB6E20C

//AD4_UTENTI Record: method validate @6-A8FFD717
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AD4_UTENTI Record: method validate

//AD4_UTENTI Record Tail @6-FCB6E20C
    }
//End AD4_UTENTI Record Tail

//AD4_DIRITTI_ACCESSO Grid @22-7B165BF1
    final class AD4_DIRITTI_ACCESSOClass {
        com.codecharge.components.Grid model;
        Event e;
//End AD4_DIRITTI_ACCESSO Grid

//AD4_DIRITTI_ACCESSO Grid: method perform @22-B48879D3
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
//End AD4_DIRITTI_ACCESSO Grid: method perform

//AD4_DIRITTI_ACCESSO Grid: method read: head @22-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End AD4_DIRITTI_ACCESSO Grid: method read: head

//AD4_DIRITTI_ACCESSO Grid: method read: init @22-1CB22FA3
            if ( ! model.allowRead ) return true;
            AD4_DIRITTI_ACCESSODataObject ds = new AD4_DIRITTI_ACCESSODataObject(page);
            ds.setComponent( model );
//End AD4_DIRITTI_ACCESSO Grid: method read: init

//AD4_DIRITTI_ACCESSO Grid: set where parameters @22-1176B7F5
            ds.setSesMVUTE( SessionStorage.getInstance(req).getAttribute("MVUTE") );
            ds.setSesProgetto( SessionStorage.getInstance(req).getAttribute("Progetto") );
//End AD4_DIRITTI_ACCESSO Grid: set where parameters

//AD4_DIRITTI_ACCESSO Grid: set grid properties @22-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End AD4_DIRITTI_ACCESSO Grid: set grid properties

//AD4_DIRITTI_ACCESSO Grid: retrieve data @22-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End AD4_DIRITTI_ACCESSO Grid: retrieve data

//AD4_DIRITTI_ACCESSO Grid: check errors @22-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End AD4_DIRITTI_ACCESSO Grid: check errors

//AD4_DIRITTI_ACCESSO Grid: method read: tail @22-F575E732
            return ( ! isErrors );
        }
//End AD4_DIRITTI_ACCESSO Grid: method read: tail

//AD4_DIRITTI_ACCESSO Grid: method bind @22-D75DA504
        public void bind(com.codecharge.components.Component model, AD4_DIRITTI_ACCESSORow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            AD4_DIRITTI_ACCESSORow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("DES_SERVIZIO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("DES_SERVIZIO").clone();
                    c.setValue(row.getDES_SERVIZIO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("DSP_ACCESSO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("DSP_ACCESSO").clone();
                    c.setValue(row.getDSP_ACCESSO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("DSP_NOTE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("DSP_NOTE").clone();
                    c.setValue(row.getDSP_NOTE());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End AD4_DIRITTI_ACCESSO Grid: method bind

//AD4_DIRITTI_ACCESSO Directory: getRowFieldByName @22-FC0CD5BE
        public Object getRowFieldByName( String name, AD4_DIRITTI_ACCESSORow row ) {
            Object value = null;
            if ( "DES_SERVIZIO".equals(name) ) {
                value = row.getDES_SERVIZIO();
            } else if ( "DSP_ACCESSO".equals(name) ) {
                value = row.getDSP_ACCESSO();
            } else if ( "DSP_NOTE".equals(name) ) {
                value = row.getDSP_NOTE();
            }
            return value;
        }
//End AD4_DIRITTI_ACCESSO Directory: getRowFieldByName

//AD4_DIRITTI_ACCESSO Grid: method validate @22-104025BA
        boolean validate() {
            return true;
        }
//End AD4_DIRITTI_ACCESSO Grid: method validate

//AD4_DIRITTI_ACCESSO Grid Tail @22-FCB6E20C
    }
//End AD4_DIRITTI_ACCESSO Grid Tail

//AdmUtenteAccessi Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AdmUtenteAccessi Page: method validate

//AdmUtenteAccessiAction Tail @1-FCB6E20C
}
//End AdmUtenteAccessiAction Tail


