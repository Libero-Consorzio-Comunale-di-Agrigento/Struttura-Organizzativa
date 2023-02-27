//AmvRichiestaAbilitazioneAction imports @1-43C4CEF4
package common.AmvRichiestaAbilitazione;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvRichiestaAbilitazioneAction imports

//AmvRichiestaAbilitazioneAction class @1-8D7A9A49
public class AmvRichiestaAbilitazioneAction extends Action {

//End AmvRichiestaAbilitazioneAction class

//AmvRichiestaAbilitazioneAction: method perform @1-2F6D7A9B
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvRichiestaAbilitazioneModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvRichiestaAbilitazioneModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvRichiestaAbilitazioneAction: method perform

//AmvRichiestaAbilitazioneAction: call children actions @1-CEEAB331
        if (result == null) {
            AD4_RICHIESTAClass AD4_RICHIESTA = new AD4_RICHIESTAClass();
            if ( ( redirect = AD4_RICHIESTA.perform( page.getRecord("AD4_RICHIESTA")) ) != null ) result = redirect;
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvRichiestaAbilitazioneAction: call children actions

//AD4_RICHIESTA Record @2-B638567C
    final class AD4_RICHIESTAClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AD4_RICHIESTA Record

//AD4_RICHIESTA Record: method perform @2-339F6126
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AmvRichiestaAbilitazione" + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowInsert() ) model.getChild( "Insert" ).setVisible( false );
//End AD4_RICHIESTA Record: method perform

//AD4_RICHIESTA Record: children actions @2-6CE72D90
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("AD4_RICHIESTA".equals(formName)) {
                setProperties(model, Action.POST);
                    if (validate()) {
                        Insert5Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
            }
            setProperties(model, Action.GET, true );
            read();
//End AD4_RICHIESTA Record: children actions

//AD4_RICHIESTA Record: method perform tail @2-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AD4_RICHIESTA Record: method perform tail

//Insert Button @5-C1276C46
        void Insert5Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Insert");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AmvRichiestaAbilitazione" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            InsertAction();
        }
//End Insert Button

void read() { //AD4_RICHIESTA Record: method read @2-7F8AAE5A

//AD4_RICHIESTA Record: method read head @2-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AD4_RICHIESTA Record: method read head

//AD4_RICHIESTA Record: init DataSource @2-6E32B1C7
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AD4_RICHIESTADataObject ds = new AD4_RICHIESTADataObject(page);
            ds.setComponent( model );
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End AD4_RICHIESTA Record: init DataSource

//AD4_RICHIESTA Record: check errors @2-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End AD4_RICHIESTA Record: check errors

} //AD4_RICHIESTA Record: method read tail @2-FCB6E20C

//AD4_RICHIESTA Record: bind @2-97A9A84C
            public void bind(com.codecharge.components.Component model, AD4_RICHIESTARow row ) {
                if ( model == null || row == null ) return;
                if ( this.valid ) {
                    model.getControl("TextBox1").setValue(row.getTextBox1());
                }
            }
//End AD4_RICHIESTA Record: bind

//AD4_RICHIESTA Record: getRowFieldByName @2-7F448D01
            public Object getRowFieldByName( String name, AD4_RICHIESTARow row ) {
                Object value = null;
                if ( "TextBox1".equals(name) ) {
                    value = row.getTextBox1();
                }
                return value;
            }
//End AD4_RICHIESTA Record: getRowFieldByName

void InsertAction() { //AD4_RICHIESTA Record: method insert @2-11643485

//AD4_RICHIESTA Record: method insert head @2-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End AD4_RICHIESTA Record: method insert head

//AD4_RICHIESTA Record: method insert body @2-2887543C
            if (!model.isAllowInsert()) return;
            boolean isErrors = false;
            AD4_RICHIESTADataObject ds = new AD4_RICHIESTADataObject(page);
            ds.setComponent( model );
            AD4_RICHIESTARow row = new AD4_RICHIESTARow();
            ds.setRow(row);
            ds.setPostTextBox1( page.getHttpPostParams().getParameter("TextBox1") );
            ds.setUrlMOD( page.getHttpGetParams().getParameter("MOD") );
            ds.setSesIstanza( SessionStorage.getInstance(req).getAttribute("Istanza") );
//End AD4_RICHIESTA Record: method insert body

//AD4_RICHIESTA Record: ds.insert @2-9320B03B
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
//End AD4_RICHIESTA Record: ds.insert

} //AD4_RICHIESTA Record: method insert tail @2-FCB6E20C

void UpdateAction() { //AD4_RICHIESTA Record: method update @2-5771D0AA

//AD4_RICHIESTA Record: method update head @2-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End AD4_RICHIESTA Record: method update head

//AD4_RICHIESTA Record: method update body @2-5ABF1271
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            AD4_RICHIESTADataObject ds = new AD4_RICHIESTADataObject(page);
            ds.setComponent( model );
            AD4_RICHIESTARow row = new AD4_RICHIESTARow();
            ds.setRow(row);
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setUrlMOD( page.getHttpGetParams().getParameter("MOD") );
            ds.setSesIstanza( SessionStorage.getInstance(req).getAttribute("Istanza") );
//End AD4_RICHIESTA Record: method update body

//AD4_RICHIESTA Record: ds.update @2-6E956EDC
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
//End AD4_RICHIESTA Record: ds.update

} //AD4_RICHIESTA Record: method update tail @2-FCB6E20C

void DeleteAction() { //AD4_RICHIESTA Record: method delete @2-11FC2E1E

//AD4_RICHIESTA Record: method delete head @2-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End AD4_RICHIESTA Record: method delete head

//AD4_RICHIESTA Record: components delete actions @2-68525650
            if (! model.hasErrors()) {
            }
//End AD4_RICHIESTA Record: components delete actions

} //AD4_RICHIESTA Record: method delete tail @2-FCB6E20C

//AD4_RICHIESTA Record: method validate @2-3932B96D
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.TextBox TextBox1 = (com.codecharge.components.TextBox) model.getChild( "TextBox1" );
            if (! TextBox1.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AD4_RICHIESTA Record: method validate

//AD4_RICHIESTA Record Tail @2-FCB6E20C
    }
//End AD4_RICHIESTA Record Tail

//AmvRichiestaAbilitazione Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvRichiestaAbilitazione Page: method validate

//AmvRichiestaAbilitazioneAction Tail @1-FCB6E20C
}
//End AmvRichiestaAbilitazioneAction Tail

