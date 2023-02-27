//AmvNoteAction imports @1-5357025F
package common.AmvNote;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvNoteAction imports

//AmvNoteAction class @1-BD22AD4E
public class AmvNoteAction extends Action {

//End AmvNoteAction class

//AmvNoteAction: method perform @1-11B21D02
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvNoteModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvNoteModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvNoteAction: method perform

//AmvNoteAction: call children actions @1-2BC8E277
        if (result == null) {
            NOTEClass NOTE = new NOTEClass();
            if ( ( redirect = NOTE.perform( page.getRecord("NOTE")) ) != null ) result = redirect;
        }
        if ( page.getChild( "AmvStyle" ).isVisible() ) {
            page.getRequest().setAttribute("AmvStyleParent",page);
            common.AmvStyle.AmvStyleAction AmvStyle = new common.AmvStyle.AmvStyleAction();
            result = result != null ? result : AmvStyle.perform( req, resp,  context );
            page.setCookies();
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvNoteAction: call children actions

//NOTE Record @2-BAABC2A2
    final class NOTEClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End NOTE Record

//NOTE Record: method perform @2-D543FE37
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( page.getActionPageName() + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowUpdate() ) model.getChild( "Button_Update" ).setVisible( false );
//End NOTE Record: method perform

//NOTE Record: children actions @2-279A902A
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("NOTE".equals(formName)) {
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
//End NOTE Record: children actions

//NOTE Record: method perform tail @2-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End NOTE Record: method perform tail

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

void read() { //NOTE Record: method read @2-7F8AAE5A

//NOTE Record: method read head @2-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End NOTE Record: method read head

//NOTE Record: init DataSource @2-8295ECF5
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            NOTEDataObject ds = new NOTEDataObject(page);
            ds.setComponent( model );
            ds.setUrlTITLE( page.getHttpGetParams().getParameter("TITLE") );
            ds.setUrlVALUE( page.getHttpGetParams().getParameter("VALUE") );
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End NOTE Record: init DataSource

//NOTE Record: check errors @2-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End NOTE Record: check errors

} //NOTE Record: method read tail @2-FCB6E20C

//NOTE Record: bind @2-C1CA0D10
            public void bind(com.codecharge.components.Component model, NOTERow row ) {
                if ( model == null || row == null ) return;
                model.getControl("TITOLO").setValue(row.getTITOLO());
                if ( this.valid ) {
                    model.getControl("VALORE").setValue(row.getVALORE());
                }
            }
//End NOTE Record: bind

//NOTE Record: getRowFieldByName @2-AF644B0B
            public Object getRowFieldByName( String name, NOTERow row ) {
                Object value = null;
                if ( "TITOLO".equals(name) ) {
                    value = row.getTITOLO();
                } else if ( "VALORE".equals(name) ) {
                    value = row.getVALORE();
                }
                return value;
            }
//End NOTE Record: getRowFieldByName

void InsertAction() { //NOTE Record: method insert @2-11643485

//NOTE Record: method insert head @2-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End NOTE Record: method insert head

//NOTE Record: components insert actions @2-68525650
            if (! model.hasErrors()) {
            }
//End NOTE Record: components insert actions

} //NOTE Record: method insert tail @2-FCB6E20C

void UpdateAction() { //NOTE Record: method update @2-5771D0AA

//NOTE Record: method update head @2-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End NOTE Record: method update head

//NOTE Record: method update body @2-5B98A7F0
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            NOTEDataObject ds = new NOTEDataObject(page);
            ds.setComponent( model );
            NOTERow row = new NOTERow();
            ds.setRow(row);
//End NOTE Record: method update body

//NOTE Record: ds.update @2-6E956EDC
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
//End NOTE Record: ds.update

} //NOTE Record: method update tail @2-FCB6E20C

void DeleteAction() { //NOTE Record: method delete @2-11FC2E1E

//NOTE Record: method delete head @2-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End NOTE Record: method delete head

//NOTE Record: components delete actions @2-68525650
            if (! model.hasErrors()) {
            }
//End NOTE Record: components delete actions

} //NOTE Record: method delete tail @2-FCB6E20C

//NOTE Record: method validate @2-7EC690E4
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.TextArea VALORE = (com.codecharge.components.TextArea) model.getChild( "VALORE" );
            if (! VALORE.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End NOTE Record: method validate

//NOTE Record Tail @2-FCB6E20C
    }
//End NOTE Record Tail

//AmvNote Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvNote Page: method validate

//AmvNoteAction Tail @1-FCB6E20C
}
//End AmvNoteAction Tail

