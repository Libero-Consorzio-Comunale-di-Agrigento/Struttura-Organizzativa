//AmvUtenteResidenzaAction imports @1-00F3CFAE
package common.AmvUtenteResidenza;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvUtenteResidenzaAction imports

//AmvUtenteResidenzaAction class @1-A74CA4BC
public class AmvUtenteResidenzaAction extends Action {

//End AmvUtenteResidenzaAction class

//AmvUtenteResidenzaAction: method perform @1-D8BBE415
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvUtenteResidenzaModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvUtenteResidenzaModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvUtenteResidenzaAction: method perform

//AmvUtenteResidenzaAction: call children actions @1-4C2E3578
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
//End AmvUtenteResidenzaAction: call children actions

//AD4_UTENTE Record @6-20741C0E
    final class AD4_UTENTEClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AD4_UTENTE Record

//AD4_UTENTE Record: method perform @6-BD484C01
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AmvRedirect" + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowUpdate() ) model.getChild( "Button_Update" ).setVisible( false );
//End AD4_UTENTE Record: method perform

//AD4_UTENTE Record: children actions @6-F44B73FC
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
            readVIA(model.getListBox("VIA"));
            readPROVINCIA(model.getListBox("PROVINCIA"));
            readCOMUNE(model.getListBox("COMUNE"));
//End AD4_UTENTE Record: children actions

//AD4_UTENTE Record: method perform tail @6-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AD4_UTENTE Record: method perform tail

//Button_Update Button @22-4109C344
        void Button_UpdateAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Button_Update");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AmvRedirect" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Button_Update Button

//Button_Cancel Button @23-2570276A
        void Button_CancelAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Button_Cancel");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AmvRedirect" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
        }
//End Button_Cancel Button

//ListBoxAction @14-CFA0E4B0
        protected void readVIA(com.codecharge.components.ListBox model) {
            DataObjectEvent e = new DataObjectEvent();
            e.setSql( "Corso;Corso;Largo;Largo;Piazza;Piazza;Via;Via;Viale;Viale;Vicolo;Vicolo" );
            model.fireBeforeBuildSelectEvent(e);
            model.fireBeforeExecuteSelectEvent(e);
            model.setListOfValues( e.getSql() );
            model.fireAfterExecuteSelectEvent(e);
        }
//End ListBoxAction

//ListBoxAction @17-AD106F0B
        protected void readPROVINCIA(com.codecharge.components.ListBox model) {
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            DataObjectEvent e = new DataObjectEvent();
            e.setSource(model);
            e.setCommand(command);
            e.setConnection(ds);
            command.setOptimizeSQL(false);

            command.setSql( "SELECT *  "
                        + "FROM AD4_PROVINCIE" );
            command.setOrder( "DENOMINAZIONE" );

            model.fireBeforeBuildSelectEvent( e );




            model.fireBeforeExecuteSelectEvent( e );

            Enumeration records = null;
            if ( ! ds.hasErrors() ) {
                model.setOptions( command.getRows(), ds );
            }

            CCLogger.getInstance().debug(command.toString());

            model.fireAfterExecuteSelectEvent( e );

            ds.closeConnection();
        }
//End ListBoxAction

