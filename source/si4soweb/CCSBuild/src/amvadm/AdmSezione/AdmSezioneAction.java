//AdmSezioneAction imports @1-E0A26ECE
package amvadm.AdmSezione;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmSezioneAction imports

//AdmSezioneAction class @1-2842B351
public class AdmSezioneAction extends Action {

//End AdmSezioneAction class

//AdmSezioneAction: method perform @1-66EA5E2D
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AdmSezioneModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AdmSezioneModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AdmSezioneAction: method perform

//AdmSezioneAction: call children actions @1-6CA35B10
        if (result == null) {
            AMV_SEZIONE_RECORDClass AMV_SEZIONE_RECORD = new AMV_SEZIONE_RECORDClass();
            if ( ( redirect = AMV_SEZIONE_RECORD.perform( page.getRecord("AMV_SEZIONE_RECORD")) ) != null ) result = redirect;
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AdmSezioneAction: call children actions

//AMV_SEZIONE_RECORD Record @2-415E874B
    final class AMV_SEZIONE_RECORDClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AMV_SEZIONE_RECORD Record

//AMV_SEZIONE_RECORD Record: method perform @2-979F8B8B
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AdmSezioni" + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowInsert() ) model.getChild( "Insert" ).setVisible( false );
            if ( ! model.isAllowUpdate() ) model.getChild( "Update" ).setVisible( false );
            if ( ! model.isAllowDelete() ) model.getChild( "Delete" ).setVisible( false );
//End AMV_SEZIONE_RECORD Record: method perform

//AMV_SEZIONE_RECORD Record: children actions @2-16BE6EDA
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("AMV_SEZIONE_RECORD".equals(formName)) {
                setProperties(model, Action.POST);
                if (mode != -1) { // Update mode
                    model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                    if (page.getParameter("Update") != null) {
                        if (validate()) {
                            Update12Action();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Delete") != null) {
                        Delete13Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                    if (page.getParameter("Cancel") != null) {
                        Cancel14Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                } else { // Insert mode
                    model.setMode(com.codecharge.components.Record.INSERT_MODE);
                    if (page.getParameter("Insert") != null) {
                        if (validate()) {
                            Insert11Action();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Cancel") != null) {
                        Cancel14Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                }
            }
            setProperties(model, Action.GET, true );
            read();
            readID_PADRE(model.getListBox("ID_PADRE"));
            readID_AREA(model.getListBox("ID_AREA"));
            readVISIBILITA(model.getRadioButton("VISIBILITA"));
            readZONA_ESPANSIONE(model.getRadioButton("ZONA_ESPANSIONE"));
            readZONA_TIPO(model.getRadioButton("ZONA_TIPO"));
            readZONA(model.getRadioButton("ZONA"));
            readZONA_VISIBILITA(model.getRadioButton("ZONA_VISIBILITA"));
            readZONA_FORMATO(model.getRadioButton("ZONA_FORMATO"));
//End AMV_SEZIONE_RECORD Record: children actions

//AMV_SEZIONE_RECORD Record: method perform tail @2-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AMV_SEZIONE_RECORD Record: method perform tail

//Insert Button @11-8BD2F355
        void Insert11Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Insert");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmSezioni" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            InsertAction();
        }
//End Insert Button

//Update Button @12-DAB80938
        void Update12Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Update");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmSezioni" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Update Button

//Delete Button @13-72F90373
        void Delete13Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Delete");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmSezioni" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            DeleteAction();
        }
//End Delete Button

//Cancel Button @14-3C899504
        void Cancel14Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Cancel");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmSezioni" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
        }
//End Cancel Button

//ListBoxAction @5-32E76841
        protected void readID_PADRE(com.codecharge.components.ListBox model) {

            LongField urlSZ = new LongField(null, null);
            
            try {
                urlSZ.setValue( page.getHttpGetParams().getParameter("SZ"), page.getCCSLocale().getFormat("Integer") );
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

            command.setSql( "Select id_sezione,  "
                        + "nome  "
                        + " from amv_sezioni "
                        + "where (instr( "
                        + " amv_sezione.get_path_sezione(id_sezione) "
                        + ",amv_sezione.get_path_sezione({SZ}))=0 "
                        + "   or id_sezione=0) "
                        + "and {SZ} != 0 "
                        + "union "
                        + "select id_sezione, nome  "
                        + " from amv_sezioni "
                        + "where {SZ} = 0 "
                        + "" );
            if ( urlSZ.getObjectValue() == null ) urlSZ.setValue( 0 );
            command.addParameter( "SZ", urlSZ, null );
            command.setOrder( "nome" );

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

//ListBoxAction @33-5BC97A76
        protected void readID_AREA(com.codecharge.components.ListBox model) {

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

            command.setSql( "SELECT to_number(null) ID_AREA,  "
                        + "' - -' NOME "
                        + "FROM DUAL "
                        + "UNION "
                        + "SELECT DISTINCT ID_AREA,  "
                        + "AMV_AREE.NOME "
                        + "FROM AMV_AREE WHERE  "
                        + "amv_area.get_diritto_utente('{Utente}',ID_AREA) in ('C','U','V','A') "
                        + "" );
            if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
            command.addParameter( "Utente", sesUtente, null );
            command.setOrder( "NOME" );

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

//RadioButtonAction @31-7E8C3BB0
        protected void readVISIBILITA(com.codecharge.components.RadioButton model) {
            DataObjectEvent e = new DataObjectEvent();
            e.setSql( "N;No;T;Testo;I;Immagine" );
            model.fireBeforeBuildSelectEvent(e);
            model.fireBeforeExecuteSelectEvent(e);
            model.setListOfValues( e.getSql() );
            model.fireAfterExecuteSelectEvent(e);
        }
//End RadioButtonAction

//RadioButtonAction @30-2B3C4A9F
        protected void readZONA_ESPANSIONE(com.codecharge.components.RadioButton model) {
            DataObjectEvent e = new DataObjectEvent();
            e.setSql( "S;Si;N;No" );
            model.fireBeforeBuildSelectEvent(e);
            model.fireBeforeExecuteSelectEvent(e);
            model.setListOfValues( e.getSql() );
            model.fireAfterExecuteSelectEvent(e);
        }
//End RadioButtonAction

//RadioButtonAction @27-629AB3C0
        protected void readZONA_TIPO(com.codecharge.components.RadioButton model) {
            DataObjectEvent e = new DataObjectEvent();
            e.setSql( "D;Documenti;S;Sottosezioni;E;Entrambi" );
            model.fireBeforeBuildSelectEvent(e);
            model.fireBeforeExecuteSelectEvent(e);
            model.setListOfValues( e.getSql() );
            model.fireAfterExecuteSelectEvent(e);
        }
//End RadioButtonAction

//RadioButtonAction @7-113D6385
        protected void readZONA(com.codecharge.components.RadioButton model) {
            DataObjectEvent e = new DataObjectEvent();
            e.setSql( ";Nessuna;S;Sinistra;C;Centro;D;Destra;A;Alta" );
            model.fireBeforeBuildSelectEvent(e);
            model.fireBeforeExecuteSelectEvent(e);
            model.setListOfValues( e.getSql() );
            model.fireAfterExecuteSelectEvent(e);
        }
//End RadioButtonAction

//RadioButtonAction @29-0AC576A7
        protected void readZONA_VISIBILITA(com.codecharge.components.RadioButton model) {
            DataObjectEvent e = new DataObjectEvent();
            e.setSql( "S;Sempre;H;Home Page;C;Contesto;E;Home Page/Contesto" );
            model.fireBeforeBuildSelectEvent(e);
            model.fireBeforeExecuteSelectEvent(e);
            model.setListOfValues( e.getSql() );
            model.fireAfterExecuteSelectEvent(e);
        }
//End RadioButtonAction

//RadioButtonAction @28-D67E19BB
        protected void readZONA_FORMATO(com.codecharge.components.RadioButton model) {
            DataObjectEvent e = new DataObjectEvent();
            e.setSql( "T;Testo;I;Immagine" );
            model.fireBeforeBuildSelectEvent(e);
            model.fireBeforeExecuteSelectEvent(e);
            model.setListOfValues( e.getSql() );
            model.fireAfterExecuteSelectEvent(e);
        }
//End RadioButtonAction

void read() { //AMV_SEZIONE_RECORD Record: method read @2-7F8AAE5A

//AMV_SEZIONE_RECORD Record: method read head @2-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AMV_SEZIONE_RECORD Record: method read head

//AMV_SEZIONE_RECORD Record: init DataSource @2-99E7A75E
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AMV_SEZIONE_RECORDDataObject ds = new AMV_SEZIONE_RECORDDataObject(page);
            ds.setComponent( model );
            try {
                ds.setUrlSZ( page.getHttpGetParams().getParameter("SZ"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'SZ'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'SZ'" );
            }
            try {
                ds.setExpr32( ( 0 ), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter '0'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter '0'" );
            }
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End AMV_SEZIONE_RECORD Record: init DataSource

//AMV_SEZIONE_RECORD Record: check errors @2-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End AMV_SEZIONE_RECORD Record: check errors

} //AMV_SEZIONE_RECORD Record: method read tail @2-FCB6E20C

//AMV_SEZIONE_RECORD Record: bind @2-F4C1B1F0
            public void bind(com.codecharge.components.Component model, AMV_SEZIONE_RECORDRow row ) {
                if ( model == null || row == null ) return;
                if ( this.valid ) {
                    model.getControl("NOME").setValue(row.getNOME());
                    model.getControl("DESCRIZIONE").setValue(row.getDESCRIZIONE());
                    model.getControl("ID_PADRE").setValue(row.getID_PADRE());
                    model.getControl("SEQUENZA").setValue(row.getSEQUENZA());
                    model.getControl("ID_AREA").setValue(row.getID_AREA());
                    model.getControl("VISIBILITA").setValue(row.getVISIBILITA());
                    model.getControl("ZONA_ESPANSIONE").setValue(row.getZONA_ESPANSIONE());
                    model.getControl("ZONA_TIPO").setValue(row.getZONA_TIPO());
                    model.getControl("ZONA").setValue(row.getZONA());
                    model.getControl("ZONA_VISIBILITA").setValue(row.getZONA_VISIBILITA());
                    model.getControl("ZONA_FORMATO").setValue(row.getZONA_FORMATO());
                    model.getControl("IMMAGINE").setValue(row.getIMMAGINE());
                    model.getControl("MAX_VIS").setValue(row.getMAX_VIS());
                    model.getControl("ICONA").setValue(row.getICONA());
                    model.getControl("INTESTAZIONE").setValue(row.getINTESTAZIONE());
                    model.getControl("LOGO_SX").setValue(row.getLOGO_SX());
                    model.getControl("LOGO_SX_LINK").setValue(row.getLOGO_SX_LINK());
                    model.getControl("LOGO_DX").setValue(row.getLOGO_DX());
                    model.getControl("LOGO_DX_LINK").setValue(row.getLOGO_DX_LINK());
                    model.getControl("STYLE").setValue(row.getSTYLE());
                    model.getControl("COPYRIGHT").setValue(row.getCOPYRIGHT());
                    model.getControl("ID_SEZIONE").setValue(row.getID_SEZIONE());
                }
            }
//End AMV_SEZIONE_RECORD Record: bind

//AMV_SEZIONE_RECORD Record: getRowFieldByName @2-DEF0770A
            public Object getRowFieldByName( String name, AMV_SEZIONE_RECORDRow row ) {
                Object value = null;
                if ( "NOME".equals(name) ) {
                    value = row.getNOME();
                } else if ( "DESCRIZIONE".equals(name) ) {
                    value = row.getDESCRIZIONE();
                } else if ( "ID_PADRE".equals(name) ) {
                    value = row.getID_PADRE();
                } else if ( "SEQUENZA".equals(name) ) {
                    value = row.getSEQUENZA();
                } else if ( "ID_AREA".equals(name) ) {
                    value = row.getID_AREA();
                } else if ( "VISIBILITA".equals(name) ) {
                    value = row.getVISIBILITA();
                } else if ( "ZONA_ESPANSIONE".equals(name) ) {
                    value = row.getZONA_ESPANSIONE();
                } else if ( "ZONA_TIPO".equals(name) ) {
                    value = row.getZONA_TIPO();
                } else if ( "ZONA".equals(name) ) {
                    value = row.getZONA();
                } else if ( "ZONA_VISIBILITA".equals(name) ) {
                    value = row.getZONA_VISIBILITA();
                } else if ( "ZONA_FORMATO".equals(name) ) {
                    value = row.getZONA_FORMATO();
                } else if ( "IMMAGINE".equals(name) ) {
                    value = row.getIMMAGINE();
                } else if ( "MAX_VIS".equals(name) ) {
                    value = row.getMAX_VIS();
                } else if ( "ICONA".equals(name) ) {
                    value = row.getICONA();
                } else if ( "INTESTAZIONE".equals(name) ) {
                    value = row.getINTESTAZIONE();
                } else if ( "LOGO_SX".equals(name) ) {
                    value = row.getLOGO_SX();
                } else if ( "LOGO_SX_LINK".equals(name) ) {
                    value = row.getLOGO_SX_LINK();
                } else if ( "LOGO_DX".equals(name) ) {
                    value = row.getLOGO_DX();
                } else if ( "LOGO_DX_LINK".equals(name) ) {
                    value = row.getLOGO_DX_LINK();
                } else if ( "STYLE".equals(name) ) {
                    value = row.getSTYLE();
                } else if ( "COPYRIGHT".equals(name) ) {
                    value = row.getCOPYRIGHT();
                } else if ( "ID_SEZIONE".equals(name) ) {
                    value = row.getID_SEZIONE();
                }
                return value;
            }
//End AMV_SEZIONE_RECORD Record: getRowFieldByName

void InsertAction() { //AMV_SEZIONE_RECORD Record: method insert @2-11643485

//AMV_SEZIONE_RECORD Record: method insert head @2-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End AMV_SEZIONE_RECORD Record: method insert head

//AMV_SEZIONE_RECORD Record: method insert body @2-2718922A
            if (!model.isAllowInsert()) return;
            boolean isErrors = false;
            AMV_SEZIONE_RECORDDataObject ds = new AMV_SEZIONE_RECORDDataObject(page);
            ds.setComponent( model );
            AMV_SEZIONE_RECORDRow row = new AMV_SEZIONE_RECORDRow();
            ds.setRow(row);
            row.setNOME(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "NOME" )).getValue()));
            row.setDESCRIZIONE(Utils.convertToString(((com.codecharge.components.TextArea) model.getControl( "DESCRIZIONE" )).getValue()));
            row.setID_PADRE(Utils.convertToString(((com.codecharge.components.ListBox) model.getControl( "ID_PADRE" )).getValue()));
            row.setSEQUENZA(Utils.convertToLong(((com.codecharge.components.TextBox) model.getControl( "SEQUENZA" )).getValue()));
            row.setID_AREA(Utils.convertToLong(((com.codecharge.components.ListBox) model.getControl( "ID_AREA" )).getValue()));
            row.setVISIBILITA(Utils.convertToString(((com.codecharge.components.RadioButton) model.getControl( "VISIBILITA" )).getValue()));
            row.setZONA_ESPANSIONE(Utils.convertToString(((com.codecharge.components.RadioButton) model.getControl( "ZONA_ESPANSIONE" )).getValue()));
            row.setZONA_TIPO(Utils.convertToString(((com.codecharge.components.RadioButton) model.getControl( "ZONA_TIPO" )).getValue()));
            row.setZONA(Utils.convertToString(((com.codecharge.components.RadioButton) model.getControl( "ZONA" )).getValue()));
            row.setZONA_VISIBILITA(Utils.convertToString(((com.codecharge.components.RadioButton) model.getControl( "ZONA_VISIBILITA" )).getValue()));
            row.setZONA_FORMATO(Utils.convertToString(((com.codecharge.components.RadioButton) model.getControl( "ZONA_FORMATO" )).getValue()));
            row.setIMMAGINE(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "IMMAGINE" )).getValue()));
            row.setMAX_VIS(Utils.convertToLong(((com.codecharge.components.TextBox) model.getControl( "MAX_VIS" )).getValue()));
            row.setICONA(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "ICONA" )).getValue()));
            row.setINTESTAZIONE(Utils.convertToString(((com.codecharge.components.TextArea) model.getControl( "INTESTAZIONE" )).getValue()));
            row.setLOGO_SX(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "LOGO_SX" )).getValue()));
            row.setLOGO_SX_LINK(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "LOGO_SX_LINK" )).getValue()));
            row.setLOGO_DX(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "LOGO_DX" )).getValue()));
            row.setLOGO_DX_LINK(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "LOGO_DX_LINK" )).getValue()));
            row.setSTYLE(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "STYLE" )).getValue()));
            row.setCOPYRIGHT(Utils.convertToString(((com.codecharge.components.TextArea) model.getControl( "COPYRIGHT" )).getValue()));
            row.setID_SEZIONE(Utils.convertToLong(((com.codecharge.components.Hidden) model.getControl( "ID_SEZIONE" )).getValue()));
            ds.setRow(row);
