//AmvUtentePasswordAction imports @1-392A7591
package restrict.AmvUtentePassword;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvUtentePasswordAction imports

//AmvUtentePasswordAction class @1-6CA96862
public class AmvUtentePasswordAction extends Action {

//End AmvUtentePasswordAction class

//AmvUtentePasswordAction: method perform @1-75DFBCA6
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvUtentePasswordModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvUtentePasswordModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvUtentePasswordAction: method perform

//AmvUtentePasswordAction: call children actions @1-B137504F
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
//End AmvUtentePasswordAction: call children actions

//AD4_UTENTI Record @6-2850471E
    final class AD4_UTENTIClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AD4_UTENTI Record

//AD4_UTENTI Record: method perform @6-CEB65B21
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AmvProfilo" + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowUpdate() ) model.getChild( "Button_Update" ).setVisible( false );
//End AD4_UTENTI Record: method perform

//AD4_UTENTI Record: children actions @6-08F6CDD6
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
                    if (page.getParameter("Button_Update") != null) {
                        if (validate()) {
                            Button_UpdateAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Button_Cancel") != null) {
                        Button_CancelAction();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                } else { // Insert mode
                    model.setMode(com.codecharge.components.Record.INSERT_MODE);
                    if (page.getParameter("Button_Cancel") != null) {
                        Button_CancelAction();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
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

//Button_Update Button @26-077DCE80
        void Button_UpdateAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Button_Update");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AmvProfilo" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Button_Update Button

//Button_Cancel Button @28-65367A7D
        void Button_CancelAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Button_Cancel");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AmvProfilo" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
        }
//End Button_Cancel Button

void read() { //AD4_UTENTI Record: method read @6-7F8AAE5A

//AD4_UTENTI Record: method read head @6-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AD4_UTENTI Record: method read head

//AD4_UTENTI Record: init DataSource @6-BFA48B4D
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AD4_UTENTIDataObject ds = new AD4_UTENTIDataObject(page);
            ds.setComponent( model );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
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

//AD4_UTENTI Record: bind @6-6F287085
            public void bind(com.codecharge.components.Component model, AD4_UTENTIRow row ) {
                if ( model == null || row == null ) return;
                if ( this.valid ) {
                }
            }
//End AD4_UTENTI Record: bind

//AD4_UTENTI Record: getRowFieldByName @6-74E50F60
            public Object getRowFieldByName( String name, AD4_UTENTIRow row ) {
                Object value = null;
                if ( "PASSWORD_ATTUALE".equals(name) ) {
                    value = row.getPASSWORD_ATTUALE();
                } else if ( "NUOVA_PASSWORD".equals(name) ) {
                    value = row.getNUOVA_PASSWORD();
                } else if ( "CONFERMA_PASSWORD".equals(name) ) {
                    value = row.getCONFERMA_PASSWORD();
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

//AD4_UTENTI Record: method update body @6-F1050A73
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            AD4_UTENTIDataObject ds = new AD4_UTENTIDataObject(page);
            ds.setComponent( model );
            AD4_UTENTIRow row = new AD4_UTENTIRow();
            ds.setRow(row);
            row.setPASSWORD_ATTUALE(Utils.convertToString(model.getControl("PASSWORD_ATTUALE").getValue()));
            row.setNUOVA_PASSWORD(Utils.convertToString(model.getControl("NUOVA_PASSWORD").getValue()));
            row.setCONFERMA_PASSWORD(Utils.convertToString(model.getControl("CONFERMA_PASSWORD").getValue()));
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
//End AD4_UTENTI Record: method update body

//AD4_UTENTI Record: ds.update @6-6E956EDC
            ds.update();
            if ( ! ds.hasErrors() ) {
            }
            model.fireAfterUpdateEvent();
            action = true;
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
                this.valid = false;
            }
//End AD4_UTENTI Record: ds.update

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

//AD4_UTENTI Record: method validate @6-F871E5AC
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.TextBox PASSWORD_ATTUALE = (com.codecharge.components.TextBox) model.getChild( "PASSWORD_ATTUALE" );
            if (! PASSWORD_ATTUALE.validate()) { isControlError = true; }

            com.codecharge.components.TextBox NUOVA_PASSWORD = (com.codecharge.components.TextBox) model.getChild( "NUOVA_PASSWORD" );
            if (! NUOVA_PASSWORD.validate()) { isControlError = true; }

            com.codecharge.components.TextBox CONFERMA_PASSWORD = (com.codecharge.components.TextBox) model.getChild( "CONFERMA_PASSWORD" );
            if (! CONFERMA_PASSWORD.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AD4_UTENTI Record: method validate

//AD4_UTENTI Record Tail @6-FCB6E20C
    }
//End AD4_UTENTI Record Tail

//AmvUtentePassword Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvUtentePassword Page: method validate

//AmvUtentePasswordAction Tail @1-FCB6E20C
}
//End AmvUtentePasswordAction Tail

