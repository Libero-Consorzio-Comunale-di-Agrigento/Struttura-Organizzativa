//AmvLoginAction imports @1-B0A45CA2
package common.AmvLogin;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvLoginAction imports

//AmvLoginAction class @1-F4B4A8BB
public class AmvLoginAction extends Action {

//End AmvLoginAction class

//AmvLoginAction: method perform @1-E5B3E5D6
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvLoginModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvLoginModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvLoginAction: method perform

//AmvLoginAction: call children actions @1-E8BB47C4
        if (result == null) {
            LOGINClass LOGIN = new LOGINClass();
            if ( ( redirect = LOGIN.perform( page.getRecord("LOGIN")) ) != null ) result = redirect;
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvLoginAction: call children actions

//LOGIN Record @2-582F5D4B
    final class LOGINClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End LOGIN Record

//LOGIN Record: method perform @2-65A7DEFC
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( page.getActionPageName() + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
//End LOGIN Record: method perform

//LOGIN Record: children actions @2-DADCFCF1
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("LOGIN".equals(formName)) {
                setProperties(model, Action.POST);
                    if (validate()) {
                        LoginSearchAction();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
            }
            setProperties(model, Action.GET, true );
            read();
//End LOGIN Record: children actions

//LOGIN Record: method perform tail @2-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End LOGIN Record: method perform tail

//Login Button @11-C8F2A6FC
        void LoginSearchAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Login");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            for ( Iterator params = model.getChildren().iterator(); params.hasNext(); ) {
                excludeParams.add( ((com.codecharge.components.Model) params.next()).getName() );
            }
            page.setRedirectString( page.getActionPageName() + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) + "&" + page.getHttpPostParams().toString( buttonModel.getExcludeParams() ) );
            buttonModel.fireOnClickEvent();
        }
//End Login Button

void read() { //LOGIN Record: method read @2-7F8AAE5A

//LOGIN Record: method read head @2-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End LOGIN Record: method read head

//LOGIN Record: init DataSource @2-60424396
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            LOGINDataObject ds = new LOGINDataObject(page);
            ds.setComponent( model );
            ds.setUrlMVERR( page.getHttpGetParams().getParameter("MVERR") );
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End LOGIN Record: init DataSource

//LOGIN Record: check errors @2-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End LOGIN Record: check errors

} //LOGIN Record: method read tail @2-FCB6E20C

//LOGIN Record: bind @2-2C8B24A8
            public void bind(com.codecharge.components.Component model, LOGINRow row ) {
                if ( model == null || row == null ) return;
                model.getControl("ERRORE").setValue(row.getERRORE());
                model.getControl("LOSTMSG").setValue(row.getLOSTMSG());
                if ( this.valid ) {
                }
            }
//End LOGIN Record: bind

//LOGIN Record: getRowFieldByName @2-661161A5
            public Object getRowFieldByName( String name, LOGINRow row ) {
                Object value = null;
                if ( "ERRORE".equals(name) ) {
                    value = row.getERRORE();
                } else if ( "j_username".equals(name) ) {
                    value = row.getJ_username();
                } else if ( "j_password".equals(name) ) {
                    value = row.getJ_password();
                } else if ( "LOSTMSG".equals(name) ) {
                    value = row.getLOSTMSG();
                }
                return value;
            }
//End LOGIN Record: getRowFieldByName

void InsertAction() { //LOGIN Record: method insert @2-11643485

//LOGIN Record: method insert head @2-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End LOGIN Record: method insert head

//LOGIN Record: components insert actions @2-68525650
            if (! model.hasErrors()) {
            }
//End LOGIN Record: components insert actions

} //LOGIN Record: method insert tail @2-FCB6E20C

void UpdateAction() { //LOGIN Record: method update @2-5771D0AA

//LOGIN Record: method update head @2-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End LOGIN Record: method update head

//LOGIN Record: components update actions @2-68525650
            if (! model.hasErrors()) {
            }
//End LOGIN Record: components update actions

} //LOGIN Record: method update tail @2-FCB6E20C

void DeleteAction() { //LOGIN Record: method delete @2-11FC2E1E

//LOGIN Record: method delete head @2-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End LOGIN Record: method delete head

//LOGIN Record: components delete actions @2-68525650
            if (! model.hasErrors()) {
            }
//End LOGIN Record: components delete actions

} //LOGIN Record: method delete tail @2-FCB6E20C

//LOGIN Record: method validate @2-EA7A537A
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.TextBox j_username = (com.codecharge.components.TextBox) model.getChild( "j_username" );
            if (! j_username.validate()) { isControlError = true; }

            com.codecharge.components.TextBox j_password = (com.codecharge.components.TextBox) model.getChild( "j_password" );
            if (! j_password.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End LOGIN Record: method validate

//LOGIN Record Tail @2-FCB6E20C
    }
//End LOGIN Record Tail

//AmvLogin Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvLogin Page: method validate

//AmvLoginAction Tail @1-FCB6E20C
}
//End AmvLoginAction Tail

