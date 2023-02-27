//AdmRichiestaNotificaAction imports @1-B477029B
package amvadm.AdmRichiestaNotifica;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmRichiestaNotificaAction imports

//AdmRichiestaNotificaAction class @1-B67A9AA7
public class AdmRichiestaNotificaAction extends Action {

//End AdmRichiestaNotificaAction class

//AdmRichiestaNotificaAction: method perform @1-D953F992
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AdmRichiestaNotificaModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AdmRichiestaNotificaModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AdmRichiestaNotificaAction: method perform

//AdmRichiestaNotificaAction: call children actions @1-2B7B9AD6
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
        if ( page.getChild( "Guida" ).isVisible() ) {
            page.getRequest().setAttribute("GuidaParent",page);
            common.Guida.GuidaAction Guida = new common.Guida.GuidaAction();
            result = result != null ? result : Guida.perform( req, resp,  context );
            page.setCookies();
        }
        if (result == null) {
            AD4_RICHIESTE_ABILITAZIONEClass AD4_RICHIESTE_ABILITAZIONE = new AD4_RICHIESTE_ABILITAZIONEClass();
            if ( ( redirect = AD4_RICHIESTE_ABILITAZIONE.perform( page.getRecord("AD4_RICHIESTE_ABILITAZIONE")) ) != null ) result = redirect;
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
//End AdmRichiestaNotificaAction: call children actions

//AD4_RICHIESTE_ABILITAZIONE Record @6-EF052465
    final class AD4_RICHIESTE_ABILITAZIONEClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AD4_RICHIESTE_ABILITAZIONE Record

//AD4_RICHIESTE_ABILITAZIONE Record: method perform @6-905CB5FE
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AdmRichiesta" + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowUpdate() ) model.getChild( "Button_Update" ).setVisible( false );
//End AD4_RICHIESTE_ABILITAZIONE Record: method perform

//AD4_RICHIESTE_ABILITAZIONE Record: children actions @6-7AF95913
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("AD4_RICHIESTE_ABILITAZIONE".equals(formName)) {
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
            readTIPO_NOTIFICA(model.getListBox("TIPO_NOTIFICA"));
//End AD4_RICHIESTE_ABILITAZIONE Record: children actions

//AD4_RICHIESTE_ABILITAZIONE Record: method perform tail @6-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AD4_RICHIESTE_ABILITAZIONE Record: method perform tail

//Button_Update Button @11-C5C94ED1
        void Button_UpdateAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Button_Update");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmRichiesta" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Button_Update Button

//Button_Cancel Button @12-5B0C3743
        void Button_CancelAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Button_Cancel");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmRichiesta" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
        }
//End Button_Cancel Button

//ListBoxAction @8-C40B542A
        protected void readTIPO_NOTIFICA(com.codecharge.components.ListBox model) {
            DataObjectEvent e = new DataObjectEvent();
            e.setSql( "MAIL;Mail;POSTA;Posta Ordinaria" );
            model.fireBeforeBuildSelectEvent(e);
            model.fireBeforeExecuteSelectEvent(e);
            model.setListOfValues( e.getSql() );
            model.fireAfterExecuteSelectEvent(e);
        }
//End ListBoxAction

void read() { //AD4_RICHIESTE_ABILITAZIONE Record: method read @6-7F8AAE5A

//AD4_RICHIESTE_ABILITAZIONE Record: method read head @6-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AD4_RICHIESTE_ABILITAZIONE Record: method read head

//AD4_RICHIESTE_ABILITAZIONE Record: init DataSource @6-51977688
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AD4_RICHIESTE_ABILITAZIONEDataObject ds = new AD4_RICHIESTE_ABILITAZIONEDataObject(page);
            ds.setComponent( model );
            ds.setUrlID( page.getHttpGetParams().getParameter("ID") );
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End AD4_RICHIESTE_ABILITAZIONE Record: init DataSource

//AD4_RICHIESTE_ABILITAZIONE Record: check errors @6-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End AD4_RICHIESTE_ABILITAZIONE Record: check errors

} //AD4_RICHIESTE_ABILITAZIONE Record: method read tail @6-FCB6E20C

//AD4_RICHIESTE_ABILITAZIONE Record: bind @6-072D322A
            public void bind(com.codecharge.components.Component model, AD4_RICHIESTE_ABILITAZIONERow row ) {
                if ( model == null || row == null ) return;
                if ( this.valid ) {
                    model.getControl("SERVIZIO").setValue(row.getSERVIZIO());
                    model.getControl("TIPO_NOTIFICA").setValue(row.getTIPO_NOTIFICA());
                    model.getControl("INDIRIZZO_NOTIFICA").setValue(row.getINDIRIZZO_NOTIFICA());
                }
            }
//End AD4_RICHIESTE_ABILITAZIONE Record: bind

//AD4_RICHIESTE_ABILITAZIONE Record: getRowFieldByName @6-CEC4D83D
            public Object getRowFieldByName( String name, AD4_RICHIESTE_ABILITAZIONERow row ) {
                Object value = null;
                if ( "SERVIZIO".equals(name) ) {
                    value = row.getSERVIZIO();
                } else if ( "TIPO_NOTIFICA".equals(name) ) {
                    value = row.getTIPO_NOTIFICA();
                } else if ( "INDIRIZZO_NOTIFICA".equals(name) ) {
                    value = row.getINDIRIZZO_NOTIFICA();
                }
                return value;
            }
//End AD4_RICHIESTE_ABILITAZIONE Record: getRowFieldByName

void InsertAction() { //AD4_RICHIESTE_ABILITAZIONE Record: method insert @6-11643485

//AD4_RICHIESTE_ABILITAZIONE Record: components insert actions @6-68525650
            if (! model.hasErrors()) {
            }
//End AD4_RICHIESTE_ABILITAZIONE Record: components insert actions

} //AD4_RICHIESTE_ABILITAZIONE Record: method insert tail @6-FCB6E20C

void UpdateAction() { //AD4_RICHIESTE_ABILITAZIONE Record: method update @6-5771D0AA

//AD4_RICHIESTE_ABILITAZIONE Record: method update head @6-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End AD4_RICHIESTE_ABILITAZIONE Record: method update head

//AD4_RICHIESTE_ABILITAZIONE Record: method update body @6-F1DF803B
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            AD4_RICHIESTE_ABILITAZIONEDataObject ds = new AD4_RICHIESTE_ABILITAZIONEDataObject(page);
            ds.setComponent( model );
            AD4_RICHIESTE_ABILITAZIONERow row = new AD4_RICHIESTE_ABILITAZIONERow();
            ds.setRow(row);
            ds.setRow(row);
            ds.setPostTIPO_NOTIFICA( page.getHttpPostParams().getParameter("TIPO_NOTIFICA"), null );
            ds.setPostINDIRIZZO_NOTIFICA( page.getHttpPostParams().getParameter("INDIRIZZO_NOTIFICA"), null );
            ds.setUrlID( page.getHttpGetParams().getParameter("ID") );
//End AD4_RICHIESTE_ABILITAZIONE Record: method update body

//AD4_RICHIESTE_ABILITAZIONE Record: ds.update @6-6E956EDC
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
//End AD4_RICHIESTE_ABILITAZIONE Record: ds.update

} //AD4_RICHIESTE_ABILITAZIONE Record: method update tail @6-FCB6E20C

void DeleteAction() { //AD4_RICHIESTE_ABILITAZIONE Record: method delete @6-11FC2E1E

//AD4_RICHIESTE_ABILITAZIONE Record: components delete actions @6-68525650
            if (! model.hasErrors()) {
            }
//End AD4_RICHIESTE_ABILITAZIONE Record: components delete actions

} //AD4_RICHIESTE_ABILITAZIONE Record: method delete tail @6-FCB6E20C

//AD4_RICHIESTE_ABILITAZIONE Record: method validate @6-3BE9DF43
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.TextBox SERVIZIO = (com.codecharge.components.TextBox) model.getChild( "SERVIZIO" );
            if (! SERVIZIO.validate()) { isControlError = true; }

            com.codecharge.components.ListBox TIPO_NOTIFICA = (com.codecharge.components.ListBox) model.getChild( "TIPO_NOTIFICA" );
            if (! TIPO_NOTIFICA.validate()) { isControlError = true; }

            com.codecharge.components.TextBox INDIRIZZO_NOTIFICA = (com.codecharge.components.TextBox) model.getChild( "INDIRIZZO_NOTIFICA" );
            if (! INDIRIZZO_NOTIFICA.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AD4_RICHIESTE_ABILITAZIONE Record: method validate

//AD4_RICHIESTE_ABILITAZIONE Record Tail @6-FCB6E20C
    }
//End AD4_RICHIESTE_ABILITAZIONE Record Tail

//AdmRichiestaNotifica Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AdmRichiestaNotifica Page: method validate

//AdmRichiestaNotificaAction Tail @1-FCB6E20C
}
//End AdmRichiestaNotificaAction Tail


