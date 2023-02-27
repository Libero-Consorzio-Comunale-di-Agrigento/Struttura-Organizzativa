//AdmUtentiGruppoAggiornaAction imports @1-38969511
package amvadm.AdmUtentiGruppoAggiorna;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmUtentiGruppoAggiornaAction imports

//AdmUtentiGruppoAggiornaAction class @1-240D4A14
public class AdmUtentiGruppoAggiornaAction extends Action {

//End AdmUtentiGruppoAggiornaAction class

//AdmUtentiGruppoAggiornaAction: method perform @1-F6DFDE13
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AdmUtentiGruppoAggiornaModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AdmUtentiGruppoAggiornaModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AdmUtentiGruppoAggiornaAction: method perform

//AdmUtentiGruppoAggiornaAction: call children actions @1-D96BF541
        if (result == null) {
            UTENTI_GRUPPOClass UTENTI_GRUPPO = new UTENTI_GRUPPOClass();
            if ( ( redirect = UTENTI_GRUPPO.perform( page.getRecord("UTENTI_GRUPPO")) ) != null ) result = redirect;
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AdmUtentiGruppoAggiornaAction: call children actions

//UTENTI_GRUPPO Record @2-9F74AA63
    final class UTENTI_GRUPPOClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End UTENTI_GRUPPO Record

//UTENTI_GRUPPO Record: method perform @2-694FBD39
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AmvPreferenzeStile" + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowInsert() ) model.getChild( "Button_Insert" ).setVisible( false );
            if ( ! model.isAllowUpdate() ) model.getChild( "Button_Update" ).setVisible( false );
            if ( ! model.isAllowDelete() ) model.getChild( "Button_Delete" ).setVisible( false );
//End UTENTI_GRUPPO Record: method perform

//UTENTI_GRUPPO Record: children actions @2-3D190CF0
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("UTENTI_GRUPPO".equals(formName)) {
                setProperties(model, Action.POST);
                if (mode != -1) { // Update mode
                    model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                    if (page.getParameter("Button_Update") != null) {
                        if (validate()) {
                            Button_UpdateAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Button_Delete") != null) {
                        Button_DeleteAction();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                } else { // Insert mode
                    model.setMode(com.codecharge.components.Record.INSERT_MODE);
                    if (page.getParameter("Button_Insert") != null) {
                        if (validate()) {
                            Button_InsertAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                }
            }
            setProperties(model, Action.GET, true );
            read();
//End UTENTI_GRUPPO Record: children actions

//UTENTI_GRUPPO Record: method perform tail @2-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End UTENTI_GRUPPO Record: method perform tail

//Button_Insert Button @7-7AF5A541
        void Button_InsertAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Button_Insert");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AmvPreferenzeStile" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            InsertAction();
        }
//End Button_Insert Button

//Button_Update Button @8-4A64AC5F
        void Button_UpdateAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Button_Update");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AmvPreferenzeStile" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Button_Update Button

//Button_Delete Button @9-B49A2143
        void Button_DeleteAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Button_Delete");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AmvPreferenzeStile" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            DeleteAction();
        }
//End Button_Delete Button

void read() { //UTENTI_GRUPPO Record: method read @2-7F8AAE5A

//UTENTI_GRUPPO Record: method read head @2-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End UTENTI_GRUPPO Record: method read head

//UTENTI_GRUPPO Record: init DataSource @2-7BA62046
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            UTENTI_GRUPPODataObject ds = new UTENTI_GRUPPODataObject(page);
            ds.setComponent( model );
            ds.setUrlMVUTE( page.getHttpGetParams().getParameter("MVUTE") );
            ds.setUrlMVGRU( page.getHttpGetParams().getParameter("MVGRU") );
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End UTENTI_GRUPPO Record: init DataSource

//UTENTI_GRUPPO Record: check errors @2-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End UTENTI_GRUPPO Record: check errors

} //UTENTI_GRUPPO Record: method read tail @2-FCB6E20C

//UTENTI_GRUPPO Record: bind @2-79E8C88E
            public void bind(com.codecharge.components.Component model, UTENTI_GRUPPORow row ) {
                if ( model == null || row == null ) return;
                if ( this.valid ) {
                    model.getControl("UTENTE").setValue(row.getUTENTE());
                    model.getControl("P_GRUPPO").setValue(row.getP_GRUPPO());
                }
            }
//End UTENTI_GRUPPO Record: bind

//UTENTI_GRUPPO Record: getRowFieldByName @2-A8D16249
            public Object getRowFieldByName( String name, UTENTI_GRUPPORow row ) {
                Object value = null;
                if ( "UTENTE".equals(name) ) {
                    value = row.getUTENTE();
                } else if ( "P_GRUPPO".equals(name) ) {
                    value = row.getP_GRUPPO();
                }
                return value;
            }
//End UTENTI_GRUPPO Record: getRowFieldByName

void InsertAction() { //UTENTI_GRUPPO Record: method insert @2-11643485

//UTENTI_GRUPPO Record: method insert head @2-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End UTENTI_GRUPPO Record: method insert head

//UTENTI_GRUPPO Record: components insert actions @2-68525650
            if (! model.hasErrors()) {
            }
//End UTENTI_GRUPPO Record: components insert actions

} //UTENTI_GRUPPO Record: method insert tail @2-FCB6E20C

void UpdateAction() { //UTENTI_GRUPPO Record: method update @2-5771D0AA

//UTENTI_GRUPPO Record: method update head @2-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End UTENTI_GRUPPO Record: method update head

//UTENTI_GRUPPO Record: method update body @2-5A71105F
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            UTENTI_GRUPPODataObject ds = new UTENTI_GRUPPODataObject(page);
            ds.setComponent( model );
            UTENTI_GRUPPORow row = new UTENTI_GRUPPORow();
            ds.setRow(row);
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setUrlP_DB_USER( page.getHttpGetParams().getParameter("P_DB_USER") );
            ds.setSesProgetto( SessionStorage.getInstance(req).getAttribute("Progetto") );
            ds.setUrlSTYLESHEET( page.getHttpGetParams().getParameter("STYLESHEET") );
//End UTENTI_GRUPPO Record: method update body

//UTENTI_GRUPPO Record: ds.update @2-6E956EDC
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
//End UTENTI_GRUPPO Record: ds.update

} //UTENTI_GRUPPO Record: method update tail @2-FCB6E20C

void DeleteAction() { //UTENTI_GRUPPO Record: method delete @2-11FC2E1E

//UTENTI_GRUPPO Record: method delete head @2-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End UTENTI_GRUPPO Record: method delete head

//UTENTI_GRUPPO Record: components delete actions @2-68525650
            if (! model.hasErrors()) {
            }
//End UTENTI_GRUPPO Record: components delete actions

} //UTENTI_GRUPPO Record: method delete tail @2-FCB6E20C

//UTENTI_GRUPPO Record: method validate @2-CA6924A0
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.TextBox UTENTE = (com.codecharge.components.TextBox) model.getChild( "UTENTE" );
            if (! UTENTE.validate()) { isControlError = true; }

            com.codecharge.components.TextBox P_GRUPPO = (com.codecharge.components.TextBox) model.getChild( "P_GRUPPO" );
            if (! P_GRUPPO.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End UTENTI_GRUPPO Record: method validate

//UTENTI_GRUPPO Record Tail @2-FCB6E20C
    }
//End UTENTI_GRUPPO Record Tail

//AdmUtentiGruppoAggiorna Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AdmUtentiGruppoAggiorna Page: method validate

//AdmUtentiGruppoAggiornaAction Tail @1-FCB6E20C
}
//End AdmUtentiGruppoAggiornaAction Tail

