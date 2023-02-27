//AmvStileAggiornaAction imports @1-FC34182E
package restrict.AmvStileAggiorna;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvStileAggiornaAction imports

//AmvStileAggiornaAction class @1-9FF09AEA
public class AmvStileAggiornaAction extends Action {

//End AmvStileAggiornaAction class

//AmvStileAggiornaAction: method perform @1-4F6A0CFB
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvStileAggiornaModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvStileAggiornaModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvStileAggiornaAction: method perform

//AmvStileAggiornaAction: call children actions @1-F047E38A
        if (result == null) {
            STILEClass STILE = new STILEClass();
            if ( ( redirect = STILE.perform( page.getRecord("STILE")) ) != null ) result = redirect;
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvStileAggiornaAction: call children actions

//STILE Record @2-2FBD004E
    final class STILEClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End STILE Record

//STILE Record: method perform @2-C8127014
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AmvPreferenzeStile" + Names.ACTION_SUFFIX );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowInsert() ) model.getChild( "Button_Insert" ).setVisible( false );
            if ( ! model.isAllowUpdate() ) model.getChild( "Button_Update" ).setVisible( false );
            if ( ! model.isAllowDelete() ) model.getChild( "Button_Delete" ).setVisible( false );
//End STILE Record: method perform

//STILE Record: children actions @2-697C5924
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("STILE".equals(formName)) {
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
//End STILE Record: children actions

//STILE Record: method perform tail @2-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End STILE Record: method perform tail

//Button_Insert Button @5-EB5F6DBC
        void Button_InsertAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Button_Insert");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AmvPreferenzeStile" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            InsertAction();
        }
//End Button_Insert Button

//Button_Update Button @6-65CBBDD3
        void Button_UpdateAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Button_Update");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AmvPreferenzeStile" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Button_Update Button

//Button_Delete Button @7-E24C5DFA
        void Button_DeleteAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Button_Delete");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AmvPreferenzeStile" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            DeleteAction();
        }
//End Button_Delete Button

void read() { //STILE Record: method read @2-7F8AAE5A

//STILE Record: method read head @2-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End STILE Record: method read head

//STILE Record: init DataSource @2-E18765F0
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            STILEDataObject ds = new STILEDataObject(page);
            ds.setComponent( model );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setSesModulo( SessionStorage.getInstance(req).getAttribute("Modulo") );
            ds.setUrlSTYLESHEET( page.getHttpGetParams().getParameter("STYLESHEET") );
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End STILE Record: init DataSource

//STILE Record: check errors @2-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End STILE Record: check errors

} //STILE Record: method read tail @2-FCB6E20C

//STILE Record: bind @2-C8D1B660
            public void bind(com.codecharge.components.Component model, STILERow row ) {
                if ( model == null || row == null ) return;
                if ( this.valid ) {
                    model.getControl("P_UTENTE").setValue(row.getP_UTENTE());
                    model.getControl("P_STRINGA").setValue(row.getP_STRINGA());
                    model.getControl("P_MODULO").setValue(row.getP_MODULO());
                    model.getControl("P_STYLESHEET").setValue(row.getP_STYLESHEET());
                }
            }
//End STILE Record: bind

//STILE Record: getRowFieldByName @2-A842A3CA
            public Object getRowFieldByName( String name, STILERow row ) {
                Object value = null;
                if ( "P_UTENTE".equals(name) ) {
                    value = row.getP_UTENTE();
                } else if ( "P_STRINGA".equals(name) ) {
                    value = row.getP_STRINGA();
                } else if ( "P_MODULO".equals(name) ) {
                    value = row.getP_MODULO();
                } else if ( "P_STYLESHEET".equals(name) ) {
                    value = row.getP_STYLESHEET();
                }
                return value;
            }
//End STILE Record: getRowFieldByName

void InsertAction() { //STILE Record: method insert @2-11643485

//STILE Record: method insert head @2-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End STILE Record: method insert head

//STILE Record: components insert actions @2-68525650
            if (! model.hasErrors()) {
            }
//End STILE Record: components insert actions

} //STILE Record: method insert tail @2-FCB6E20C

void UpdateAction() { //STILE Record: method update @2-5771D0AA

//STILE Record: method update head @2-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End STILE Record: method update head

//STILE Record: method update body @2-88248CC7
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            STILEDataObject ds = new STILEDataObject(page);
            ds.setComponent( model );
            STILERow row = new STILERow();
            ds.setRow(row);
            ds.setExprKey17( ( "Style" ) );
            ds.setUrlSTYLESHEET( page.getHttpGetParams().getParameter("STYLESHEET") );
            ds.setSesModulo( SessionStorage.getInstance(req).getAttribute("Modulo") );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
//End STILE Record: method update body

//STILE Record: ds.update @2-6E956EDC
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
//End STILE Record: ds.update

} //STILE Record: method update tail @2-FCB6E20C

void DeleteAction() { //STILE Record: method delete @2-11FC2E1E

//STILE Record: method delete head @2-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End STILE Record: method delete head

//STILE Record: components delete actions @2-68525650
            if (! model.hasErrors()) {
            }
//End STILE Record: components delete actions

} //STILE Record: method delete tail @2-FCB6E20C

//STILE Record: method validate @2-E27C03F3
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.TextBox P_UTENTE = (com.codecharge.components.TextBox) model.getChild( "P_UTENTE" );
            if (! P_UTENTE.validate()) { isControlError = true; }

            com.codecharge.components.TextBox P_STRINGA = (com.codecharge.components.TextBox) model.getChild( "P_STRINGA" );
            if (! P_STRINGA.validate()) { isControlError = true; }

            com.codecharge.components.TextBox P_MODULO = (com.codecharge.components.TextBox) model.getChild( "P_MODULO" );
            if (! P_MODULO.validate()) { isControlError = true; }

            com.codecharge.components.TextBox P_STYLESHEET = (com.codecharge.components.TextBox) model.getChild( "P_STYLESHEET" );
            if (! P_STYLESHEET.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End STILE Record: method validate

//STILE Record Tail @2-FCB6E20C
    }
//End STILE Record Tail

//AmvStileAggiorna Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvStileAggiorna Page: method validate

//AmvStileAggiornaAction Tail @1-FCB6E20C
}
//End AmvStileAggiornaAction Tail

