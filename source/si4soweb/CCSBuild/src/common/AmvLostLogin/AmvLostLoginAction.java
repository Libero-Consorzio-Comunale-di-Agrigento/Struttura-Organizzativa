//AmvLostLoginAction imports @1-9F26E3AE
package common.AmvLostLogin;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvLostLoginAction imports

//AmvLostLoginAction class @1-8DB6CC9E
public class AmvLostLoginAction extends Action {

//End AmvLostLoginAction class

//AmvLostLoginAction: method perform @1-677BBFE6
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvLostLoginModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvLostLoginModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvLostLoginAction: method perform

//AmvLostLoginAction: call children actions @1-A4E47BEE
        if ( page.getChild( "Header" ).isVisible() ) {
            page.getRequest().setAttribute("HeaderParent",page);
            common.Header.HeaderAction Header = new common.Header.HeaderAction();
            result = result != null ? result : Header.perform( req, resp,  context );
            page.setCookies();
        }
        if (result == null) {
            LOSTLOGINClass LOSTLOGIN = new LOSTLOGINClass();
            if ( ( redirect = LOSTLOGIN.perform( page.getRecord("LOSTLOGIN")) ) != null ) result = redirect;
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
//End AmvLostLoginAction: call children actions

//LOSTLOGIN Record @6-3250790D
    final class LOSTLOGINClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End LOSTLOGIN Record

//LOSTLOGIN Record: method perform @6-F3F59A07
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AmvInvioAccount" + Names.ACTION_SUFFIX );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowInsert() ) model.getChild( "InviaRichiesta" ).setVisible( false );
//End LOSTLOGIN Record: method perform

//LOSTLOGIN Record: children actions @6-6F50956C
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("LOSTLOGIN".equals(formName)) {
                setProperties(model, Action.POST);
                    if (validate()) {
                        InviaRichiestaAction();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
            }
            setProperties(model, Action.GET, true );
            read();
//End LOSTLOGIN Record: children actions

//LOSTLOGIN Record: method perform tail @6-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End LOSTLOGIN Record: method perform tail

//InviaRichiesta Button @9-3C3AFFC0
        void InviaRichiestaAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("InviaRichiesta");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AmvInvioAccount" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            InsertAction();
        }
//End InviaRichiesta Button

void read() { //LOSTLOGIN Record: method read @6-7F8AAE5A

//LOSTLOGIN Record: method read head @6-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End LOSTLOGIN Record: method read head

//LOSTLOGIN Record: init DataSource @6-2ED6FAC9
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            LOSTLOGINDataObject ds = new LOSTLOGINDataObject(page);
            ds.setComponent( model );
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End LOSTLOGIN Record: init DataSource

//LOSTLOGIN Record: check errors @6-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End LOSTLOGIN Record: check errors

} //LOSTLOGIN Record: method read tail @6-FCB6E20C

//LOSTLOGIN Record: bind @6-4B118993
            public void bind(com.codecharge.components.Component model, LOSTLOGINRow row ) {
                if ( model == null || row == null ) return;
                if ( this.valid ) {
                }
            }
//End LOSTLOGIN Record: bind

//LOSTLOGIN Record: getRowFieldByName @6-B1B65489
            public Object getRowFieldByName( String name, LOSTLOGINRow row ) {
                Object value = null;
                if ( "COGNOME".equals(name) ) {
                    value = row.getCOGNOME();
                } else if ( "NOME".equals(name) ) {
                    value = row.getNOME();
                } else if ( "EMAIL".equals(name) ) {
                    value = row.getEMAIL();
                }
                return value;
            }
//End LOSTLOGIN Record: getRowFieldByName

void InsertAction() { //LOSTLOGIN Record: method insert @6-11643485

//LOSTLOGIN Record: method insert head @6-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End LOSTLOGIN Record: method insert head

//LOSTLOGIN Record: method insert body @6-EE5E4594
            if (!model.isAllowInsert()) return;
            boolean isErrors = false;
            LOSTLOGINDataObject ds = new LOSTLOGINDataObject(page);
            ds.setComponent( model );
            LOSTLOGINRow row = new LOSTLOGINRow();
            ds.setRow(row);
            ds.setPostNOME( page.getHttpPostParams().getParameter("NOME") );
            ds.setPostCOGNOME( page.getHttpPostParams().getParameter("COGNOME") );
            ds.setPostEMAIL( page.getHttpPostParams().getParameter("EMAIL") );
            ds.setSesModulo( SessionStorage.getInstance(req).getAttribute("Modulo") );
            ds.setSesIstanza( SessionStorage.getInstance(req).getAttribute("Istanza") );
            ds.setSesProgetto( SessionStorage.getInstance(req).getAttribute("Progetto") );
            ds.setExprKey23( ( page.getRequest().getRequestURL() ) );
//End LOSTLOGIN Record: method insert body

//LOSTLOGIN Record: ds.insert @6-9320B03B
            ds.insert();
            if ( ! ds.hasErrors() ) {
            }
            model.fireAfterInsertEvent();
            action = true;
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
                this.valid = false;
            }
//End LOSTLOGIN Record: ds.insert

} //LOSTLOGIN Record: method insert tail @6-FCB6E20C

void UpdateAction() { //LOSTLOGIN Record: method update @6-5771D0AA

//LOSTLOGIN Record: method update head @6-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End LOSTLOGIN Record: method update head

//LOSTLOGIN Record: components update actions @6-68525650
            if (! model.hasErrors()) {
            }
//End LOSTLOGIN Record: components update actions

} //LOSTLOGIN Record: method update tail @6-FCB6E20C

void DeleteAction() { //LOSTLOGIN Record: method delete @6-11FC2E1E

//LOSTLOGIN Record: method delete head @6-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End LOSTLOGIN Record: method delete head

//LOSTLOGIN Record: components delete actions @6-68525650
            if (! model.hasErrors()) {
            }
//End LOSTLOGIN Record: components delete actions

} //LOSTLOGIN Record: method delete tail @6-FCB6E20C

//LOSTLOGIN Record: method validate @6-C3EFD101
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.TextBox COGNOME = (com.codecharge.components.TextBox) model.getChild( "COGNOME" );
            if (! COGNOME.validate()) { isControlError = true; }

            com.codecharge.components.TextBox NOME = (com.codecharge.components.TextBox) model.getChild( "NOME" );
            if (! NOME.validate()) { isControlError = true; }

            com.codecharge.components.TextBox EMAIL = (com.codecharge.components.TextBox) model.getChild( "EMAIL" );
            if (! EMAIL.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End LOSTLOGIN Record: method validate

//LOSTLOGIN Record Tail @6-FCB6E20C
    }
//End LOSTLOGIN Record Tail

//AmvLostLogin Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvLostLogin Page: method validate

//AmvLostLoginAction Tail @1-FCB6E20C
}
//End AmvLostLoginAction Tail
