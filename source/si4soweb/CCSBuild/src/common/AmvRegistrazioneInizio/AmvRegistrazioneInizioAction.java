/******************************************************************************
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
  1   05/02/2003   AO   Gestione parametri di output della procedure in Insert
  2   10/06/2003   AO   Gestione listbox su errore di database in insert (eliminata)
  3   12/01/2004   AO   Revisione per CCS2.2.3
******************************************************************************/
//AmvRegistrazioneInizioAction imports @1-5BD83338
package common.AmvRegistrazioneInizio;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvRegistrazioneInizioAction imports

//AmvRegistrazioneInizioAction class @1-01D5A5DE
public class AmvRegistrazioneInizioAction extends Action {

//End AmvRegistrazioneInizioAction class

//AmvRegistrazioneInizioAction: method perform @1-3D498599
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvRegistrazioneInizioModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvRegistrazioneInizioModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvRegistrazioneInizioAction: method perform

//AmvRegistrazioneInizioAction: call children actions @1-4D9F17E0
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
            PRIVACYClass PRIVACY = new PRIVACYClass();
            PRIVACY.perform(page.getGrid("PRIVACY"));
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
//End AmvRegistrazioneInizioAction: call children actions

//PRIVACY Grid @114-B4CBC71A
    final class PRIVACYClass {
        com.codecharge.components.Grid model;
        Event e;
//End PRIVACY Grid

//PRIVACY Grid: method perform @114-B48879D3
        protected String perform(com.codecharge.components.Grid model) {
            if ( ! model.isVisible() ) { return null; }
            this.model = model;
            //e = new ActionEvent( model, page );
            setProperties( model, Action.GET );
            setActivePermissions( model );
            if ( ! model.isVisible() ) return null;
            read();
            return null;
        }
//End PRIVACY Grid: method perform

//PRIVACY Grid: method read: head @114-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End PRIVACY Grid: method read: head

//PRIVACY Grid: method read: init @114-48282CF9
            if ( ! model.allowRead ) return true;
            PRIVACYDataObject ds = new PRIVACYDataObject(page);
            ds.setComponent( model );
//End PRIVACY Grid: method read: init

//PRIVACY Grid: set where parameters @114-F17FFF38
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setSesModulo( SessionStorage.getInstance(req).getAttribute("Modulo") );
//End PRIVACY Grid: set where parameters

//PRIVACY Grid: set grid properties @114-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End PRIVACY Grid: set grid properties

//PRIVACY Grid: retrieve data @114-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End PRIVACY Grid: retrieve data

//PRIVACY Grid: check errors @114-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End PRIVACY Grid: check errors

//PRIVACY Grid: method read: tail @114-F575E732
            return ( ! isErrors );
        }
//End PRIVACY Grid: method read: tail

//PRIVACY Grid: method bind @114-6A80A965
        public void bind(com.codecharge.components.Component model, PRIVACYRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            PRIVACYRow row = null;
            while ( counter < rows.length && rows[counter] != null ) {
                row = rows[counter++];
                HashMap hashRow = null;
                com.codecharge.components.Control c = null;
                boolean isNew = false;
                if ( childRows.hasNext() ) {
                    hashRow = (HashMap) childRows.next();
                    if ( hashRow == null ) {
                        hashRow = new HashMap();
                        isNew = true;
                    }
                } else {
                    hashRow = new HashMap();
                    isNew = true;
                }

                c = (com.codecharge.components.Control) hashRow.get("PRIVACY");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("PRIVACY").clone();
                    c.setValue(row.getPRIVACY());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End PRIVACY Grid: method bind

//PRIVACY Directory: getRowFieldByName @114-E36EA290
        public Object getRowFieldByName( String name, PRIVACYRow row ) {
            Object value = null;
            if ( "PRIVACY".equals(name) ) {
                value = row.getPRIVACY();
            }
            return value;
        }
//End PRIVACY Directory: getRowFieldByName

//PRIVACY Grid: method validate @114-104025BA
        boolean validate() {
            return true;
        }
//End PRIVACY Grid: method validate

//PRIVACY Grid Tail @114-FCB6E20C
    }
//End PRIVACY Grid Tail

//AD4_UTENTE Record @50-20741C0E
    final class AD4_UTENTEClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AD4_UTENTE Record

//AD4_UTENTE Record: method perform @50-BEE94DC0
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AmvServiziRichiesta" + Names.ACTION_SUFFIX );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowInsert() ) model.getChild( "Insert" ).setVisible( false );
            if ( ! model.isAllowUpdate() ) model.getChild( "Update" ).setVisible( false );
//End AD4_UTENTE Record: method perform

//AD4_UTENTE Record: children actions @50-55FDCB4C
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
                    if (page.getParameter("Update") != null) {
                        if (validate()) {
                            Update113Action();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                } else { // Insert mode
                    model.setMode(com.codecharge.components.Record.INSERT_MODE);
                    if (page.getParameter("Insert") != null) {
                        if (validate()) {
                            Insert53Action();
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
//End AD4_UTENTE Record: children actions

//AD4_UTENTE Record: method perform tail @50-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AD4_UTENTE Record: method perform tail

//Update Button @113-910BB596
        void Update113Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Update");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AmvServiziRichiesta" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Update Button

//Insert Button @53-4FCD4615
        void Insert53Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Insert");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AmvServiziRichiesta" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            InsertAction();
        }
//End Insert Button

//ListBoxAction @59-156C862E
        protected void readSESSO(com.codecharge.components.ListBox model) {
            DataObjectEvent e = new DataObjectEvent();
            e.setSql( "F;F;M;M" );
            model.fireBeforeBuildSelectEvent(e);
            model.fireBeforeExecuteSelectEvent(e);
            model.setListOfValues( e.getSql() );
            model.fireAfterExecuteSelectEvent(e);
        }
//End ListBoxAction

//ListBoxAction @73-BF6E5299
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

//ListBoxAction @61-591B4993
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

//ListBoxAction @62-A3576712
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

void read() { //AD4_UTENTE Record: method read @50-7F8AAE5A

//AD4_UTENTE Record: method read head @50-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AD4_UTENTE Record: method read head

//AD4_UTENTE Record: init DataSource @50-97D24297
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AD4_UTENTEDataObject ds = new AD4_UTENTEDataObject(page);
            ds.setComponent( model );
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End AD4_UTENTE Record: init DataSource

//AD4_UTENTE Record: check errors @50-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End AD4_UTENTE Record: check errors

} //AD4_UTENTE Record: method read tail @50-FCB6E20C

//AD4_UTENTE Record: bind @50-EDEB420A
            public void bind(com.codecharge.components.Component model, AD4_UTENTERow row ) {
                if ( model == null || row == null ) return;
                if ( this.valid ) {
                }
            }
//End AD4_UTENTE Record: bind

//AD4_UTENTE Record: getRowFieldByName @50-C36850CC
            public Object getRowFieldByName( String name, AD4_UTENTERow row ) {
                Object value = null;
                if ( "NOMINATIVO".equals(name) ) {
                    value = row.getNOMINATIVO();
                } else if ( "COGNOME".equals(name) ) {
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
                } else if ( "RR".equals(name) ) {
                    value = row.getRR();
                }
                return value;
            }
//End AD4_UTENTE Record: getRowFieldByName

void InsertAction() { //AD4_UTENTE Record: method insert @50-11643485

//AD4_UTENTE Record: method insert head @50-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End AD4_UTENTE Record: method insert head

//AD4_UTENTE Record: method insert body @50-234A1695
            if (!model.isAllowInsert()) return;
            boolean isErrors = false;
            AD4_UTENTEDataObject ds = new AD4_UTENTEDataObject(page);
            ds.setComponent( model );
            AD4_UTENTERow row = new AD4_UTENTERow();
            ds.setRow(row);
            ds.setPostNOMINATIVO( page.getHttpPostParams().getParameter("NOMINATIVO") );
            ds.setPostCOGNOME( page.getHttpPostParams().getParameter("COGNOME") );
            ds.setPostNOME( page.getHttpPostParams().getParameter("NOME") );
            ds.setPostCODICE_FISCALE( page.getHttpPostParams().getParameter("CODICE_FISCALE") );
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
            ds.setPostNUMERO( page.getHttpPostParams().getParameter("NUMERO") );
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
            ds.setPostSESSO( page.getHttpPostParams().getParameter("SESSO") );
//End AD4_UTENTE Record: method insert body

//AD4_UTENTE Record: ds.insert @50-A68FADF9
//Rev.1 : gestione parametri output della procedure custom AFC 
			Collection cParam = null;		
            cParam = ds.insert();
            //ds.insert();
            if ( ! ds.hasErrors() ) {
	  			Object params[] = cParam.toArray();
				//System.out.println("Registrazione, settaggio parametri da action");
        		//Utente
				if ( params[0] != null ) {
		        	SessionStorage.getInstance(req).setAttribute("MVUTE", ((Parameter)params[0]).getObjectValue());
        			//System.out.println("Registrazione sessione MVUTE : " + ((Parameter)params[0]).getObjectValue());
				}
		        //Mezza Password
				if ( params[1] != null ) {
           			SessionStorage.getInstance(req).setAttribute("MVPWD", ((Parameter)params[1]).getObjectValue());
        			//System.out.println("Registrazione sessione MVPWD : " + ((Parameter)params[1]).getObjectValue());
        		}
            }
//Rev.1 : fine 
            model.fireAfterInsertEvent();
            action = true;
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End AD4_UTENTE Record: ds.insert

} //AD4_UTENTE Record: method insert tail @50-FCB6E20C

void UpdateAction() { //AD4_UTENTE Record: method update @50-5771D0AA

//AD4_UTENTE Record: components update actions @50-68525650
            if (! model.hasErrors()) {
            }
//End AD4_UTENTE Record: components update actions

} //AD4_UTENTE Record: method update tail @50-FCB6E20C

void DeleteAction() { //AD4_UTENTE Record: method delete @50-11FC2E1E

//AD4_UTENTE Record: components delete actions @50-68525650
            if (! model.hasErrors()) {
            }
//End AD4_UTENTE Record: components delete actions

} //AD4_UTENTE Record: method delete tail @50-FCB6E20C

//AD4_UTENTE Record: method validate @50-80EC664E
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.TextBox NOMINATIVO = (com.codecharge.components.TextBox) model.getChild( "NOMINATIVO" );
            if (! NOMINATIVO.validate()) { isControlError = true; }

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

            com.codecharge.components.Hidden RR = (com.codecharge.components.Hidden) model.getChild( "RR" );
            if (! RR.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AD4_UTENTE Record: method validate

//AD4_UTENTE Record Tail @50-FCB6E20C
    }
//End AD4_UTENTE Record Tail

//AmvRegistrazioneInizio Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvRegistrazioneInizio Page: method validate

//AmvRegistrazioneInizioAction Tail @1-FCB6E20C
}
//End AmvRegistrazioneInizioAction Tail

