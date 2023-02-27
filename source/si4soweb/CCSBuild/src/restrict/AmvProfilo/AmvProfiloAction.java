//AmvProfiloAction imports @1-0281C1E9
package restrict.AmvProfilo;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvProfiloAction imports

//AmvProfiloAction class @1-D72AD9F6
public class AmvProfiloAction extends Action {

//End AmvProfiloAction class

//AmvProfiloAction: method perform @1-4DAAF58E
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvProfiloModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvProfiloModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvProfiloAction: method perform

//AmvProfiloAction: call children actions @1-057CF4F0
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
            MESSAGGIO_PASSWORDClass MESSAGGIO_PASSWORD = new MESSAGGIO_PASSWORDClass();
            MESSAGGIO_PASSWORD.perform(page.getGrid("MESSAGGIO_PASSWORD"));
        }
        if (result == null) {
            AD4_UTENTIClass AD4_UTENTI = new AD4_UTENTIClass();
            if ( ( redirect = AD4_UTENTI.perform( page.getRecord("AD4_UTENTI")) ) != null ) result = redirect;
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
//End AmvProfiloAction: call children actions

//MESSAGGIO_PASSWORD Grid @42-16036305
    final class MESSAGGIO_PASSWORDClass {
        com.codecharge.components.Grid model;
        Event e;
//End MESSAGGIO_PASSWORD Grid

//MESSAGGIO_PASSWORD Grid: method perform @42-B48879D3
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
//End MESSAGGIO_PASSWORD Grid: method perform

//MESSAGGIO_PASSWORD Grid: method read: head @42-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End MESSAGGIO_PASSWORD Grid: method read: head

//MESSAGGIO_PASSWORD Grid: method read: init @42-D9882496
            if ( ! model.allowRead ) return true;
            MESSAGGIO_PASSWORDDataObject ds = new MESSAGGIO_PASSWORDDataObject(page);
            ds.setComponent( model );
//End MESSAGGIO_PASSWORD Grid: method read: init

//MESSAGGIO_PASSWORD Grid: set where parameters @42-C2E04A19
            ds.setSesModulo( SessionStorage.getInstance(req).getAttribute("Modulo") );
            ds.setSesIstanza( SessionStorage.getInstance(req).getAttribute("Istanza") );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setSesProgetto( SessionStorage.getInstance(req).getAttribute("Progetto") );
//End MESSAGGIO_PASSWORD Grid: set where parameters

//MESSAGGIO_PASSWORD Grid: set grid properties @42-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End MESSAGGIO_PASSWORD Grid: set grid properties

//MESSAGGIO_PASSWORD Grid: retrieve data @42-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End MESSAGGIO_PASSWORD Grid: retrieve data

//MESSAGGIO_PASSWORD Grid: check errors @42-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End MESSAGGIO_PASSWORD Grid: check errors

//MESSAGGIO_PASSWORD Grid: method read: tail @42-F575E732
            return ( ! isErrors );
        }
//End MESSAGGIO_PASSWORD Grid: method read: tail

//MESSAGGIO_PASSWORD Grid: method bind @42-6894C2EE
        public void bind(com.codecharge.components.Component model, MESSAGGIO_PASSWORDRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            MESSAGGIO_PASSWORDRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("MESSAGGIO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("MESSAGGIO").clone();
                    c.setValue(row.getMESSAGGIO());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End MESSAGGIO_PASSWORD Grid: method bind

//MESSAGGIO_PASSWORD Directory: getRowFieldByName @42-3875A74C
        public Object getRowFieldByName( String name, MESSAGGIO_PASSWORDRow row ) {
            Object value = null;
            if ( "MESSAGGIO".equals(name) ) {
                value = row.getMESSAGGIO();
            }
            return value;
        }
//End MESSAGGIO_PASSWORD Directory: getRowFieldByName

//MESSAGGIO_PASSWORD Grid: method validate @42-104025BA
        boolean validate() {
            return true;
        }
//End MESSAGGIO_PASSWORD Grid: method validate

//MESSAGGIO_PASSWORD Grid Tail @42-FCB6E20C
    }
//End MESSAGGIO_PASSWORD Grid Tail

//AD4_UTENTI Record @6-2850471E
    final class AD4_UTENTIClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AD4_UTENTI Record

//AD4_UTENTI Record: method perform @6-463F57FC
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AmvUtentePassword" + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
//End AD4_UTENTI Record: method perform

//AD4_UTENTI Record: children actions @6-232868C0
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("AD4_UTENTI".equals(formName)) {
                setProperties(model, Action.POST);
                    if (validate()) {
                        Button_UpdateAction();
                        if ( !model.hasErrors()) return page.getRedirectString();
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

//Button_Update Button @26-283DC984
        void Button_UpdateAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Button_Update");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AmvUtentePassword" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
        }
//End Button_Update Button

void read() { //AD4_UTENTI Record: method read @6-7F8AAE5A

//AD4_UTENTI Record: method read head @6-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AD4_UTENTI Record: method read head

//AD4_UTENTI Record: init DataSource @6-FF751B08
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AD4_UTENTIDataObject ds = new AD4_UTENTIDataObject(page);
            ds.setComponent( model );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setSesRuolo( SessionStorage.getInstance(req).getAttribute("Ruolo") );
            ds.setSesMVUTE( SessionStorage.getInstance(req).getAttribute("MVUTE") );
            ds.setSesModulo( SessionStorage.getInstance(req).getAttribute("Modulo") );
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

//AD4_UTENTI Record: bind @6-2E9BFB15
            public void bind(com.codecharge.components.Component model, AD4_UTENTIRow row ) {
                if ( model == null || row == null ) return;
                model.getControl("NOMINATIVO").setValue(row.getNOMINATIVO());
                model.getControl("RUOLO").setValue(row.getRUOLO());
                model.getControl("DATA_PASSWORD").setValue(row.getDATA_PASSWORD());
                if ( this.valid ) {
                    model.getControl("RINNOVO_PASSWORD_PORTALE").setValue(row.getRINNOVO_PASSWORD_PORTALE());
                    model.getControl("RINNOVO_PASSWORD").setValue(row.getRINNOVO_PASSWORD());
                }
            }
//End AD4_UTENTI Record: bind

//AD4_UTENTI Record: getRowFieldByName @6-31351AD9
            public Object getRowFieldByName( String name, AD4_UTENTIRow row ) {
                Object value = null;
                if ( "NOMINATIVO".equals(name) ) {
                    value = row.getNOMINATIVO();
                } else if ( "RUOLO".equals(name) ) {
                    value = row.getRUOLO();
                } else if ( "DATA_PASSWORD".equals(name) ) {
                    value = row.getDATA_PASSWORD();
                } else if ( "RINNOVO_PASSWORD_PORTALE".equals(name) ) {
                    value = row.getRINNOVO_PASSWORD_PORTALE();
                } else if ( "RINNOVO_PASSWORD".equals(name) ) {
                    value = row.getRINNOVO_PASSWORD();
                }
                return value;
            }
//End AD4_UTENTI Record: getRowFieldByName

void InsertAction() { //AD4_UTENTI Record: method insert @6-11643485

//AD4_UTENTI Record: method insert head @6-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End AD4_UTENTI Record: method insert head

//AD4_UTENTI Record: components insert actions @6-68525650
            if (! model.hasErrors()) {
            }
//End AD4_UTENTI Record: components insert actions

} //AD4_UTENTI Record: method insert tail @6-FCB6E20C

void UpdateAction() { //AD4_UTENTI Record: method update @6-5771D0AA

//AD4_UTENTI Record: method update head @6-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End AD4_UTENTI Record: method update head

//AD4_UTENTI Record: components update actions @6-68525650
            if (! model.hasErrors()) {
            }
//End AD4_UTENTI Record: components update actions

} //AD4_UTENTI Record: method update tail @6-FCB6E20C

void DeleteAction() { //AD4_UTENTI Record: method delete @6-11FC2E1E

//AD4_UTENTI Record: method delete head @6-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End AD4_UTENTI Record: method delete head

//AD4_UTENTI Record: components delete actions @6-68525650
            if (! model.hasErrors()) {
            }
//End AD4_UTENTI Record: components delete actions

} //AD4_UTENTI Record: method delete tail @6-FCB6E20C

//AD4_UTENTI Record: method validate @6-19B16867
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.Hidden RINNOVO_PASSWORD_PORTALE = (com.codecharge.components.Hidden) model.getChild( "RINNOVO_PASSWORD_PORTALE" );
            if (! RINNOVO_PASSWORD_PORTALE.validate()) { isControlError = true; }

            com.codecharge.components.Hidden RINNOVO_PASSWORD = (com.codecharge.components.Hidden) model.getChild( "RINNOVO_PASSWORD" );
            if (! RINNOVO_PASSWORD.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AD4_UTENTI Record: method validate

//AD4_UTENTI Record Tail @6-FCB6E20C
    }
//End AD4_UTENTI Record Tail

//AmvProfilo Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvProfilo Page: method validate

//AmvProfiloAction Tail @1-FCB6E20C
}
//End AmvProfiloAction Tail