//End AMV_SEZIONE_RECORD Record: method insert body

//AMV_SEZIONE_RECORD Record: ds.insert @2-9320B03B
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
//End AMV_SEZIONE_RECORD Record: ds.insert

} //AMV_SEZIONE_RECORD Record: method insert tail @2-FCB6E20C

void UpdateAction() { //AMV_SEZIONE_RECORD Record: method update @2-5771D0AA

//AMV_SEZIONE_RECORD Record: method update head @2-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End AMV_SEZIONE_RECORD Record: method update head

//AMV_SEZIONE_RECORD Record: method update body @2-D78CF295
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            AMV_SEZIONE_RECORDDataObject ds = new AMV_SEZIONE_RECORDDataObject(page);
            ds.setComponent( model );
            AMV_SEZIONE_RECORDRow row = new AMV_SEZIONE_RECORDRow();
            ds.setRow(row);
            row.setNOME(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "NOME" )).getValue()));
            row.setDESCRIZIONE(Utils.convertToString(((com.codecharge.components.TextArea) model.getControl( "DESCRIZIONE" )).getValue()));
            row.setID_PADRE(Utils.convertToString(((com.codecharge.components.ListBox) model.getControl( "ID_PADRE" )).getValue()));
            row.setSEQUENZA(Utils.convertToLong(((com.codecharge.components.TextBox) model.getControl( "SEQUENZA" )).getValue()));
            row.setID_AREA(Utils.convertToLong(((com.codecharge.components.ListBox) model.getControl( "ID_AREA" )).getValue()));
            row.setVISIBILITA(Utils.convertToString(((com.codecharge.components.RadioButton) model.getControl( "VISIBILITA" )).getValue()));
            row.setZONA_ESPANSIONE(Utils.convertToString(((com.codecharge.components.RadioButton) model.getControl( "ZONA_ESPANSIONE" )).getValue()));
            row.setZONA_TIPO(Utils.convertToString(((com.codecharge.components.RadioButton) model.getControl( "ZONA_TIPO" )).getValue()));
            row.setZONA(Utils.convertToString(((com.codecharge.components.RadioButton) model.getControl( "ZONA" )).getValue()));
            row.setZONA_VISIBILITA(Utils.convertToString(((com.codecharge.components.RadioButton) model.getControl( "ZONA_VISIBILITA" )).getValue()));
            row.setZONA_FORMATO(Utils.convertToString(((com.codecharge.components.RadioButton) model.getControl( "ZONA_FORMATO" )).getValue()));
            row.setIMMAGINE(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "IMMAGINE" )).getValue()));
            row.setMAX_VIS(Utils.convertToLong(((com.codecharge.components.TextBox) model.getControl( "MAX_VIS" )).getValue()));
            row.setICONA(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "ICONA" )).getValue()));
            row.setINTESTAZIONE(Utils.convertToString(((com.codecharge.components.TextArea) model.getControl( "INTESTAZIONE" )).getValue()));
            row.setLOGO_SX(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "LOGO_SX" )).getValue()));
            row.setLOGO_SX_LINK(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "LOGO_SX_LINK" )).getValue()));
            row.setLOGO_DX(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "LOGO_DX" )).getValue()));
            row.setLOGO_DX_LINK(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "LOGO_DX_LINK" )).getValue()));
            row.setSTYLE(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "STYLE" )).getValue()));
            row.setCOPYRIGHT(Utils.convertToString(((com.codecharge.components.TextArea) model.getControl( "COPYRIGHT" )).getValue()));
            row.setID_SEZIONE(Utils.convertToLong(((com.codecharge.components.Hidden) model.getControl( "ID_SEZIONE" )).getValue()));
            ds.setRow(row);
            try {
                ds.setUrlSZ( page.getHttpGetParams().getParameter("SZ"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'SZ'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'SZ'" );
            }
            try {
                ds.setExpr32( ( 0 ), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter '0'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter '0'" );
            }
//End AMV_SEZIONE_RECORD Record: method update body

//AMV_SEZIONE_RECORD Record: ds.update @2-6E956EDC
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
//End AMV_SEZIONE_RECORD Record: ds.update

} //AMV_SEZIONE_RECORD Record: method update tail @2-FCB6E20C

void DeleteAction() { //AMV_SEZIONE_RECORD Record: method delete @2-11FC2E1E

//AMV_SEZIONE_RECORD Record: method delete head @2-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End AMV_SEZIONE_RECORD Record: method delete head

//AMV_SEZIONE_RECORD Record: method delete body @2-1EF011BA
            if (!model.isAllowDelete()) return;
            boolean isErrors = false;
            AMV_SEZIONE_RECORDDataObject ds = new AMV_SEZIONE_RECORDDataObject(page);
            ds.setComponent( model );
            AMV_SEZIONE_RECORDRow row = new AMV_SEZIONE_RECORDRow();
            ds.setRow(row);
            try {
                ds.setUrlSZ( page.getHttpGetParams().getParameter("SZ"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'SZ'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'SZ'" );
            }
            try {
                ds.setExpr32( ( 0 ), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter '0'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter '0'" );
            }
//End AMV_SEZIONE_RECORD Record: method delete body

//AMV_SEZIONE_RECORD Record: ds.delete @2-3584344F
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
//End AMV_SEZIONE_RECORD Record: ds.delete

} //AMV_SEZIONE_RECORD Record: method delete tail @2-FCB6E20C

//AMV_SEZIONE_RECORD Record: method validate @2-B4CADF75
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.TextBox NOME = (com.codecharge.components.TextBox) model.getChild( "NOME" );
            if (! NOME.validate()) { isControlError = true; }

            com.codecharge.components.TextArea DESCRIZIONE = (com.codecharge.components.TextArea) model.getChild( "DESCRIZIONE" );
            if (! DESCRIZIONE.validate()) { isControlError = true; }

            com.codecharge.components.ListBox ID_PADRE = (com.codecharge.components.ListBox) model.getChild( "ID_PADRE" );
            if (! ID_PADRE.validate()) { isControlError = true; }

            com.codecharge.components.TextBox SEQUENZA = (com.codecharge.components.TextBox) model.getChild( "SEQUENZA" );
            if (! SEQUENZA.validate()) { isControlError = true; }

            com.codecharge.components.ListBox ID_AREA = (com.codecharge.components.ListBox) model.getChild( "ID_AREA" );
            if (! ID_AREA.validate()) { isControlError = true; }

            com.codecharge.components.RadioButton VISIBILITA = (com.codecharge.components.RadioButton) model.getChild( "VISIBILITA" );
            if (! VISIBILITA.validate()) { isControlError = true; }

            com.codecharge.components.RadioButton ZONA_ESPANSIONE = (com.codecharge.components.RadioButton) model.getChild( "ZONA_ESPANSIONE" );
            if (! ZONA_ESPANSIONE.validate()) { isControlError = true; }

            com.codecharge.components.RadioButton ZONA_TIPO = (com.codecharge.components.RadioButton) model.getChild( "ZONA_TIPO" );
            if (! ZONA_TIPO.validate()) { isControlError = true; }

            com.codecharge.components.RadioButton ZONA = (com.codecharge.components.RadioButton) model.getChild( "ZONA" );
            if (! ZONA.validate()) { isControlError = true; }

            com.codecharge.components.RadioButton ZONA_VISIBILITA = (com.codecharge.components.RadioButton) model.getChild( "ZONA_VISIBILITA" );
            if (! ZONA_VISIBILITA.validate()) { isControlError = true; }

            com.codecharge.components.RadioButton ZONA_FORMATO = (com.codecharge.components.RadioButton) model.getChild( "ZONA_FORMATO" );
            if (! ZONA_FORMATO.validate()) { isControlError = true; }

            com.codecharge.components.TextBox IMMAGINE = (com.codecharge.components.TextBox) model.getChild( "IMMAGINE" );
            if (! IMMAGINE.validate()) { isControlError = true; }

            com.codecharge.components.TextBox MAX_VIS = (com.codecharge.components.TextBox) model.getChild( "MAX_VIS" );
            if (! MAX_VIS.validate()) { isControlError = true; }

            com.codecharge.components.TextBox ICONA = (com.codecharge.components.TextBox) model.getChild( "ICONA" );
            if (! ICONA.validate()) { isControlError = true; }

            com.codecharge.components.TextArea INTESTAZIONE = (com.codecharge.components.TextArea) model.getChild( "INTESTAZIONE" );
            if (! INTESTAZIONE.validate()) { isControlError = true; }

            com.codecharge.components.TextBox LOGO_SX = (com.codecharge.components.TextBox) model.getChild( "LOGO_SX" );
            if (! LOGO_SX.validate()) { isControlError = true; }

            com.codecharge.components.TextBox LOGO_SX_LINK = (com.codecharge.components.TextBox) model.getChild( "LOGO_SX_LINK" );
            if (! LOGO_SX_LINK.validate()) { isControlError = true; }

            com.codecharge.components.TextBox LOGO_DX = (com.codecharge.components.TextBox) model.getChild( "LOGO_DX" );
            if (! LOGO_DX.validate()) { isControlError = true; }

            com.codecharge.components.TextBox LOGO_DX_LINK = (com.codecharge.components.TextBox) model.getChild( "LOGO_DX_LINK" );
            if (! LOGO_DX_LINK.validate()) { isControlError = true; }

            com.codecharge.components.TextBox STYLE = (com.codecharge.components.TextBox) model.getChild( "STYLE" );
            if (! STYLE.validate()) { isControlError = true; }

            com.codecharge.components.TextArea COPYRIGHT = (com.codecharge.components.TextArea) model.getChild( "COPYRIGHT" );
            if (! COPYRIGHT.validate()) { isControlError = true; }

            com.codecharge.components.Hidden ID_SEZIONE = (com.codecharge.components.Hidden) model.getChild( "ID_SEZIONE" );
            if (! ID_SEZIONE.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AMV_SEZIONE_RECORD Record: method validate

//AMV_SEZIONE_RECORD Record Tail @2-FCB6E20C
    }
//End AMV_SEZIONE_RECORD Record Tail

//AdmSezione Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AdmSezione Page: method validate

//AdmSezioneAction Tail @1-FCB6E20C
}
//End AdmSezioneAction Tail

