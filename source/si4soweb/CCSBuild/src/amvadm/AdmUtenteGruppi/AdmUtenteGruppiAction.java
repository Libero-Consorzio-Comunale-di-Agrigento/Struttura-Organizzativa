//AdmUtenteGruppiAction imports @1-1D37C895
package amvadm.AdmUtenteGruppi;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmUtenteGruppiAction imports

//AdmUtenteGruppiAction class @1-591F17DB
public class AdmUtenteGruppiAction extends Action {

//End AdmUtenteGruppiAction class

//AdmUtenteGruppiAction: method perform @1-3646B039
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AdmUtenteGruppiModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AdmUtenteGruppiModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AdmUtenteGruppiAction: method perform

//AdmUtenteGruppiAction: call children actions @1-EAC9CA88
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
        if ( page.getChild( "AmvUtenteNominativo_i" ).isVisible() ) {
            page.getRequest().setAttribute("AmvUtenteNominativo_iParent",page);
            common.AmvUtenteNominativo_i.AmvUtenteNominativo_iAction AmvUtenteNominativo_i = new common.AmvUtenteNominativo_i.AmvUtenteNominativo_iAction();
            result = result != null ? result : AmvUtenteNominativo_i.perform( req, resp,  context );
            page.setCookies();
        }
        if (result == null) {
            DISPONIBILIClass DISPONIBILI = new DISPONIBILIClass();
            if ( ( redirect = DISPONIBILI.perform( page.getRecord("DISPONIBILI")) ) != null ) result = redirect;
        }
        if (result == null) {
            ASSEGNATIClass ASSEGNATI = new ASSEGNATIClass();
            if ( ( redirect = ASSEGNATI.perform( page.getRecord("ASSEGNATI")) ) != null ) result = redirect;
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
//End AdmUtenteGruppiAction: call children actions

//DISPONIBILI Record @70-ABF6303A
    final class DISPONIBILIClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End DISPONIBILI Record

//DISPONIBILI Record: method perform @70-30DEE94A
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( page.getActionPageName() + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowUpdate() ) model.getChild( "Uno" ).setVisible( false );
            if ( ! model.isAllowDelete() ) model.getChild( "Tutti" ).setVisible( false );
//End DISPONIBILI Record: method perform

//DISPONIBILI Record: children actions @70-B59A9E3C
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("DISPONIBILI".equals(formName)) {
                setProperties(model, Action.POST);
                if (mode != -1) { // Update mode
                    model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                    if (page.getParameter("Tutti") != null) {
                        if (validate()) {
                            TuttiAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Uno") != null) {
                        if (validate()) {
                            UnoAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                } else { // Insert mode
                    model.setMode(com.codecharge.components.Record.INSERT_MODE);
                }
            }
            setProperties(model, Action.GET, true );
            read();
            readGRUPPO_D(model.getListBox("GRUPPO_D"));
//End DISPONIBILI Record: children actions

//DISPONIBILI Record: method perform tail @70-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End DISPONIBILI Record: method perform tail

//Tutti Button @93-A7DCB9A6
        void TuttiAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Tutti");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( page.getActionPageName() + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            DeleteAction();
        }
//End Tutti Button

//Uno Button @73-C01A99F0
        void UnoAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Uno");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( page.getActionPageName() + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Uno Button

//ListBoxAction @71-C19FBA34
        protected void readGRUPPO_D(com.codecharge.components.ListBox model) {

            TextField sesProgetto = new TextField(null, null);
            
            sesProgetto.setValue( SessionStorage.getInstance(req).getAttribute("Progetto") );
            TextField sesMVUTE = new TextField(null, null);
            
            sesMVUTE.setValue( SessionStorage.getInstance(req).getAttribute("MVUTE") );
            TextField sesUtente = new TextField(null, null);
            
            sesUtente.setValue( SessionStorage.getInstance(req).getAttribute("Utente") );
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            DataObjectEvent e = new DataObjectEvent();
            e.setSource(model);
            e.setCommand(command);
            e.setConnection(ds);
            command.setOptimizeSQL(false);

            command.setSql( "select distinct u.nominativo nome_gruppo "
                        + ", ug.gruppo "
                        + "from AD4_UTENTI_GRUPPO ug,  "
                        + "AD4_UTENTI u "
                        + ", AD4_DIRITTI_ACCESSO d,  "
                        + "AD4_MODULI m "
                        + "where ug.utente = d.utente "
                        + "and ug.utente != '{Utente}' "
                        + "and u.utente = upper(ug.gruppo) "
                        + "and d.modulo = m.modulo "
                        + "and m.progetto = '{Progetto}' "
                        + "and ug.gruppo not in  "
                        + "   (select ug.gruppo "
                        + "      from AD4_UTENTI_GRUPPO ug "
                        + "     where ug.utente = nvl('{MVUTE}','{Utente}') "
                        + "   )" );
            if ( StringUtils.isEmpty( (String) sesProgetto.getObjectValue() ) ) sesProgetto.setValue( "" );
            command.addParameter( "Progetto", sesProgetto, null );
            if ( StringUtils.isEmpty( (String) sesMVUTE.getObjectValue() ) ) sesMVUTE.setValue( "" );
            command.addParameter( "MVUTE", sesMVUTE, null );
            if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
            command.addParameter( "Utente", sesUtente, null );
            command.setOrder( "" );

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

void read() { //DISPONIBILI Record: method read @70-7F8AAE5A

//DISPONIBILI Record: method read head @70-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End DISPONIBILI Record: method read head

//DISPONIBILI Record: init DataSource @70-647D1AC6
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            DISPONIBILIDataObject ds = new DISPONIBILIDataObject(page);
            ds.setComponent( model );
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End DISPONIBILI Record: init DataSource

//DISPONIBILI Record: check errors @70-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End DISPONIBILI Record: check errors

} //DISPONIBILI Record: method read tail @70-FCB6E20C

//DISPONIBILI Record: bind @70-895CAFBE
            public void bind(com.codecharge.components.Component model, DISPONIBILIRow row ) {
                if ( model == null || row == null ) return;
                if ( this.valid ) {
                }
            }
//End DISPONIBILI Record: bind

//DISPONIBILI Record: getRowFieldByName @70-1FE56718
            public Object getRowFieldByName( String name, DISPONIBILIRow row ) {
                Object value = null;
                if ( "GRUPPO_D".equals(name) ) {
                    value = row.getGRUPPO_D();
                }
                return value;
            }
//End DISPONIBILI Record: getRowFieldByName

void InsertAction() { //DISPONIBILI Record: method insert @70-11643485

//DISPONIBILI Record: method insert head @70-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End DISPONIBILI Record: method insert head

//DISPONIBILI Record: components insert actions @70-68525650
            if (! model.hasErrors()) {
            }
//End DISPONIBILI Record: components insert actions

} //DISPONIBILI Record: method insert tail @70-FCB6E20C

void UpdateAction() { //DISPONIBILI Record: method update @70-5771D0AA

//DISPONIBILI Record: method update head @70-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End DISPONIBILI Record: method update head

//DISPONIBILI Record: method update body @70-45D2AE7F
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            DISPONIBILIDataObject ds = new DISPONIBILIDataObject(page);
            ds.setComponent( model );
            DISPONIBILIRow row = new DISPONIBILIRow();
            ds.setRow(row);
            ds.setSesMVUTE( SessionStorage.getInstance(req).getAttribute("MVUTE") );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setPostGRUPPO_D( page.getHttpPostParams().getParameter("GRUPPO_D") );
//End DISPONIBILI Record: method update body

//DISPONIBILI Record: ds.update @70-6E956EDC
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
//End DISPONIBILI Record: ds.update

} //DISPONIBILI Record: method update tail @70-FCB6E20C

void DeleteAction() { //DISPONIBILI Record: method delete @70-11FC2E1E

//DISPONIBILI Record: method delete head @70-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End DISPONIBILI Record: method delete head

//DISPONIBILI Record: method delete body @70-83A98E1D
            if (!model.isAllowDelete()) return;
            boolean isErrors = false;
            DISPONIBILIDataObject ds = new DISPONIBILIDataObject(page);
            ds.setComponent( model );
            DISPONIBILIRow row = new DISPONIBILIRow();
            ds.setRow(row);
            ds.setSesMVUTE( SessionStorage.getInstance(req).getAttribute("MVUTE") );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setSesProgetto( SessionStorage.getInstance(req).getAttribute("Progetto") );
//End DISPONIBILI Record: method delete body

//DISPONIBILI Record: ds.delete @70-3584344F
            ds.delete();
            if ( ! ds.hasErrors() ) {
            }
            model.fireAfterDeleteEvent();
            action = true;
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
                this.valid = false;
            }
//End DISPONIBILI Record: ds.delete

} //DISPONIBILI Record: method delete tail @70-FCB6E20C

//DISPONIBILI Record: method validate @70-7D25C3AB
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.ListBox GRUPPO_D = (com.codecharge.components.ListBox) model.getChild( "GRUPPO_D" );
            if (! GRUPPO_D.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End DISPONIBILI Record: method validate

//DISPONIBILI Record Tail @70-FCB6E20C
    }
//End DISPONIBILI Record Tail

//ASSEGNATI Record @76-820EEF07
    final class ASSEGNATIClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End ASSEGNATI Record

//ASSEGNATI Record: method perform @76-30DEE94A
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( page.getActionPageName() + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowUpdate() ) model.getChild( "Uno" ).setVisible( false );
            if ( ! model.isAllowDelete() ) model.getChild( "Tutti" ).setVisible( false );
//End ASSEGNATI Record: method perform

//ASSEGNATI Record: children actions @76-8067E878
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("ASSEGNATI".equals(formName)) {
                setProperties(model, Action.POST);
                if (mode != -1) { // Update mode
                    model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                    if (page.getParameter("Uno") != null) {
                        if (validate()) {
                            UnoAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Tutti") != null) {
                        if (validate()) {
                            TuttiAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                } else { // Insert mode
                    model.setMode(com.codecharge.components.Record.INSERT_MODE);
                }
            }
            setProperties(model, Action.GET, true );
            read();
            readGRUPPO_A(model.getListBox("GRUPPO_A"));
//End ASSEGNATI Record: children actions

//ASSEGNATI Record: method perform tail @76-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End ASSEGNATI Record: method perform tail

//Uno Button @81-C01A99F0
        void UnoAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Uno");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( page.getActionPageName() + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Uno Button

//Tutti Button @94-A7DCB9A6
        void TuttiAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Tutti");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( page.getActionPageName() + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            DeleteAction();
        }
//End Tutti Button

//ListBoxAction @77-13DD7789
        protected void readGRUPPO_A(com.codecharge.components.ListBox model) {

            TextField sesProgetto = new TextField(null, null);
            
            sesProgetto.setValue( SessionStorage.getInstance(req).getAttribute("Progetto") );
            TextField sesUtente = new TextField(null, null);
            
            sesUtente.setValue( SessionStorage.getInstance(req).getAttribute("Utente") );
            TextField sesMVUTE = new TextField(null, null);
            
            sesMVUTE.setValue( SessionStorage.getInstance(req).getAttribute("MVUTE") );
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            DataObjectEvent e = new DataObjectEvent();
            e.setSource(model);
            e.setCommand(command);
            e.setConnection(ds);
            command.setOptimizeSQL(false);

            command.setSql( "select distinct u.nominativo nome_gruppo "
                        + ", ug.gruppo "
                        + "from AD4_UTENTI_GRUPPO ug,  "
                        + "AD4_UTENTI u "
                        + ", AD4_DIRITTI_ACCESSO d,  "
                        + "AD4_MODULI m "
                        + "where ug.utente = nvl('{MVUTE}','{Utente}') "
                        + "and ug.utente = d.utente "
                        + "AND u.utente = upper(ug.gruppo) "
                        + "and d.modulo = m.modulo "
                        + "and m.progetto = '{Progetto}'" );
            if ( StringUtils.isEmpty( (String) sesProgetto.getObjectValue() ) ) sesProgetto.setValue( "" );
            command.addParameter( "Progetto", sesProgetto, null );
            if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
            command.addParameter( "Utente", sesUtente, null );
            if ( StringUtils.isEmpty( (String) sesMVUTE.getObjectValue() ) ) sesMVUTE.setValue( "" );
            command.addParameter( "MVUTE", sesMVUTE, null );
            command.setOrder( "" );

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

void read() { //ASSEGNATI Record: method read @76-7F8AAE5A

//ASSEGNATI Record: method read head @76-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End ASSEGNATI Record: method read head

//ASSEGNATI Record: init DataSource @76-7DAF4F08
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            ASSEGNATIDataObject ds = new ASSEGNATIDataObject(page);
            ds.setComponent( model );
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End ASSEGNATI Record: init DataSource

//ASSEGNATI Record: check errors @76-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End ASSEGNATI Record: check errors

} //ASSEGNATI Record: method read tail @76-FCB6E20C

//ASSEGNATI Record: bind @76-B4FABB83
            public void bind(com.codecharge.components.Component model, ASSEGNATIRow row ) {
                if ( model == null || row == null ) return;
                if ( this.valid ) {
                }
            }
//End ASSEGNATI Record: bind

//ASSEGNATI Record: getRowFieldByName @76-6D398D71
            public Object getRowFieldByName( String name, ASSEGNATIRow row ) {
                Object value = null;
                if ( "GRUPPO_A".equals(name) ) {
                    value = row.getGRUPPO_A();
                }
                return value;
            }
//End ASSEGNATI Record: getRowFieldByName

void InsertAction() { //ASSEGNATI Record: method insert @76-11643485

//ASSEGNATI Record: method insert head @76-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End ASSEGNATI Record: method insert head

//ASSEGNATI Record: components insert actions @76-68525650
            if (! model.hasErrors()) {
            }
//End ASSEGNATI Record: components insert actions

} //ASSEGNATI Record: method insert tail @76-FCB6E20C

void UpdateAction() { //ASSEGNATI Record: method update @76-5771D0AA

//ASSEGNATI Record: method update head @76-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End ASSEGNATI Record: method update head

//ASSEGNATI Record: method update body @76-408F46C7
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            ASSEGNATIDataObject ds = new ASSEGNATIDataObject(page);
            ds.setComponent( model );
            ASSEGNATIRow row = new ASSEGNATIRow();
            ds.setRow(row);
            ds.setSesMVUTE( SessionStorage.getInstance(req).getAttribute("MVUTE") );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setPostGRUPPO_A( page.getHttpPostParams().getParameter("GRUPPO_A") );
//End ASSEGNATI Record: method update body

//ASSEGNATI Record: ds.update @76-6E956EDC
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
//End ASSEGNATI Record: ds.update

} //ASSEGNATI Record: method update tail @76-FCB6E20C

void DeleteAction() { //ASSEGNATI Record: method delete @76-11FC2E1E

//ASSEGNATI Record: method delete head @76-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End ASSEGNATI Record: method delete head

//ASSEGNATI Record: method delete body @76-92646B5B
            if (!model.isAllowDelete()) return;
            boolean isErrors = false;
            ASSEGNATIDataObject ds = new ASSEGNATIDataObject(page);
            ds.setComponent( model );
            ASSEGNATIRow row = new ASSEGNATIRow();
            ds.setRow(row);
            ds.setSesMVUTE( SessionStorage.getInstance(req).getAttribute("MVUTE") );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setSesProgetto( SessionStorage.getInstance(req).getAttribute("Progetto") );
//End ASSEGNATI Record: method delete body

//ASSEGNATI Record: ds.delete @76-3584344F
            ds.delete();
            if ( ! ds.hasErrors() ) {
            }
            model.fireAfterDeleteEvent();
            action = true;
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
                this.valid = false;
            }
//End ASSEGNATI Record: ds.delete

} //ASSEGNATI Record: method delete tail @76-FCB6E20C

//ASSEGNATI Record: method validate @76-4540ECB1
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.ListBox GRUPPO_A = (com.codecharge.components.ListBox) model.getChild( "GRUPPO_A" );
            if (! GRUPPO_A.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End ASSEGNATI Record: method validate

//ASSEGNATI Record Tail @76-FCB6E20C
    }
//End ASSEGNATI Record Tail

//AdmUtenteGruppi Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AdmUtenteGruppi Page: method validate

//AdmUtenteGruppiAction Tail @1-FCB6E20C
}
//End AdmUtenteGruppiAction Tail

