//AmvFileSelectAction imports @1-F34D529C
package common.AmvFileSelect;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvFileSelectAction imports

//AmvFileSelectAction class @1-EAA8B4D9
public class AmvFileSelectAction extends Action {

//End AmvFileSelectAction class

//AmvFileSelectAction: method perform @1-7E6EC13C
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvFileSelectModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvFileSelectModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvFileSelectAction: method perform

//AmvFileSelectAction: call children actions @1-C43DF56A
        if ( page.getChild( "AmvStyle" ).isVisible() ) {
            page.getRequest().setAttribute("AmvStyleParent",page);
            common.AmvStyle.AmvStyleAction AmvStyle = new common.AmvStyle.AmvStyleAction();
            result = result != null ? result : AmvStyle.perform( req, resp,  context );
            page.setCookies();
        }
        if (result == null) {
            FILE_LISTClass FILE_LIST = new FILE_LISTClass();
            if ( ( redirect = FILE_LIST.perform( page.getRecord("FILE_LIST")) ) != null ) result = redirect;
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvFileSelectAction: call children actions

//FILE_LIST Record @2-D23CF730
    final class FILE_LISTClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End FILE_LIST Record

//FILE_LIST Record: method perform @2-D543FE37
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( page.getActionPageName() + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowUpdate() ) model.getChild( "Button_Update" ).setVisible( false );
//End FILE_LIST Record: method perform

//FILE_LIST Record: children actions @2-97DAD282
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("FILE_LIST".equals(formName)) {
                setProperties(model, Action.POST);
                if (mode != -1) { // Update mode
                    model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                    if (page.getParameter("Button_Update") != null) {
                        if (validate()) {
                            Button_UpdateAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Annulla") != null) {
                        if (validate()) {
                            AnnullaAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                } else { // Insert mode
                    model.setMode(com.codecharge.components.Record.INSERT_MODE);
                    if (page.getParameter("Annulla") != null) {
                        if (validate()) {
                            AnnullaAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                }
            }
            setProperties(model, Action.GET, true );
            read();
//End FILE_LIST Record: children actions

//FILE_LIST Record: method perform tail @2-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End FILE_LIST Record: method perform tail

//Button_Update Button @6-5A4B6BAD
        void Button_UpdateAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Button_Update");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( page.getActionPageName() + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Button_Update Button

//Annulla Button @11-92719C6E
        void AnnullaAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Annulla");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( page.getActionPageName() + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
        }
//End Annulla Button

void read() { //FILE_LIST Record: method read @2-7F8AAE5A

//FILE_LIST Record: method read head @2-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End FILE_LIST Record: method read head

//FILE_LIST Record: init DataSource @2-4C16E07D
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            FILE_LISTDataObject ds = new FILE_LISTDataObject(page);
            ds.setComponent( model );
            ds.setUrlTITLE( page.getHttpGetParams().getParameter("TITLE") );
            ds.setUrlVALUE( page.getHttpGetParams().getParameter("VALUE") );
            ds.setUrlMVWF( page.getHttpGetParams().getParameter("MVWF") );
            ds.setSesMVOPT( SessionStorage.getInstance(req).getAttribute("MVOPT") );
            ds.setPostMOSTRA( page.getHttpPostParams().getParameter("MOSTRA") );
            ds.setUrlMVTYPE( page.getHttpGetParams().getParameter("MVTYPE") );
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End FILE_LIST Record: init DataSource

//FILE_LIST Record: check errors @2-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End FILE_LIST Record: check errors

} //FILE_LIST Record: method read tail @2-FCB6E20C

//FILE_LIST Record: bind @2-5447E4D3
            public void bind(com.codecharge.components.Component model, FILE_LISTRow row ) {
                if ( model == null || row == null ) return;
                model.getControl("TITOLO").setValue(row.getTITOLO());
                model.getControl("MVWF").setValue(row.getMVWF());
                model.getControl("INPUT_FILE").setValue(row.getINPUT_FILE());
                if ( this.valid ) {
                    model.getControl("MOSTRA").setValue(row.getMOSTRA());
                }
            }
//End FILE_LIST Record: bind

//FILE_LIST Record: getRowFieldByName @2-7870AF79
            public Object getRowFieldByName( String name, FILE_LISTRow row ) {
                Object value = null;
                if ( "TITOLO".equals(name) ) {
                    value = row.getTITOLO();
                } else if ( "MVWF".equals(name) ) {
                    value = row.getMVWF();
                } else if ( "FILE_LIST_BOX".equals(name) ) {
                    value = row.getFILE_LIST_BOX();
                } else if ( "INPUT_FILE".equals(name) ) {
                    value = row.getINPUT_FILE();
                } else if ( "MOSTRA".equals(name) ) {
                    value = row.getMOSTRA();
                }
                return value;
            }
//End FILE_LIST Record: getRowFieldByName

void InsertAction() { //FILE_LIST Record: method insert @2-11643485

//FILE_LIST Record: method insert head @2-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End FILE_LIST Record: method insert head

//FILE_LIST Record: components insert actions @2-68525650
            if (! model.hasErrors()) {
            }
//End FILE_LIST Record: components insert actions

} //FILE_LIST Record: method insert tail @2-FCB6E20C

void UpdateAction() { //FILE_LIST Record: method update @2-5771D0AA

//FILE_LIST Record: method update head @2-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End FILE_LIST Record: method update head

//FILE_LIST Record: method update body @2-F24FA0B8
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            FILE_LISTDataObject ds = new FILE_LISTDataObject(page);
            ds.setComponent( model );
            FILE_LISTRow row = new FILE_LISTRow();
            ds.setRow(row);
//End FILE_LIST Record: method update body

//FILE_LIST Record: ds.update @2-6E956EDC
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
//End FILE_LIST Record: ds.update

} //FILE_LIST Record: method update tail @2-FCB6E20C

void DeleteAction() { //FILE_LIST Record: method delete @2-11FC2E1E

//FILE_LIST Record: method delete head @2-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End FILE_LIST Record: method delete head

//FILE_LIST Record: components delete actions @2-68525650
            if (! model.hasErrors()) {
            }
//End FILE_LIST Record: components delete actions

} //FILE_LIST Record: method delete tail @2-FCB6E20C

//FILE_LIST Record: method validate @2-3B5B1FEC
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.Hidden MOSTRA = (com.codecharge.components.Hidden) model.getChild( "MOSTRA" );
            if (! MOSTRA.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End FILE_LIST Record: method validate

//FILE_LIST Record Tail @2-FCB6E20C
    }
//End FILE_LIST Record Tail

//AmvFileSelect Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvFileSelect Page: method validate

//AmvFileSelectAction Tail @1-FCB6E20C
}
//End AmvFileSelectAction Tail



