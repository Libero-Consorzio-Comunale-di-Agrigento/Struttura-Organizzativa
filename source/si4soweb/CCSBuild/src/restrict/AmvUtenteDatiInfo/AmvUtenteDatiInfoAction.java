//AmvUtenteDatiInfoAction imports @1-79595CFA
package restrict.AmvUtenteDatiInfo;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvUtenteDatiInfoAction imports

//AmvUtenteDatiInfoAction class @1-9EDCF3CD
public class AmvUtenteDatiInfoAction extends Action {

//End AmvUtenteDatiInfoAction class

//AmvUtenteDatiInfoAction: method perform @1-44425AC0
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvUtenteDatiInfoModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvUtenteDatiInfoModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvUtenteDatiInfoAction: method perform

//AmvUtenteDatiInfoAction: call children actions @1-5207489B
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
        if (result == null) {
            AD4_SOGGETTOClass AD4_SOGGETTO = new AD4_SOGGETTOClass();
            if ( ( redirect = AD4_SOGGETTO.perform( page.getRecord("AD4_SOGGETTO")) ) != null ) result = redirect;
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
//End AmvUtenteDatiInfoAction: call children actions

//AD4_UTENTE Record @6-20741C0E
    final class AD4_UTENTEClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AD4_UTENTE Record

//AD4_UTENTE Record: method perform @6-8AA022EB
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "../common/AmvUtenteResidenza" + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
//End AD4_UTENTE Record: method perform

//AD4_UTENTE Record: children actions @6-247A9DD7
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("AD4_UTENTE".equals(formName)) {
                setProperties(model, Action.POST);
                    if (validate()) {
                        Button_UpdateSearchAction();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
            }
            setProperties(model, Action.GET, true );
            read();
//End AD4_UTENTE Record: children actions

//AD4_UTENTE Record: method perform tail @6-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AD4_UTENTE Record: method perform tail

//Button_Update Button @24-FC0DEB23
        void Button_UpdateSearchAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Button_Update");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            for ( Iterator params = model.getChildren().iterator(); params.hasNext(); ) {
                excludeParams.add( ((com.codecharge.components.Model) params.next()).getName() );
            }
            page.setRedirectString( "../common/AmvUtenteResidenza" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) + "&" + page.getHttpPostParams().toString( buttonModel.getExcludeParams() ) );
            buttonModel.fireOnClickEvent();
        }
//End Button_Update Button

