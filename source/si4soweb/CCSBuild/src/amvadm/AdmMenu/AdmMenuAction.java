//AdmMenuAction imports @1-65162A0D
package amvadm.AdmMenu;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmMenuAction imports

//AdmMenuAction class @1-8ED6AA25
public class AdmMenuAction extends Action {

//End AdmMenuAction class

//AdmMenuAction: method perform @1-3F7A8621
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AdmMenuModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AdmMenuModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AdmMenuAction: method perform

//AdmMenuAction: call children actions @1-97C3959B
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
            RuoloClass Ruolo = new RuoloClass();
            if ( ( redirect = Ruolo.perform( page.getRecord("Ruolo")) ) != null ) result = redirect;
        }
        if (result == null) {
            AlberoClass Albero = new AlberoClass();
            Albero.perform(page.getGrid("Albero"));
        }
        if (result == null) {
            AMV_VOCIClass AMV_VOCI = new AMV_VOCIClass();
            if ( ( redirect = AMV_VOCI.perform( page.getRecord("AMV_VOCI")) ) != null ) result = redirect;
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
//End AdmMenuAction: call children actions

//Ruolo Record @6-191B5E87
    final class RuoloClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End Ruolo Record

//Ruolo Record: method perform @6-07A99AAC
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AdmMenu" + Names.ACTION_SUFFIX );
            page.setRedirectString( performReturnPage.toString() );
//End Ruolo Record: method perform

//Ruolo Record: children actions @6-6E90AFDE
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("Ruolo".equals(formName)) {
                setProperties(model, Action.POST);
                if (mode != -1) { // Update mode
                    model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                } else { // Insert mode
                    model.setMode(com.codecharge.components.Record.INSERT_MODE);
                }
            }
            setProperties(model, Action.GET, true );
            read();
            readSP(model.getListBox("SP"));
            readSM(model.getListBox("SM"));
            readSR(model.getListBox("SR"));
//End Ruolo Record: children actions

//Ruolo Record: method perform tail @6-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End Ruolo Record: method perform tail

//ListBoxAction @150-5569B551
        protected void readSP(com.codecharge.components.ListBox model) {

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

            command.setSql( "select distinct p.progetto, p.descrizione "
                        + "  from amv_voci v, ad4_progetti p,  "
                        + "ad4_moduli m,  "
                        + "ad4_diritti_accesso d "
                        + " where v.progetto = p.progetto "
                        + "   and m.progetto = p.progetto "
                        + "   and d.modulo = m.modulo "
                        + "   and d.utente = '{Utente}' "
                        + " " );
            if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
            command.addParameter( "Utente", sesUtente, null );
            command.setOrder( "descrizione" );

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

//ListBoxAction @7-F39F90A6
        protected void readSM(com.codecharge.components.ListBox model) {

            TextField sesMVSP = new TextField(null, null);
            
            sesMVSP.setValue( SessionStorage.getInstance(req).getAttribute("MVSP") );
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            DataObjectEvent e = new DataObjectEvent();
            e.setSource(model);
            e.setCommand(command);
            e.setConnection(ds);
            command.setOptimizeSQL(false);

            command.setSql( "SELECT distinct m.*  "
                        + "FROM AD4_MODULI m,  "
                        + "AMV_ABILITAZIONI a "
                        + "WHERE PROGETTO = '{MVSP}' "
                        + "  AND a.MODULO = m.MODULO "
                        + "" );
            if ( StringUtils.isEmpty( (String) sesMVSP.getObjectValue() ) ) sesMVSP.setValue( "" );
            command.addParameter( "MVSP", sesMVSP, null );
            command.setOrder( "DESCRIZIONE" );

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

//ListBoxAction @10-8022A8FA
        protected void readSR(com.codecharge.components.ListBox model) {

            TextField sesModulo = new TextField(null, null);
            
            sesModulo.setValue( SessionStorage.getInstance(req).getAttribute("Modulo") );
            TextField sesProgetto = new TextField(null, null);
            
            sesProgetto.setValue( SessionStorage.getInstance(req).getAttribute("Progetto") );
            TextField sesMVSM = new TextField(null, null);
            
            sesMVSM.setValue( SessionStorage.getInstance(req).getAttribute("MVSM") );
            TextField sesMVSP = new TextField(null, null);
            
            sesMVSP.setValue( SessionStorage.getInstance(req).getAttribute("MVSP") );
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            DataObjectEvent e = new DataObjectEvent();
            e.setSource(model);
            e.setCommand(command);
            e.setConnection(ds);
            command.setOptimizeSQL(false);

            command.setSql( "SELECT RUOLO,  "
                        + "DESCRIZIONE  "
                        + "FROM AD4_RUOLI "
                        + "WHERE (MODULO = nvl('{MVSM}','{Modulo}') OR MODULO is null) "
                        + "  AND (PROGETTO = '{MVSP}' OR PROGETTO is null) "
                        + "" );
            if ( StringUtils.isEmpty( (String) sesModulo.getObjectValue() ) ) sesModulo.setValue( "" );
            command.addParameter( "Modulo", sesModulo, null );
            if ( StringUtils.isEmpty( (String) sesProgetto.getObjectValue() ) ) sesProgetto.setValue( "" );
            command.addParameter( "Progetto", sesProgetto, null );
            if ( StringUtils.isEmpty( (String) sesMVSM.getObjectValue() ) ) sesMVSM.setValue( "" );
            command.addParameter( "MVSM", sesMVSM, null );
            if ( StringUtils.isEmpty( (String) sesMVSP.getObjectValue() ) ) sesMVSP.setValue( "" );
            command.addParameter( "MVSP", sesMVSP, null );
            command.setOrder( "DESCRIZIONE" );

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

void read() { //Ruolo Record: method read @6-7F8AAE5A

//Ruolo Record: method read head @6-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End Ruolo Record: method read head

//Ruolo Record: init DataSource @6-956AFB03
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            RuoloDataObject ds = new RuoloDataObject(page);
            ds.setComponent( model );
            ds.setSesMVSM( SessionStorage.getInstance(req).getAttribute("MVSM") );
            ds.setSesMVSR( SessionStorage.getInstance(req).getAttribute("MVSR") );
            ds.setSesModulo( SessionStorage.getInstance(req).getAttribute("Modulo") );
            ds.setSesProgetto( SessionStorage.getInstance(req).getAttribute("Progetto") );
            ds.setSesMVSP( SessionStorage.getInstance(req).getAttribute("MVSP") );
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End Ruolo Record: init DataSource

//Ruolo Record: check errors @6-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End Ruolo Record: check errors

} //Ruolo Record: method read tail @6-FCB6E20C

//Ruolo Record: bind @6-52841BB3
            public void bind(com.codecharge.components.Component model, RuoloRow row ) {
                if ( model == null || row == null ) return;
                if ( this.valid ) {
                    model.getControl("SP").setValue(row.getSP());
                    model.getControl("SM").setValue(row.getSM());
                    model.getControl("SR").setValue(row.getSR());
                }
            }
//End Ruolo Record: bind

//Ruolo Record: getRowFieldByName @6-B5E5940D
            public Object getRowFieldByName( String name, RuoloRow row ) {
                Object value = null;
                if ( "SP".equals(name) ) {
                    value = row.getSP();
                } else if ( "SM".equals(name) ) {
                    value = row.getSM();
                } else if ( "SR".equals(name) ) {
                    value = row.getSR();
                }
                return value;
            }
//End Ruolo Record: getRowFieldByName

void InsertAction() { //Ruolo Record: method insert @6-11643485

//Ruolo Record: components insert actions @6-68525650
            if (! model.hasErrors()) {
            }
//End Ruolo Record: components insert actions

} //Ruolo Record: method insert tail @6-FCB6E20C

void UpdateAction() { //Ruolo Record: method update @6-5771D0AA

//Ruolo Record: components update actions @6-68525650
            if (! model.hasErrors()) {
            }
//End Ruolo Record: components update actions

} //Ruolo Record: method update tail @6-FCB6E20C

void DeleteAction() { //Ruolo Record: method delete @6-11FC2E1E

//Ruolo Record: components delete actions @6-68525650
            if (! model.hasErrors()) {
            }
//End Ruolo Record: components delete actions

} //Ruolo Record: method delete tail @6-FCB6E20C

//Ruolo Record: method validate @6-11F720D4
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.ListBox SP = (com.codecharge.components.ListBox) model.getChild( "SP" );
            if (! SP.validate()) { isControlError = true; }

            com.codecharge.components.ListBox SM = (com.codecharge.components.ListBox) model.getChild( "SM" );
            if (! SM.validate()) { isControlError = true; }

            com.codecharge.components.ListBox SR = (com.codecharge.components.ListBox) model.getChild( "SR" );
            if (! SR.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End Ruolo Record: method validate

//Ruolo Record Tail @6-FCB6E20C
    }
//End Ruolo Record Tail

//Albero Grid @15-1F6F8394
    final class AlberoClass {
        com.codecharge.components.Grid model;
        Event e;
//End Albero Grid

//Albero Grid: method perform @15-B48879D3
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
//End Albero Grid: method perform

//Albero Grid: method read: head @15-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End Albero Grid: method read: head

//Albero Grid: method read: init @15-F63E90EB
            if ( ! model.allowRead ) return true;
            AlberoDataObject ds = new AlberoDataObject(page);
            ds.setComponent( model );
//End Albero Grid: method read: init

//Albero Grid: set where parameters @15-65A0EBD8
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setSesIstanza( SessionStorage.getInstance(req).getAttribute("Istanza") );
            ds.setSesModulo( SessionStorage.getInstance(req).getAttribute("Modulo") );
            ds.setSesMVSM( SessionStorage.getInstance(req).getAttribute("MVSM") );
            ds.setUrlL2( page.getHttpGetParams().getParameter("L2") );
            ds.setUrlL3( page.getHttpGetParams().getParameter("L3") );
            ds.setSesMVSR( SessionStorage.getInstance(req).getAttribute("MVSR") );
            ds.setUrlVC( page.getHttpGetParams().getParameter("VC") );
            ds.setSesMVID( SessionStorage.getInstance(req).getAttribute("MVID") );
            ds.setSesMVSP( SessionStorage.getInstance(req).getAttribute("MVSP") );
            ds.setSesProgetto( SessionStorage.getInstance(req).getAttribute("Progetto") );
//End Albero Grid: set where parameters

//Albero Grid: set grid properties @15-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End Albero Grid: set grid properties

//Albero Grid: retrieve data @15-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End Albero Grid: retrieve data

//Albero Grid: check errors @15-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End Albero Grid: check errors

//Albero Grid: method read: tail @15-F575E732
            return ( ! isErrors );
        }
//End Albero Grid: method read: tail

//Albero Grid: method bind @15-D9B8711B
        public void bind(com.codecharge.components.Component model, AlberoRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            AlberoRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("MENU");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("MENU").clone();
                    c.setValue(row.getMENU());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End Albero Grid: method bind

//Albero Directory: getRowFieldByName @15-70F5DF3D
        public Object getRowFieldByName( String name, AlberoRow row ) {
            Object value = null;
            if ( "MENU".equals(name) ) {
                value = row.getMENU();
            }
            return value;
        }
//End Albero Directory: getRowFieldByName

//Albero Grid: method validate @15-104025BA
        boolean validate() {
            return true;
        }
//End Albero Grid: method validate

//Albero Grid Tail @15-FCB6E20C
    }
//End Albero Grid Tail

//AMV_VOCI Record @35-F036A15E
    final class AMV_VOCIClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AMV_VOCI Record

//AMV_VOCI Record: method perform @35-548444F4
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AdmMenu" + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowInsert() ) model.getChild( "Insert" ).setVisible( false );
            if ( ! model.isAllowUpdate() ) model.getChild( "Update" ).setVisible( false );
            if ( ! model.isAllowDelete() ) model.getChild( "Delete" ).setVisible( false );
//End AMV_VOCI Record: method perform

//AMV_VOCI Record: children actions @35-0689DE84
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("AMV_VOCI".equals(formName)) {
                setProperties(model, Action.POST);
                if (mode != -1) { // Update mode
                    model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                    if (page.getParameter("Update") != null) {
                        if (validate()) {
                            Update57Action();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Delete") != null) {
                        Delete58Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                        if (validate()) {
                            Update57Action();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                } else { // Insert mode
                    model.setMode(com.codecharge.components.Record.INSERT_MODE);
                    if (page.getParameter("Insert") != null) {
                        if (validate()) {
                            Insert56Action();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                }
            }
            setProperties(model, Action.GET, true );
            read();
            readTIPO(model.getListBox("TIPO"));
            readVOCE_GUIDA(model.getListBox("VOCE_GUIDA"));
            readPD(model.getListBox("PD"));
            readAB(model.getRadioButton("AB"));
//End AMV_VOCI Record: children actions

//AMV_VOCI Record: method perform tail @35-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AMV_VOCI Record: method perform tail

//Insert Button @56-18E7D3A1
        void Insert56Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Insert");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmMenu" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            InsertAction();
        }
//End Insert Button

//Update Button @57-5832798C
        void Update57Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Update");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmMenu" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Update Button

//Delete Button @58-294CD64C
        void Delete58Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Delete");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmMenu" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            DeleteAction();
        }
//End Delete Button

//ListBoxAction @39-0A051F5F
        protected void readTIPO(com.codecharge.components.ListBox model) {
            DataObjectEvent e = new DataObjectEvent();
            e.setSql( ";- -;M;Menu;C;Link a pagina;N;Link a pagina in nuova finestra;E;Lancio Applet;V;Menu (non visibile);A;Link (non visibile) a pagina" );
            model.fireBeforeBuildSelectEvent(e);
            model.fireBeforeExecuteSelectEvent(e);
            model.setListOfValues( e.getSql() );
            model.fireAfterExecuteSelectEvent(e);
        }
//End ListBoxAction

//ListBoxAction @42-0D056771
        protected void readVOCE_GUIDA(com.codecharge.components.ListBox model) {

            TextField sesMVSP = new TextField(null, null);
            
            sesMVSP.setValue( SessionStorage.getInstance(req).getAttribute("MVSP") );
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            DataObjectEvent e = new DataObjectEvent();
            e.setSource(model);
            e.setCommand(command);
            e.setConnection(ds);
            command.setOptimizeSQL(false);

            command.setSql( "SELECT VOCE,  "
                        + "TITOLO||' ('||VOCE||')' TITOLO   "
                        + "FROM AMV_VOCI "
                        + "WHERE PROGETTO = '{MVSP}' AND TIPO <> 'M' "
                        + "" );
            if ( StringUtils.isEmpty( (String) sesMVSP.getObjectValue() ) ) sesMVSP.setValue( "" );
            command.addParameter( "MVSP", sesMVSP, null );
            command.setOrder( "TITOLO" );

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

//ListBoxAction @49-DB4C0824
        protected void readPD(com.codecharge.components.ListBox model) {

            TextField sesMVSM = new TextField(null, null);
            
            sesMVSM.setValue( SessionStorage.getInstance(req).getAttribute("MVSM") );
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            DataObjectEvent e = new DataObjectEvent();
            e.setSource(model);
            e.setCommand(command);
            e.setConnection(ds);
            command.setOptimizeSQL(false);

            command.setSql( "SELECT DISTINCT ABILITAZIONE, nvl(TITOLO,' - -') TITOLO  "
                        + "FROM AMV_VOCI,  "
                        + "AMV_ABILITAZIONI  "
                        + "WHERE AMV_VOCI.VOCE (+) = AMV_ABILITAZIONI.VOCE_MENU "
                        + "  AND (nvl(AMV_VOCI.TIPO, 'M') = 'M' "
                        + "       or (nvl(AMV_VOCI.TIPO, 'A') = 'A' "
                        + "       and nvl(AMV_VOCI.TIPO_VOCE, 'N') = 'N')) "
                        + "  AND nvl(AMV_ABILITAZIONI.MODULO,'{MVSM}') = '{MVSM}' "
                        + "" );
            if ( StringUtils.isEmpty( (String) sesMVSM.getObjectValue() ) ) sesMVSM.setValue( "" );
            command.addParameter( "MVSM", sesMVSM, null );
            command.setOrder( "TITOLO " );

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

//RadioButtonAction @54-38EEBBE2
        protected void readAB(com.codecharge.components.RadioButton model) {
            DataObjectEvent e = new DataObjectEvent();
            e.setSql( "1;Si;-1;No;0;Nuova;9;Tutti i ruoli" );
            model.fireBeforeBuildSelectEvent(e);
            model.fireBeforeExecuteSelectEvent(e);
            model.setListOfValues( e.getSql() );
            model.fireAfterExecuteSelectEvent(e);
        }
//End RadioButtonAction

void read() { //AMV_VOCI Record: method read @35-7F8AAE5A

//AMV_VOCI Record: method read head @35-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AMV_VOCI Record: method read head

//AMV_VOCI Record: init DataSource @35-9799B47A
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AMV_VOCIDataObject ds = new AMV_VOCIDataObject(page);
            ds.setComponent( model );
            ds.setUrlVC( page.getHttpGetParams().getParameter("VC") );
            ds.setSesMVSM( SessionStorage.getInstance(req).getAttribute("MVSM") );
            ds.setSesModulo( SessionStorage.getInstance(req).getAttribute("Modulo") );
            ds.setUrlAB( page.getHttpGetParams().getParameter("AB") );
            ds.setUrlPD( page.getHttpGetParams().getParameter("PD") );
            ds.setSesMVSR( SessionStorage.getInstance(req).getAttribute("MVSR") );
            try {
                ds.setPostAB( page.getHttpPostParams().getParameter("AB"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'AB'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'AB'" );
            }
            ds.setSesMVDIRUPLOAD( SessionStorage.getInstance(req).getAttribute("MVDIRUPLOAD") );
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End AMV_VOCI Record: init DataSource

//AMV_VOCI Record: check errors @35-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End AMV_VOCI Record: check errors

} //AMV_VOCI Record: method read tail @35-FCB6E20C

//AMV_VOCI Record: bind @35-D0AD5159
            public void bind(com.codecharge.components.Component model, AMV_VOCIRow row ) {
                if ( model == null || row == null ) return;
                model.getControl("Nuovo").setValue(row.getNuovo());
                if ( this.valid ) {
                    model.getControl("VOCE_NEW").setValue(row.getVOCE_NEW());
                    model.getControl("VOCE_OLD").setValue(row.getVOCE_OLD());
                    model.getControl("TITOLO").setValue(row.getTITOLO());
                    model.getControl("TIPO").setValue(row.getTIPO());
                    model.getControl("STRINGA").setValue(row.getSTRINGA());
                    model.getControl("MODULO").setValue(row.getMODULO());
                    model.getControl("NOTE").setValue(row.getNOTE());
                    model.getControl("VOCE_GUIDA").setValue(row.getVOCE_GUIDA());
                    model.getControl("SM").setValue(row.getSM());
                    model.getControl("PADRE_OLD").setValue(row.getPADRE_OLD());
                    model.getControl("RUOLO").setValue(row.getRUOLO());
                    model.getControl("MVDIRUPLOAD").setValue(row.getMVDIRUPLOAD());
                    model.getControl("AB").setValue(row.getAB());
                }
            }
//End AMV_VOCI Record: bind

//AMV_VOCI Record: getRowFieldByName @35-20400A0D
            public Object getRowFieldByName( String name, AMV_VOCIRow row ) {
                Object value = null;
                if ( "VOCE_NEW".equals(name) ) {
                    value = row.getVOCE_NEW();
                } else if ( "VOCE_OLD".equals(name) ) {
                    value = row.getVOCE_OLD();
                } else if ( "TITOLO".equals(name) ) {
                    value = row.getTITOLO();
                } else if ( "TIPO".equals(name) ) {
                    value = row.getTIPO();
                } else if ( "STRINGA".equals(name) ) {
                    value = row.getSTRINGA();
                } else if ( "MODULO".equals(name) ) {
                    value = row.getMODULO();
                } else if ( "NOTE".equals(name) ) {
                    value = row.getNOTE();
                } else if ( "VOCE_GUIDA".equals(name) ) {
                    value = row.getVOCE_GUIDA();
                } else if ( "SM".equals(name) ) {
                    value = row.getSM();
                } else if ( "PD".equals(name) ) {
                    value = row.getPD();
                } else if ( "PADRE_OLD".equals(name) ) {
                    value = row.getPADRE_OLD();
                } else if ( "SQ".equals(name) ) {
                    value = row.getSQ();
                } else if ( "RUOLO".equals(name) ) {
                    value = row.getRUOLO();
                } else if ( "MVDIRUPLOAD".equals(name) ) {
                    value = row.getMVDIRUPLOAD();
                } else if ( "AB".equals(name) ) {
                    value = row.getAB();
                } else if ( "Nuovo".equals(name) ) {
                    value = row.getNuovo();
                }
                return value;
            }
//End AMV_VOCI Record: getRowFieldByName

void InsertAction() { //AMV_VOCI Record: method insert @35-11643485

//AMV_VOCI Record: method insert head @35-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End AMV_VOCI Record: method insert head

//AMV_VOCI Record: method insert body @35-0F683661
            if (!model.isAllowInsert()) return;
            boolean isErrors = false;
            AMV_VOCIDataObject ds = new AMV_VOCIDataObject(page);
            ds.setComponent( model );
            AMV_VOCIRow row = new AMV_VOCIRow();
            ds.setRow(row);
            ds.setExpr65( ( "I" ) );
            ds.setPostVOCE_NEW( page.getHttpPostParams().getParameter("VOCE_NEW") );
            ds.setSesMVSP( SessionStorage.getInstance(req).getAttribute("MVSP") );
            ds.setUrlP_ACRONIMO( page.getHttpGetParams().getParameter("P_ACRONIMO") );
            ds.setUrlP_ACRONIMO_AL1( page.getHttpGetParams().getParameter("P_ACRONIMO_AL1") );
            ds.setUrlP_ACRONIMO_AL2( page.getHttpGetParams().getParameter("P_ACRONIMO_AL2") );
            ds.setPostTITOLO( page.getHttpPostParams().getParameter("TITOLO") );
            ds.setUrlP_TITOLO_AL1( page.getHttpGetParams().getParameter("P_TITOLO_AL1") );
            ds.setUrlP_TITOLO_AL2( page.getHttpGetParams().getParameter("P_TITOLO_AL2") );
            ds.setUrlP_TIPO_VOCE( page.getHttpGetParams().getParameter("P_TIPO_VOCE") );
            ds.setPostTIPO( page.getHttpPostParams().getParameter("TIPO") );
            ds.setPostMODULO( page.getHttpPostParams().getParameter("MODULO") );
            ds.setPostSTRINGA( page.getHttpPostParams().getParameter("STRINGA") );
            ds.setUrlP_PROFILO( page.getHttpGetParams().getParameter("P_PROFILO") );
            ds.setPostVOCE_GUIDA( page.getHttpPostParams().getParameter("VOCE_GUIDA") );
            ds.setUrlP_PROPRIETA( page.getHttpGetParams().getParameter("P_PROPRIETA") );
            ds.setPostNOTE( page.getHttpPostParams().getParameter("NOTE") );
            try {
                ds.setPostPD( page.getHttpPostParams().getParameter("PD"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'PD'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'PD'" );
            }
            try {
                ds.setPostPADRE_OLD( page.getHttpPostParams().getParameter("PADRE_OLD"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'PADRE_OLD'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'PADRE_OLD'" );
            }
            ds.setSesMVSM( SessionStorage.getInstance(req).getAttribute("MVSM") );
            try {
                ds.setPostSQ( page.getHttpPostParams().getParameter("SQ"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'SQ'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'SQ'" );
            }
            ds.setSesMVSR( SessionStorage.getInstance(req).getAttribute("MVSR") );
            try {
                ds.setPostAB( page.getHttpPostParams().getParameter("AB"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'AB'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'AB'" );
            }
            ds.setPostVOCE_OLD( page.getHttpPostParams().getParameter("VOCE_OLD") );
//End AMV_VOCI Record: method insert body

//AMV_VOCI Record: ds.insert @35-9320B03B
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
//End AMV_VOCI Record: ds.insert

} //AMV_VOCI Record: method insert tail @35-FCB6E20C

void UpdateAction() { //AMV_VOCI Record: method update @35-5771D0AA

//AMV_VOCI Record: method update head @35-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End AMV_VOCI Record: method update head

//AMV_VOCI Record: method update body @35-578F7AB0
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            AMV_VOCIDataObject ds = new AMV_VOCIDataObject(page);
            ds.setComponent( model );
            AMV_VOCIRow row = new AMV_VOCIRow();
            ds.setRow(row);
            ds.setExpr100( ( "U" ) );
            ds.setPostVOCE_NEW( page.getHttpPostParams().getParameter("VOCE_NEW") );
            ds.setSesMVSP( SessionStorage.getInstance(req).getAttribute("MVSP") );
            ds.setUrlP_ACRONIMO( page.getHttpGetParams().getParameter("P_ACRONIMO") );
            ds.setUrlP_ACRONIMO_AL1( page.getHttpGetParams().getParameter("P_ACRONIMO_AL1") );
            ds.setUrlP_ACRONIMO_AL2( page.getHttpGetParams().getParameter("P_ACRONIMO_AL2") );
            ds.setPostTITOLO( page.getHttpPostParams().getParameter("TITOLO") );
            ds.setUrlP_TITOLO_AL1( page.getHttpGetParams().getParameter("P_TITOLO_AL1") );
            ds.setUrlP_TITOLO_AL2( page.getHttpGetParams().getParameter("P_TITOLO_AL2") );
            ds.setUrlP_TIPO_VOCE( page.getHttpGetParams().getParameter("P_TIPO_VOCE") );
            ds.setPostTIPO( page.getHttpPostParams().getParameter("TIPO") );
            ds.setPostMODULO( page.getHttpPostParams().getParameter("MODULO") );
            ds.setPostSTRINGA( page.getHttpPostParams().getParameter("STRINGA") );
            ds.setUrlP_PROFILO( page.getHttpGetParams().getParameter("P_PROFILO") );
            ds.setPostVOCE_GUIDA( page.getHttpPostParams().getParameter("VOCE_GUIDA") );
            ds.setUrlP_PROPRIETA( page.getHttpGetParams().getParameter("P_PROPRIETA") );
            ds.setPostNOTE( page.getHttpPostParams().getParameter("NOTE") );
            try {
                ds.setPostPD( page.getHttpPostParams().getParameter("PD"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'PD'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'PD'" );
            }
            try {
                ds.setPostPADRE_OLD( page.getHttpPostParams().getParameter("PADRE_OLD"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'PADRE_OLD'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'PADRE_OLD'" );
            }
            ds.setSesMVSM( SessionStorage.getInstance(req).getAttribute("MVSM") );
            try {
                ds.setPostSQ( page.getHttpPostParams().getParameter("SQ"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'SQ'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'SQ'" );
            }
            ds.setSesMVSR( SessionStorage.getInstance(req).getAttribute("MVSR") );
            try {
                ds.setPostAB( page.getHttpPostParams().getParameter("AB"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'AB'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'AB'" );
            }
            ds.setPostVOCE_OLD( page.getHttpPostParams().getParameter("VOCE_OLD") );
//End AMV_VOCI Record: method update body

//AMV_VOCI Record: ds.update @35-6E956EDC
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
//End AMV_VOCI Record: ds.update

} //AMV_VOCI Record: method update tail @35-FCB6E20C

void DeleteAction() { //AMV_VOCI Record: method delete @35-11FC2E1E

//AMV_VOCI Record: method delete head @35-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End AMV_VOCI Record: method delete head

//AMV_VOCI Record: method delete body @35-A2406CC8
            if (!model.isAllowDelete()) return;
            boolean isErrors = false;
            AMV_VOCIDataObject ds = new AMV_VOCIDataObject(page);
            ds.setComponent( model );
            AMV_VOCIRow row = new AMV_VOCIRow();
            ds.setRow(row);
            ds.setUrlVC( page.getHttpGetParams().getParameter("VC") );
//End AMV_VOCI Record: method delete body

//AMV_VOCI Record: ds.delete @35-3584344F
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
//End AMV_VOCI Record: ds.delete

} //AMV_VOCI Record: method delete tail @35-FCB6E20C

//AMV_VOCI Record: method validate @35-9890A99E
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.TextBox VOCE_NEW = (com.codecharge.components.TextBox) model.getChild( "VOCE_NEW" );
            if (! VOCE_NEW.validate()) { isControlError = true; }

            com.codecharge.components.Hidden VOCE_OLD = (com.codecharge.components.Hidden) model.getChild( "VOCE_OLD" );
            if (! VOCE_OLD.validate()) { isControlError = true; }

            com.codecharge.components.TextBox TITOLO = (com.codecharge.components.TextBox) model.getChild( "TITOLO" );
            if (! TITOLO.validate()) { isControlError = true; }

            com.codecharge.components.ListBox TIPO = (com.codecharge.components.ListBox) model.getChild( "TIPO" );
            if (! TIPO.validate()) { isControlError = true; }

            com.codecharge.components.TextBox STRINGA = (com.codecharge.components.TextBox) model.getChild( "STRINGA" );
            if (! STRINGA.validate()) { isControlError = true; }

            com.codecharge.components.TextBox MODULO = (com.codecharge.components.TextBox) model.getChild( "MODULO" );
            if (! MODULO.validate()) { isControlError = true; }

            com.codecharge.components.TextArea NOTE = (com.codecharge.components.TextArea) model.getChild( "NOTE" );
            if (! NOTE.validate()) { isControlError = true; }

            com.codecharge.components.ListBox VOCE_GUIDA = (com.codecharge.components.ListBox) model.getChild( "VOCE_GUIDA" );
            if (! VOCE_GUIDA.validate()) { isControlError = true; }

            com.codecharge.components.Hidden SM = (com.codecharge.components.Hidden) model.getChild( "SM" );
            if (! SM.validate()) { isControlError = true; }

            com.codecharge.components.ListBox PD = (com.codecharge.components.ListBox) model.getChild( "PD" );
            if (! PD.validate()) { isControlError = true; }

            com.codecharge.components.Hidden PADRE_OLD = (com.codecharge.components.Hidden) model.getChild( "PADRE_OLD" );
            if (! PADRE_OLD.validate()) { isControlError = true; }

            com.codecharge.components.TextBox SQ = (com.codecharge.components.TextBox) model.getChild( "SQ" );
            if (! SQ.validate()) { isControlError = true; }

            com.codecharge.components.Hidden RUOLO = (com.codecharge.components.Hidden) model.getChild( "RUOLO" );
            if (! RUOLO.validate()) { isControlError = true; }

            com.codecharge.components.Hidden MVDIRUPLOAD = (com.codecharge.components.Hidden) model.getChild( "MVDIRUPLOAD" );
            if (! MVDIRUPLOAD.validate()) { isControlError = true; }

            com.codecharge.components.RadioButton AB = (com.codecharge.components.RadioButton) model.getChild( "AB" );
            if (! AB.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AMV_VOCI Record: method validate

//AMV_VOCI Record Tail @35-FCB6E20C
    }
//End AMV_VOCI Record Tail

//AdmMenu Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AdmMenu Page: method validate

//AdmMenuAction Tail @1-FCB6E20C
}
//End AdmMenuAction Tail