//ListBoxAction @18-78B8C1DD
        protected void readCOMUNE(com.codecharge.components.ListBox model) {

            LongField postPROVINCIA = new LongField(null, null);
            
            try {
                postPROVINCIA.setValue( page.getHttpPostParams().getParameter("PROVINCIA"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter" );
                return;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter" );
                return;
            }
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            DataObjectEvent e = new DataObjectEvent();
            e.setSource(model);
            e.setCommand(command);
            e.setConnection(ds);
            command.setOptimizeSQL(false);

            command.setSql( "SELECT * FROM AD4_COMUNI  where PROVINCIA_STATO = {PROV} " );
            if ( postPROVINCIA.getObjectValue() == null ) postPROVINCIA.setValue( 0 );
            command.addParameter( "PROV", postPROVINCIA, null );
            command.setOrder( "DENOMINAZIONE" );

            model.fireBeforeBuildSelectEvent( e );




            model.fireBeforeExecuteSelectEvent( e );

            Enumeration records = null;
            if ( ! ds.hasErrors() ) {
                model.setOptions( command.getRows(), ds );
            }

            CCLogger.getInstance().debug(command.toString());

            model.fireAfterExecuteSelectEvent( e );

            ds.closeConnection();
        }
//End ListBoxAction

void read() { //AD4_UTENTE Record: method read @6-7F8AAE5A

//AD4_UTENTE Record: method read head @6-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AD4_UTENTE Record: method read head

//AD4_UTENTE Record: init DataSource @6-B406812E
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AD4_UTENTEDataObject ds = new AD4_UTENTEDataObject(page);
            ds.setComponent( model );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setSesMVUTE( SessionStorage.getInstance(req).getAttribute("MVUTE") );
            ds.setPostMVPAGES( page.getHttpPostParams().getParameter("MVPAGES") );
            ds.setUrlMVPAGES( page.getHttpGetParams().getParameter("MVPAGES") );
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End AD4_UTENTE Record: init DataSource

//AD4_UTENTE Record: check errors @6-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End AD4_UTENTE Record: check errors

} //AD4_UTENTE Record: method read tail @6-FCB6E20C

//AD4_UTENTE Record: bind @6-4857E7DD
            public void bind(com.codecharge.components.Component model, AD4_UTENTERow row ) {
                if ( model == null || row == null ) return;
                if ( this.valid ) {
                    model.getControl("NOMINATIVO").setValue(row.getNOMINATIVO());
                    model.getControl("INDIRIZZO_COMPLETO").setValue(row.getINDIRIZZO_COMPLETO());
                    model.getControl("MVPAGES").setValue(row.getMVPAGES());
                }
            }
//End AD4_UTENTE Record: bind

//AD4_UTENTE Record: getRowFieldByName @6-88DE85A1
            public Object getRowFieldByName( String name, AD4_UTENTERow row ) {
                Object value = null;
                if ( "NOMINATIVO".equals(name) ) {
                    value = row.getNOMINATIVO();
                } else if ( "INDIRIZZO_COMPLETO".equals(name) ) {
                    value = row.getINDIRIZZO_COMPLETO();
                } else if ( "VIA".equals(name) ) {
                    value = row.getVIA();
                } else if ( "INDIRIZZO".equals(name) ) {
                    value = row.getINDIRIZZO();
                } else if ( "NUM".equals(name) ) {
                    value = row.getNUM();
                } else if ( "PROVINCIA".equals(name) ) {
                    value = row.getPROVINCIA();
                } else if ( "COMUNE".equals(name) ) {
                    value = row.getCOMUNE();
                } else if ( "CAP".equals(name) ) {
                    value = row.getCAP();
                } else if ( "MVPAGES".equals(name) ) {
                    value = row.getMVPAGES();
                }
                return value;
            }
//End AD4_UTENTE Record: getRowFieldByName

void InsertAction() { //AD4_UTENTE Record: method insert @6-11643485

//AD4_UTENTE Record: method insert head @6-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End AD4_UTENTE Record: method insert head

//AD4_UTENTE Record: components insert actions @6-68525650
            if (! model.hasErrors()) {
            }
//End AD4_UTENTE Record: components insert actions

} //AD4_UTENTE Record: method insert tail @6-FCB6E20C

void UpdateAction() { //AD4_UTENTE Record: method update @6-5771D0AA

//AD4_UTENTE Record: method update head @6-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End AD4_UTENTE Record: method update head

//AD4_UTENTE Record: method update body @6-5B4F310C
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            AD4_UTENTEDataObject ds = new AD4_UTENTEDataObject(page);
            ds.setComponent( model );
            AD4_UTENTERow row = new AD4_UTENTERow();
            ds.setRow(row);
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setSesMVUTE( SessionStorage.getInstance(req).getAttribute("MVUTE") );
            try {
                ds.setPostCOMUNE( page.getHttpPostParams().getParameter("COMUNE"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'COMUNE'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'COMUNE'" );
            }
            try {
                ds.setPostPROVINCIA( page.getHttpPostParams().getParameter("PROVINCIA"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'PROVINCIA'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'PROVINCIA'" );
            }
            ds.setPostCAP( page.getHttpPostParams().getParameter("CAP") );
            ds.setPostVIA( page.getHttpPostParams().getParameter("VIA") );
            ds.setPostINDIRIZZO( page.getHttpPostParams().getParameter("INDIRIZZO") );
            ds.setPostNUM( page.getHttpPostParams().getParameter("NUM") );
            ds.setUrlP_INDIRIZZO_WEB( page.getHttpGetParams().getParameter("P_INDIRIZZO_WEB") );
            ds.setUrlP_TELEFONO( page.getHttpGetParams().getParameter("P_TELEFONO") );
            ds.setUrlP_FAX( page.getHttpGetParams().getParameter("P_FAX") );
//End AD4_UTENTE Record: method update body

//AD4_UTENTE Record: ds.update @6-6E956EDC
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

} //AD4_UTENTE Record: method update tail @6-FCB6E20C

void DeleteAction() { //AD4_UTENTE Record: method delete @6-11FC2E1E

//AD4_UTENTE Record: method delete head @6-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End AD4_UTENTE Record: method delete head

//AD4_UTENTE Record: components delete actions @6-68525650
            if (! model.hasErrors()) {
            }
//End AD4_UTENTE Record: components delete actions

} //AD4_UTENTE Record: method delete tail @6-FCB6E20C

//AD4_UTENTE Record: method validate @6-1D99EC3E
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.TextBox NOMINATIVO = (com.codecharge.components.TextBox) model.getChild( "NOMINATIVO" );
            if (! NOMINATIVO.validate()) { isControlError = true; }

            com.codecharge.components.TextBox INDIRIZZO_COMPLETO = (com.codecharge.components.TextBox) model.getChild( "INDIRIZZO_COMPLETO" );
            if (! INDIRIZZO_COMPLETO.validate()) { isControlError = true; }

            com.codecharge.components.ListBox VIA = (com.codecharge.components.ListBox) model.getChild( "VIA" );
            if (! VIA.validate()) { isControlError = true; }

            com.codecharge.components.TextBox INDIRIZZO = (com.codecharge.components.TextBox) model.getChild( "INDIRIZZO" );
            if (! INDIRIZZO.validate()) { isControlError = true; }

            com.codecharge.components.TextBox NUM = (com.codecharge.components.TextBox) model.getChild( "NUM" );
            if (! NUM.validate()) { isControlError = true; }

            com.codecharge.components.ListBox PROVINCIA = (com.codecharge.components.ListBox) model.getChild( "PROVINCIA" );
            if (! PROVINCIA.validate()) { isControlError = true; }

            com.codecharge.components.ListBox COMUNE = (com.codecharge.components.ListBox) model.getChild( "COMUNE" );
            if (! COMUNE.validate()) { isControlError = true; }

            com.codecharge.components.TextBox CAP = (com.codecharge.components.TextBox) model.getChild( "CAP" );
            if (! CAP.validate()) { isControlError = true; }

            com.codecharge.components.Hidden MVPAGES = (com.codecharge.components.Hidden) model.getChild( "MVPAGES" );
            if (! MVPAGES.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AD4_UTENTE Record: method validate

//AD4_UTENTE Record Tail @6-FCB6E20C
    }
//End AD4_UTENTE Record Tail

//AmvUtenteResidenza Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvUtenteResidenza Page: method validate

//AmvUtenteResidenzaAction Tail @1-FCB6E20C
}
//End AmvUtenteResidenzaAction Tail