void read() { //AD4_UTENTE Record: method read @6-7F8AAE5A

//AD4_UTENTE Record: method read head @6-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AD4_UTENTE Record: method read head

//AD4_UTENTE Record: init DataSource @6-9F68DB1A
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AD4_UTENTEDataObject ds = new AD4_UTENTEDataObject(page);
            ds.setComponent( model );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setUrlMVID( page.getHttpGetParams().getParameter("MVID") );
            ds.setUrlMVID2( page.getHttpGetParams().getParameter("MVID2") );
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

//AD4_UTENTE Record: bind @6-72B8B47F
            public void bind(com.codecharge.components.Component model, AD4_UTENTERow row ) {
                if ( model == null || row == null ) return;
                model.getControl("NOME").setValue(row.getNOME());
                model.getControl("SESSO").setValue(row.getSESSO());
                model.getControl("CODICE_FISCALE").setValue(row.getCODICE_FISCALE());
                model.getControl("DATA_NASCITA").setValue(row.getDATA_NASCITA());
                model.getControl("DES_COMUNE_NAS").setValue(row.getDES_COMUNE_NAS());
                model.getControl("DES_PROVINCIA_NAS").setValue(row.getDES_PROVINCIA_NAS());
                model.getControl("INDIRIZZO_COMPLETO").setValue(row.getINDIRIZZO_COMPLETO());
                if ( this.valid ) {
                    model.getControl("MVPAGES").setValue(row.getMVPAGES());
                }
            }
//End AD4_UTENTE Record: bind

//AD4_UTENTE Record: getRowFieldByName @6-181162CC
            public Object getRowFieldByName( String name, AD4_UTENTERow row ) {
                Object value = null;
                if ( "NOME".equals(name) ) {
                    value = row.getNOME();
                } else if ( "SESSO".equals(name) ) {
                    value = row.getSESSO();
                } else if ( "CODICE_FISCALE".equals(name) ) {
                    value = row.getCODICE_FISCALE();
                } else if ( "DATA_NASCITA".equals(name) ) {
                    value = row.getDATA_NASCITA();
                } else if ( "DES_COMUNE_NAS".equals(name) ) {
                    value = row.getDES_COMUNE_NAS();
                } else if ( "DES_PROVINCIA_NAS".equals(name) ) {
                    value = row.getDES_PROVINCIA_NAS();
                } else if ( "INDIRIZZO_COMPLETO".equals(name) ) {
                    value = row.getINDIRIZZO_COMPLETO();
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

//AD4_UTENTE Record: components update actions @6-68525650
            if (! model.hasErrors()) {
            }
//End AD4_UTENTE Record: components update actions

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

//AD4_UTENTE Record: method validate @6-8FD6BBAB
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.Hidden MVPAGES = (com.codecharge.components.Hidden) model.getChild( "MVPAGES" );
            if (! MVPAGES.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AD4_UTENTE Record: method validate

//AD4_UTENTE Record Tail @6-FCB6E20C
    }
//End AD4_UTENTE Record Tail

//AD4_SOGGETTO Record @52-54097E83
    final class AD4_SOGGETTOClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AD4_SOGGETTO Record

//AD4_SOGGETTO Record: method perform @52-96E5E99C
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AmvUtenteDatiInfo" + Names.ACTION_SUFFIX );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowInsert() ) model.getChild( "Insert" ).setVisible( false );
            if ( ! model.isAllowUpdate() ) model.getChild( "Update" ).setVisible( false );
//End AD4_SOGGETTO Record: method perform

//AD4_SOGGETTO Record: children actions @52-2329C1BC
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("AD4_SOGGETTO".equals(formName)) {
                setProperties(model, Action.POST);
                if (mode != -1) { // Update mode
                    model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                    if (page.getParameter("Update") != null) {
                        if (validate()) {
                            Update68Action();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                } else { // Insert mode
                    model.setMode(com.codecharge.components.Record.INSERT_MODE);
                    if (page.getParameter("Insert") != null) {
                        if (validate()) {
                            Insert69Action();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                }
            }
            setProperties(model, Action.GET, true );
            read();
            readSESSO(model.getListBox("SESSO"));
            readSTATO_NASCITA(model.getListBox("STATO_NASCITA"));
            readPROVINCIA_NASCITA(model.getListBox("PROVINCIA_NASCITA"));
            readCOMUNE_NASCITA(model.getListBox("COMUNE_NASCITA"));
//End AD4_SOGGETTO Record: children actions

//AD4_SOGGETTO Record: method perform tail @52-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AD4_SOGGETTO Record: method perform tail

//Update Button @68-DB6DC76B
        void Update68Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Update");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AmvUtenteDatiInfo" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Update Button

//Insert Button @69-6B1D850C
        void Insert69Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Insert");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AmvUtenteDatiInfo" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            InsertAction();
        }
//End Insert Button

//ListBoxAction @56-156C862E
        protected void readSESSO(com.codecharge.components.ListBox model) {
            DataObjectEvent e = new DataObjectEvent();
            e.setSql( "F;F;M;M" );
            model.fireBeforeBuildSelectEvent(e);
            model.fireBeforeExecuteSelectEvent(e);
            model.setListOfValues( e.getSql() );
            model.fireAfterExecuteSelectEvent(e);
        }
//End ListBoxAction

//ListBoxAction @58-BF6E5299
        protected void readSTATO_NASCITA(com.codecharge.components.ListBox model) {
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            DataObjectEvent e = new DataObjectEvent();
            e.setSource(model);
            e.setCommand(command);
            e.setConnection(ds);
            command.setOptimizeSQL(false);

            command.setSql( "SELECT *  "
                        + "FROM AD4_STATI_TERRITORI" );
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

//ListBoxAction @60-591B4993
        protected void readPROVINCIA_NASCITA(com.codecharge.components.ListBox model) {

            LongField postSTATO_NASCITA = new LongField(null, null);
            
            try {
                postSTATO_NASCITA.setValue( page.getHttpPostParams().getParameter("STATO_NASCITA"), page.getCCSLocale().getFormat("Integer") );
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

            command.setSql( "select to_number(null) provincia,  "
                        + "'- -' denominazione "
                        + "  from dual "
                        + " where nvl({P_STATO},100) = 100  "
                        + "union "
                        + "select provincia,  "
                        + "denominazione "
                        + "  from ad4_provincie  "
                        + " where nvl({P_STATO},100) = 100  "
                        + "union "
                        + "select provincia_stato,  "
                        + "'EE' denominazione  "
                        + "  from ad4_comuni  "
                        + " where provincia_stato = decode({P_STATO},100,'',{P_STATO}) "
                        + "   and comune = 0 "
                        + "" );
            if ( postSTATO_NASCITA.getObjectValue() == null ) postSTATO_NASCITA.setValue( 100 );
            command.addParameter( "P_STATO", postSTATO_NASCITA, null );
            command.setOrder( "denominazione" );

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

//ListBoxAction @63-A3576712
        protected void readCOMUNE_NASCITA(com.codecharge.components.ListBox model) {

            LongField postPROVINCIA_NASCITA = new LongField(null, null);
            
            try {
                postPROVINCIA_NASCITA.setValue( page.getHttpPostParams().getParameter("PROVINCIA_NASCITA"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter" );
                return;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter" );
                return;
            }
            LongField postSTATO_NASCITA = new LongField(null, null);
            
            try {
                postSTATO_NASCITA.setValue( page.getHttpPostParams().getParameter("STATO_NASCITA"), page.getCCSLocale().getFormat("Integer") );
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

            command.setSql( "select to_number(null) comune,  "
                        + "'- -' denominazione "
                        + "  from dual "
                        + " where nvl({STATO},100) = 100  "
                        + "union "
                        + "SELECT comune,  "
                        + "denominazione  "
                        + "  FROM AD4_COMUNI  "
                        + " where PROVINCIA_STATO = DECODE({STATO},100,{PROV},NULL) "
                        + "   and PROVINCIA_STATO < 200  "
                        + "union "
                        + "select comune, decode(comune,0,'nn',denominazione) denominazione  "
                        + " from ad4_comuni  "
                        + "where provincia_stato = DECODE({STATO},100,'',{STATO}) "
                        + "" );
            if ( postPROVINCIA_NASCITA.getObjectValue() == null ) postPROVINCIA_NASCITA.setValue( 0 );
            command.addParameter( "PROV", postPROVINCIA_NASCITA, null );
            if ( postSTATO_NASCITA.getObjectValue() == null ) postSTATO_NASCITA.setValue( 100 );
            command.addParameter( "STATO", postSTATO_NASCITA, null );
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

void read() { //AD4_SOGGETTO Record: method read @52-7F8AAE5A

//AD4_SOGGETTO Record: method read head @52-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AD4_SOGGETTO Record: method read head

//AD4_SOGGETTO Record: init DataSource @52-5E0AD224
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AD4_SOGGETTODataObject ds = new AD4_SOGGETTODataObject(page);
            ds.setComponent( model );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End AD4_SOGGETTO Record: init DataSource

//AD4_SOGGETTO Record: check errors @52-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End AD4_SOGGETTO Record: check errors

} //AD4_SOGGETTO Record: method read tail @52-FCB6E20C

//AD4_SOGGETTO Record: bind @52-4AD4BA0D
            public void bind(com.codecharge.components.Component model, AD4_SOGGETTORow row ) {
                if ( model == null || row == null ) return;
                if ( this.valid ) {
                    model.getControl("COGNOME").setValue(row.getCOGNOME());
                    model.getControl("NOME").setValue(row.getNOME());
                }
            }
//End AD4_SOGGETTO Record: bind

//AD4_SOGGETTO Record: getRowFieldByName @52-5A927A6C
            public Object getRowFieldByName( String name, AD4_SOGGETTORow row ) {
                Object value = null;
                if ( "COGNOME".equals(name) ) {
                    value = row.getCOGNOME();
                } else if ( "NOME".equals(name) ) {
                    value = row.getNOME();
                } else if ( "SESSO".equals(name) ) {
                    value = row.getSESSO();
                } else if ( "DATA_NASCITA".equals(name) ) {
                    value = row.getDATA_NASCITA();
                } else if ( "STATO_NASCITA".equals(name) ) {
                    value = row.getSTATO_NASCITA();
                } else if ( "PROVINCIA_NASCITA".equals(name) ) {
                    value = row.getPROVINCIA_NASCITA();
                } else if ( "COMUNE_NASCITA".equals(name) ) {
                    value = row.getCOMUNE_NASCITA();
                } else if ( "CODICE_FISCALE".equals(name) ) {
                    value = row.getCODICE_FISCALE();
                }
                return value;
            }
//End AD4_SOGGETTO Record: getRowFieldByName

void InsertAction() { //AD4_SOGGETTO Record: method insert @52-11643485

//AD4_SOGGETTO Record: method insert head @52-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End AD4_SOGGETTO Record: method insert head

//AD4_SOGGETTO Record: method insert body @52-5ABBC47A
            if (!model.isAllowInsert()) return;
            boolean isErrors = false;
            AD4_SOGGETTODataObject ds = new AD4_SOGGETTODataObject(page);
            ds.setComponent( model );
            AD4_SOGGETTORow row = new AD4_SOGGETTORow();
            ds.setRow(row);
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setPostCOGNOME( page.getHttpPostParams().getParameter("COGNOME") );
            ds.setPostNOME( page.getHttpPostParams().getParameter("NOME") );
            ds.setPostSESSO( page.getHttpPostParams().getParameter("SESSO") );
            try {
                ds.setPostCOMUNE_NASCITA( page.getHttpPostParams().getParameter("COMUNE_NASCITA"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'COMUNE_NASCITA'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'COMUNE_NASCITA'" );
            }
            try {
                ds.setPostPROVINCIA_NASCITA( page.getHttpPostParams().getParameter("PROVINCIA_NASCITA"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'PROVINCIA_NASCITA'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'PROVINCIA_NASCITA'" );
            }
            ds.setPostDATA_NASCITA( page.getHttpPostParams().getParameter("DATA_NASCITA") );
            ds.setPostCODICE_FISCALE( page.getHttpPostParams().getParameter("CODICE_FISCALE") );
//End AD4_SOGGETTO Record: method insert body

//AD4_SOGGETTO Record: ds.insert @52-9320B03B
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
//End AD4_SOGGETTO Record: ds.insert

} //AD4_SOGGETTO Record: method insert tail @52-FCB6E20C

void UpdateAction() { //AD4_SOGGETTO Record: method update @52-5771D0AA

//AD4_SOGGETTO Record: method update head @52-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End AD4_SOGGETTO Record: method update head

//AD4_SOGGETTO Record: method update body @52-395A3CB0
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            AD4_SOGGETTODataObject ds = new AD4_SOGGETTODataObject(page);
            ds.setComponent( model );
            AD4_SOGGETTORow row = new AD4_SOGGETTORow();
            ds.setRow(row);
//End AD4_SOGGETTO Record: method update body

//AD4_SOGGETTO Record: ds.update @52-6E956EDC
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
//End AD4_SOGGETTO Record: ds.update

} //AD4_SOGGETTO Record: method update tail @52-FCB6E20C

void DeleteAction() { //AD4_SOGGETTO Record: method delete @52-11FC2E1E

//AD4_SOGGETTO Record: components delete actions @52-68525650
            if (! model.hasErrors()) {
            }
//End AD4_SOGGETTO Record: components delete actions

} //AD4_SOGGETTO Record: method delete tail @52-FCB6E20C

//AD4_SOGGETTO Record: method validate @52-51D4C3A8
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.TextBox COGNOME = (com.codecharge.components.TextBox) model.getChild( "COGNOME" );
            if (! COGNOME.validate()) { isControlError = true; }

            com.codecharge.components.TextBox NOME = (com.codecharge.components.TextBox) model.getChild( "NOME" );
            if (! NOME.validate()) { isControlError = true; }

            com.codecharge.components.ListBox SESSO = (com.codecharge.components.ListBox) model.getChild( "SESSO" );
            if (! SESSO.validate()) { isControlError = true; }

            com.codecharge.components.TextBox DATA_NASCITA = (com.codecharge.components.TextBox) model.getChild( "DATA_NASCITA" );
            if (! DATA_NASCITA.validate()) { isControlError = true; }

            com.codecharge.components.ListBox STATO_NASCITA = (com.codecharge.components.ListBox) model.getChild( "STATO_NASCITA" );
            if (! STATO_NASCITA.validate()) { isControlError = true; }

            com.codecharge.components.ListBox PROVINCIA_NASCITA = (com.codecharge.components.ListBox) model.getChild( "PROVINCIA_NASCITA" );
            if (! PROVINCIA_NASCITA.validate()) { isControlError = true; }

            com.codecharge.components.ListBox COMUNE_NASCITA = (com.codecharge.components.ListBox) model.getChild( "COMUNE_NASCITA" );
            if (! COMUNE_NASCITA.validate()) { isControlError = true; }

            com.codecharge.components.TextBox CODICE_FISCALE = (com.codecharge.components.TextBox) model.getChild( "CODICE_FISCALE" );
            if (! CODICE_FISCALE.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AD4_SOGGETTO Record: method validate

//AD4_SOGGETTO Record Tail @52-FCB6E20C
    }
//End AD4_SOGGETTO Record Tail

//AmvUtenteDatiInfo Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvUtenteDatiInfo Page: method validate

//AmvUtenteDatiInfoAction Tail @1-FCB6E20C
}
//End AmvUtenteDatiInfoAction Tail

