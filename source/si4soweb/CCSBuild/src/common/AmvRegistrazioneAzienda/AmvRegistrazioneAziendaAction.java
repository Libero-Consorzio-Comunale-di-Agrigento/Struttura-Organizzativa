//AmvRegistrazioneAziendaAction imports @1-430F048D
package common.AmvRegistrazioneAzienda;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvRegistrazioneAziendaAction imports

//AmvRegistrazioneAziendaAction class @1-62B913C3
public class AmvRegistrazioneAziendaAction extends Action {

//End AmvRegistrazioneAziendaAction class

//AmvRegistrazioneAziendaAction: method perform @1-7A79D612
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvRegistrazioneAziendaModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvRegistrazioneAziendaModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvRegistrazioneAziendaAction: method perform

//AmvRegistrazioneAziendaAction: call children actions @1-4C2E3578
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
            AD4_UTENTEClass AD4_UTENTE = new AD4_UTENTEClass();
            if ( ( redirect = AD4_UTENTE.perform( page.getRecord("AD4_UTENTE")) ) != null ) result = redirect;
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
//End AmvRegistrazioneAziendaAction: call children actions

//AD4_UTENTE Record @14-20741C0E
    final class AD4_UTENTEClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AD4_UTENTE Record

//AD4_UTENTE Record: method perform @14-513C7029
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AmvRedirect" + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowUpdate() ) model.getChild( "Update" ).setVisible( false );
//End AD4_UTENTE Record: method perform

//AD4_UTENTE Record: children actions @14-B0DDB69F
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("AD4_UTENTE".equals(formName)) {
                setProperties(model, Action.POST);
                if (mode != -1) { // Update mode
                    model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                    if (page.getParameter("Indietro") != null) {
                        IndietroAction();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                    if (page.getParameter("Update") != null) {
                        if (validate()) {
                            Update23Action();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                } else { // Insert mode
                    model.setMode(com.codecharge.components.Record.INSERT_MODE);
                    if (page.getParameter("Indietro") != null) {
                        IndietroAction();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                }
            }
            setProperties(model, Action.GET, true );
            read();
//End AD4_UTENTE Record: children actions

//AD4_UTENTE Record: method perform tail @14-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AD4_UTENTE Record: method perform tail

//Indietro Button @52-D1CCAC19
        void IndietroAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Indietro");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AmvServiziRichiesta" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
        }
//End Indietro Button

//Update Button @23-43392A10
        void Update23Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Update");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AmvRedirect" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Update Button

void read() { //AD4_UTENTE Record: method read @14-7F8AAE5A

//AD4_UTENTE Record: method read head @14-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AD4_UTENTE Record: method read head

//AD4_UTENTE Record: init DataSource @14-AF92553B
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AD4_UTENTEDataObject ds = new AD4_UTENTEDataObject(page);
            ds.setComponent( model );
            ds.setSesModulo( SessionStorage.getInstance(req).getAttribute("Modulo") );
            ds.setSesMVUTE( SessionStorage.getInstance(req).getAttribute("MVUTE") );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setUrlMODULO( page.getHttpGetParams().getParameter("MODULO") );
            ds.setUrlISTANZA( page.getHttpGetParams().getParameter("ISTANZA") );
            ds.setSesIstanza( SessionStorage.getInstance(req).getAttribute("Istanza") );
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End AD4_UTENTE Record: init DataSource

//AD4_UTENTE Record: check errors @14-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End AD4_UTENTE Record: check errors

} //AD4_UTENTE Record: method read tail @14-FCB6E20C

//AD4_UTENTE Record: bind @14-A90255A2
            public void bind(com.codecharge.components.Component model, AD4_UTENTERow row ) {
                if ( model == null || row == null ) return;
                if ( this.valid ) {
                    model.getControl("NOMINATIVO").setValue(row.getNOMINATIVO());
                    model.getControl("SERVIZIO").setValue(row.getSERVIZIO());
                    model.getControl("MVPAGES").setValue(row.getMVPAGES());
                }
            }
//End AD4_UTENTE Record: bind

//AD4_UTENTE Record: getRowFieldByName @14-91B22485
            public Object getRowFieldByName( String name, AD4_UTENTERow row ) {
                Object value = null;
                if ( "NOMINATIVO".equals(name) ) {
                    value = row.getNOMINATIVO();
                } else if ( "SERVIZIO".equals(name) ) {
                    value = row.getSERVIZIO();
                } else if ( "RS_AZIENDA".equals(name) ) {
                    value = row.getRS_AZIENDA();
                } else if ( "CF_AZIENDA".equals(name) ) {
                    value = row.getCF_AZIENDA();
                } else if ( "MVPAGES".equals(name) ) {
                    value = row.getMVPAGES();
                }
                return value;
            }
//End AD4_UTENTE Record: getRowFieldByName

void InsertAction() { //AD4_UTENTE Record: method insert @14-11643485

//AD4_UTENTE Record: components insert actions @14-68525650
            if (! model.hasErrors()) {
            }
//End AD4_UTENTE Record: components insert actions

} //AD4_UTENTE Record: method insert tail @14-FCB6E20C

void UpdateAction() { //AD4_UTENTE Record: method update @14-5771D0AA

//AD4_UTENTE Record: method update head @14-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End AD4_UTENTE Record: method update head

//AD4_UTENTE Record: method update body @14-3A8F99A2
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            AD4_UTENTEDataObject ds = new AD4_UTENTEDataObject(page);
            ds.setComponent( model );
            AD4_UTENTERow row = new AD4_UTENTERow();
            ds.setRow(row);
            try {
                ds.setSesMVRIC( SessionStorage.getInstance(req).getAttribute("MVRIC"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVRIC'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVRIC'" );
            }
            ds.setExprKey54( ( "RS_AZIENDA" ) );
            ds.setPostRS_AZIENDA( page.getHttpPostParams().getParameter("RS_AZIENDA") );
            ds.setExprKey56( ( "CF_AZIENDA" ) );
            ds.setPostCF_AZIENDA( page.getHttpPostParams().getParameter("CF_AZIENDA") );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
//End AD4_UTENTE Record: method update body

//AD4_UTENTE Record: ds.update @14-6E956EDC
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
//End AD4_UTENTE Record: ds.update

} //AD4_UTENTE Record: method update tail @14-FCB6E20C

void DeleteAction() { //AD4_UTENTE Record: method delete @14-11FC2E1E

//AD4_UTENTE Record: components delete actions @14-68525650
            if (! model.hasErrors()) {
            }
//End AD4_UTENTE Record: components delete actions

} //AD4_UTENTE Record: method delete tail @14-FCB6E20C

//AD4_UTENTE Record: method validate @14-5E019518
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.TextBox NOMINATIVO = (com.codecharge.components.TextBox) model.getChild( "NOMINATIVO" );
            if (! NOMINATIVO.validate()) { isControlError = true; }

            com.codecharge.components.TextBox SERVIZIO = (com.codecharge.components.TextBox) model.getChild( "SERVIZIO" );
            if (! SERVIZIO.validate()) { isControlError = true; }

            com.codecharge.components.TextBox RS_AZIENDA = (com.codecharge.components.TextBox) model.getChild( "RS_AZIENDA" );
            if (! RS_AZIENDA.validate()) { isControlError = true; }

            com.codecharge.components.TextBox CF_AZIENDA = (com.codecharge.components.TextBox) model.getChild( "CF_AZIENDA" );
            if (! CF_AZIENDA.validate()) { isControlError = true; }

            com.codecharge.components.Hidden MVPAGES = (com.codecharge.components.Hidden) model.getChild( "MVPAGES" );
            if (! MVPAGES.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AD4_UTENTE Record: method validate

//AD4_UTENTE Record Tail @14-FCB6E20C
    }
//End AD4_UTENTE Record Tail

//AmvRegistrazioneAzienda Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvRegistrazioneAzienda Page: method validate

//AmvRegistrazioneAziendaAction Tail @1-FCB6E20C
}
//End AmvRegistrazioneAziendaAction Tail

