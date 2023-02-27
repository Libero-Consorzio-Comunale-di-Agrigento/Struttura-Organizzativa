//AdmTipologieAction imports @1-98149758
package amvadm.AdmTipologie;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmTipologieAction imports

//AdmTipologieAction class @1-85875083
public class AdmTipologieAction extends Action {

//End AdmTipologieAction class

//AdmTipologieAction: method perform @1-34CE4D30
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AdmTipologieModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AdmTipologieModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AdmTipologieAction: method perform

//AdmTipologieAction: call children actions @1-6AC77FC4
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
            AMV_TIPOLOGIEClass AMV_TIPOLOGIE = new AMV_TIPOLOGIEClass();
            AMV_TIPOLOGIE.perform(page.getGrid("AMV_TIPOLOGIE"));
        }
        if (result == null) {
            AMV_TIPOLOGIE_RECORDClass AMV_TIPOLOGIE_RECORD = new AMV_TIPOLOGIE_RECORDClass();
            if ( ( redirect = AMV_TIPOLOGIE_RECORD.perform( page.getRecord("AMV_TIPOLOGIE_RECORD")) ) != null ) result = redirect;
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
//End AdmTipologieAction: call children actions

//AMV_TIPOLOGIE Grid @7-55B75097
    final class AMV_TIPOLOGIEClass {
        com.codecharge.components.Grid model;
        Event e;
//End AMV_TIPOLOGIE Grid

//AMV_TIPOLOGIE Grid: method perform @7-B48879D3
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
//End AMV_TIPOLOGIE Grid: method perform

//AMV_TIPOLOGIE Grid: method read: head @7-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End AMV_TIPOLOGIE Grid: method read: head

//AMV_TIPOLOGIE Grid: method read: init @7-C757058C
            if ( ! model.allowRead ) return true;
            AMV_TIPOLOGIEDataObject ds = new AMV_TIPOLOGIEDataObject(page);
            ds.setComponent( model );
//End AMV_TIPOLOGIE Grid: method read: init

//AMV_TIPOLOGIE Grid: set grid properties @7-C0BEF81B
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
            Hashtable sortAscColumns = new Hashtable();
            Hashtable sortDescColumns = new Hashtable();
            sortAscColumns.put( "Sorter_NOME", "NOME" );
            sortAscColumns.put( "Sorter_ZONA", "ZONA" );
            sortAscColumns.put( "Sorter_SEQUENZA", "SEQUENZA" );
            sortAscColumns.put( "Sorter_IMMAGINE", "IMMAGINE" );
            sortAscColumns.put( "Sorter_LINK", "LINK" );
            if ( ! StringUtils.isEmpty( model.getSort() ) ) {
                if ( "desc".equalsIgnoreCase(model.getDir())) {
                    if ( sortDescColumns.get( model.getSort() ) != null  && "desc".equalsIgnoreCase(model.getDir())) {
                        ds.setOrderBy( (String) sortDescColumns.get( model.getSort() ) );
                    } else {
                        ds.setOrderBy( (String) sortAscColumns.get( model.getSort() ) + " DESC " );
                    }
                } else {
                    ds.setOrderBy( (String) sortAscColumns.get( model.getSort() ) );
                }
            }
//End AMV_TIPOLOGIE Grid: set grid properties

//AMV_TIPOLOGIE Grid: retrieve data @7-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End AMV_TIPOLOGIE Grid: retrieve data

//AMV_TIPOLOGIE Grid: check errors @7-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End AMV_TIPOLOGIE Grid: check errors

//AMV_TIPOLOGIE Grid: method read: tail @7-F575E732
            return ( ! isErrors );
        }
//End AMV_TIPOLOGIE Grid: method read: tail

//AMV_TIPOLOGIE Grid: method bind @7-05A7E787
        public void bind(com.codecharge.components.Component model, AMV_TIPOLOGIERow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            AMV_TIPOLOGIERow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("NOME");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("NOME").clone();
                    c.setValue(row.getNOME());
                    hashRow.put( c.getName(), c );
                }
                ((com.codecharge.components.Link) c).getParameter("ID").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("ID").getSourceName(), row ));

                c = (com.codecharge.components.Control) hashRow.get("ZONA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("ZONA").clone();
                    c.setValue(row.getZONA());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("SEQUENZA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("SEQUENZA").clone();
                    c.setValue(row.getSEQUENZA());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("IMMAGINE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("IMMAGINE").clone();
                    c.setValue(row.getIMMAGINE());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("LINK");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("LINK").clone();
                    c.setValue(row.getLINK());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End AMV_TIPOLOGIE Grid: method bind

//AMV_TIPOLOGIE Directory: getRowFieldByName @7-C9075A33
        public Object getRowFieldByName( String name, AMV_TIPOLOGIERow row ) {
            Object value = null;
            if ( "NOME".equals(name) ) {
                value = row.getNOME();
            } else if ( "ZONA".equals(name) ) {
                value = row.getZONA();
            } else if ( "SEQUENZA".equals(name) ) {
                value = row.getSEQUENZA();
            } else if ( "IMMAGINE".equals(name) ) {
                value = row.getIMMAGINE();
            } else if ( "LINK".equals(name) ) {
                value = row.getLINK();
            } else if ( "AFCNavigator".equals(name) ) {
                value = row.getAFCNavigator();
            } else if ( "ID".equals(name) ) {
                value = row.getID();
            } else if ( "ID_TIPOLOGIA".equals(name) ) {
                value = row.getID_TIPOLOGIA();
            }
            return value;
        }
//End AMV_TIPOLOGIE Directory: getRowFieldByName

//AMV_TIPOLOGIE Grid: method validate @7-104025BA
        boolean validate() {
            return true;
        }
//End AMV_TIPOLOGIE Grid: method validate

//AMV_TIPOLOGIE Grid Tail @7-FCB6E20C
    }
//End AMV_TIPOLOGIE Grid Tail

//AMV_TIPOLOGIE_RECORD Record @22-F2EBA896
    final class AMV_TIPOLOGIE_RECORDClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AMV_TIPOLOGIE_RECORD Record

//AMV_TIPOLOGIE_RECORD Record: method perform @22-97A7195F
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AdmTipologie" + Names.ACTION_SUFFIX );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowInsert() ) model.getChild( "Insert" ).setVisible( false );
            if ( ! model.isAllowUpdate() ) model.getChild( "Update" ).setVisible( false );
            if ( ! model.isAllowDelete() ) model.getChild( "Delete" ).setVisible( false );
//End AMV_TIPOLOGIE_RECORD Record: method perform

//AMV_TIPOLOGIE_RECORD Record: children actions @22-6160A736
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("AMV_TIPOLOGIE_RECORD".equals(formName)) {
                setProperties(model, Action.POST);
                if (mode != -1) { // Update mode
                    model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                    if (page.getParameter("Update") != null) {
                        if (validate()) {
                            Update30Action();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Delete") != null) {
                        Delete31Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                    if (page.getParameter("Cancel") != null) {
                        Cancel32Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                } else { // Insert mode
                    model.setMode(com.codecharge.components.Record.INSERT_MODE);
                    if (page.getParameter("Insert") != null) {
                        if (validate()) {
                            Insert29Action();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Cancel") != null) {
                        Cancel32Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                }
            }
            setProperties(model, Action.GET, true );
            read();
            readZONA(model.getRadioButton("ZONA"));
            readZONA_VISIBILITA(model.getRadioButton("ZONA_VISIBILITA"));
            readZONA_FORMATO(model.getRadioButton("ZONA_FORMATO"));
//End AMV_TIPOLOGIE_RECORD Record: children actions

//AMV_TIPOLOGIE_RECORD Record: method perform tail @22-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AMV_TIPOLOGIE_RECORD Record: method perform tail

//Insert Button @29-2402D44D
        void Insert29Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Insert");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmTipologie" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            InsertAction();
        }
//End Insert Button

//Update Button @30-62A2FC56
        void Update30Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Update");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmTipologie" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Update Button

//Delete Button @31-EBA8EF4C
        void Delete31Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Delete");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmTipologie" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            DeleteAction();
        }
//End Delete Button

//Cancel Button @32-88BD3457
        void Cancel32Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Cancel");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmTipologie" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
        }
//End Cancel Button

//RadioButtonAction @39-113D6385
        protected void readZONA(com.codecharge.components.RadioButton model) {
            DataObjectEvent e = new DataObjectEvent();
            e.setSql( ";Nessuna;S;Sinistra;C;Centro;D;Destra;A;Alta" );
            model.fireBeforeBuildSelectEvent(e);
            model.fireBeforeExecuteSelectEvent(e);
            model.setListOfValues( e.getSql() );
            model.fireAfterExecuteSelectEvent(e);
        }
//End RadioButtonAction

//RadioButtonAction @43-A119EF6E
        protected void readZONA_VISIBILITA(com.codecharge.components.RadioButton model) {
            DataObjectEvent e = new DataObjectEvent();
            e.setSql( "S;Sempre;H;Home Page;C;Sezione" );
            model.fireBeforeBuildSelectEvent(e);
            model.fireBeforeExecuteSelectEvent(e);
            model.setListOfValues( e.getSql() );
            model.fireAfterExecuteSelectEvent(e);
        }
//End RadioButtonAction

//RadioButtonAction @40-D67E19BB
        protected void readZONA_FORMATO(com.codecharge.components.RadioButton model) {
            DataObjectEvent e = new DataObjectEvent();
            e.setSql( "T;Testo;I;Immagine" );
            model.fireBeforeBuildSelectEvent(e);
            model.fireBeforeExecuteSelectEvent(e);
            model.setListOfValues( e.getSql() );
            model.fireAfterExecuteSelectEvent(e);
        }
//End RadioButtonAction

void read() { //AMV_TIPOLOGIE_RECORD Record: method read @22-7F8AAE5A

//AMV_TIPOLOGIE_RECORD Record: method read head @22-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AMV_TIPOLOGIE_RECORD Record: method read head

//AMV_TIPOLOGIE_RECORD Record: init DataSource @22-039DFAD2
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AMV_TIPOLOGIE_RECORDDataObject ds = new AMV_TIPOLOGIE_RECORDDataObject(page);
            ds.setComponent( model );
            try {
                ds.setUrlID( page.getHttpGetParams().getParameter("ID"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID'" );
            }
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End AMV_TIPOLOGIE_RECORD Record: init DataSource

//AMV_TIPOLOGIE_RECORD Record: check errors @22-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End AMV_TIPOLOGIE_RECORD Record: check errors

} //AMV_TIPOLOGIE_RECORD Record: method read tail @22-FCB6E20C

//AMV_TIPOLOGIE_RECORD Record: bind @22-F72CAB78
            public void bind(com.codecharge.components.Component model, AMV_TIPOLOGIE_RECORDRow row ) {
                if ( model == null || row == null ) return;
                if ( this.valid ) {
                    model.getControl("NOME").setValue(row.getNOME());
                    model.getControl("DESCRIZIONE").setValue(row.getDESCRIZIONE());
                    model.getControl("SEQUENZA").setValue(row.getSEQUENZA());
                    model.getControl("LINK").setValue(row.getLINK());
                    model.getControl("ZONA").setValue(row.getZONA());
                    model.getControl("ZONA_VISIBILITA").setValue(row.getZONA_VISIBILITA());
                    model.getControl("ZONA_FORMATO").setValue(row.getZONA_FORMATO());
                    model.getControl("IMMAGINE").setValue(row.getIMMAGINE());
                    model.getControl("MAX_VIS").setValue(row.getMAX_VIS());
                    model.getControl("ICONA").setValue(row.getICONA());
                    model.getControl("ID_TIPOLOGIA").setValue(row.getID_TIPOLOGIA());
                }
            }
//End AMV_TIPOLOGIE_RECORD Record: bind

//AMV_TIPOLOGIE_RECORD Record: getRowFieldByName @22-7FE74E42
            public Object getRowFieldByName( String name, AMV_TIPOLOGIE_RECORDRow row ) {
                Object value = null;
                if ( "NOME".equals(name) ) {
                    value = row.getNOME();
                } else if ( "DESCRIZIONE".equals(name) ) {
                    value = row.getDESCRIZIONE();
                } else if ( "SEQUENZA".equals(name) ) {
                    value = row.getSEQUENZA();
                } else if ( "LINK".equals(name) ) {
                    value = row.getLINK();
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
                } else if ( "ID_TIPOLOGIA".equals(name) ) {
                    value = row.getID_TIPOLOGIA();
                }
                return value;
            }
//End AMV_TIPOLOGIE_RECORD Record: getRowFieldByName

void InsertAction() { //AMV_TIPOLOGIE_RECORD Record: method insert @22-11643485

//AMV_TIPOLOGIE_RECORD Record: method insert head @22-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End AMV_TIPOLOGIE_RECORD Record: method insert head

//AMV_TIPOLOGIE_RECORD Record: method insert body @22-9E47115C
            if (!model.isAllowInsert()) return;
            boolean isErrors = false;
            AMV_TIPOLOGIE_RECORDDataObject ds = new AMV_TIPOLOGIE_RECORDDataObject(page);
            ds.setComponent( model );
            AMV_TIPOLOGIE_RECORDRow row = new AMV_TIPOLOGIE_RECORDRow();
            ds.setRow(row);
            row.setNOME(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "NOME" )).getValue()));
            row.setDESCRIZIONE(Utils.convertToString(((com.codecharge.components.TextArea) model.getControl( "DESCRIZIONE" )).getValue()));
            row.setSEQUENZA(Utils.convertToLong(((com.codecharge.components.TextBox) model.getControl( "SEQUENZA" )).getValue()));
            row.setLINK(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "LINK" )).getValue()));
            row.setZONA(Utils.convertToString(((com.codecharge.components.RadioButton) model.getControl( "ZONA" )).getValue()));
            row.setZONA_VISIBILITA(Utils.convertToString(((com.codecharge.components.RadioButton) model.getControl( "ZONA_VISIBILITA" )).getValue()));
            row.setZONA_FORMATO(Utils.convertToString(((com.codecharge.components.RadioButton) model.getControl( "ZONA_FORMATO" )).getValue()));
            row.setIMMAGINE(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "IMMAGINE" )).getValue()));
            row.setMAX_VIS(Utils.convertToLong(((com.codecharge.components.TextBox) model.getControl( "MAX_VIS" )).getValue()));
            row.setICONA(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "ICONA" )).getValue()));
            row.setID_TIPOLOGIA(Utils.convertToLong(((com.codecharge.components.Hidden) model.getControl( "ID_TIPOLOGIA" )).getValue()));
            ds.setRow(row);
//End AMV_TIPOLOGIE_RECORD Record: method insert body

//AMV_TIPOLOGIE_RECORD Record: ds.insert @22-9320B03B
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
//End AMV_TIPOLOGIE_RECORD Record: ds.insert

} //AMV_TIPOLOGIE_RECORD Record: method insert tail @22-FCB6E20C

void UpdateAction() { //AMV_TIPOLOGIE_RECORD Record: method update @22-5771D0AA

//AMV_TIPOLOGIE_RECORD Record: method update head @22-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End AMV_TIPOLOGIE_RECORD Record: method update head

//AMV_TIPOLOGIE_RECORD Record: method update body @22-43CE8614
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            AMV_TIPOLOGIE_RECORDDataObject ds = new AMV_TIPOLOGIE_RECORDDataObject(page);
            ds.setComponent( model );
            AMV_TIPOLOGIE_RECORDRow row = new AMV_TIPOLOGIE_RECORDRow();
            ds.setRow(row);
            row.setNOME(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "NOME" )).getValue()));
            row.setDESCRIZIONE(Utils.convertToString(((com.codecharge.components.TextArea) model.getControl( "DESCRIZIONE" )).getValue()));
            row.setSEQUENZA(Utils.convertToLong(((com.codecharge.components.TextBox) model.getControl( "SEQUENZA" )).getValue()));
            row.setLINK(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "LINK" )).getValue()));
            row.setZONA(Utils.convertToString(((com.codecharge.components.RadioButton) model.getControl( "ZONA" )).getValue()));
            row.setZONA_VISIBILITA(Utils.convertToString(((com.codecharge.components.RadioButton) model.getControl( "ZONA_VISIBILITA" )).getValue()));
            row.setZONA_FORMATO(Utils.convertToString(((com.codecharge.components.RadioButton) model.getControl( "ZONA_FORMATO" )).getValue()));
            row.setIMMAGINE(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "IMMAGINE" )).getValue()));
            row.setMAX_VIS(Utils.convertToLong(((com.codecharge.components.TextBox) model.getControl( "MAX_VIS" )).getValue()));
            row.setICONA(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "ICONA" )).getValue()));
            row.setID_TIPOLOGIA(Utils.convertToLong(((com.codecharge.components.Hidden) model.getControl( "ID_TIPOLOGIA" )).getValue()));
            ds.setRow(row);
            try {
                ds.setUrlID( page.getHttpGetParams().getParameter("ID"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID'" );
            }
//End AMV_TIPOLOGIE_RECORD Record: method update body

//AMV_TIPOLOGIE_RECORD Record: ds.update @22-6E956EDC
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
//End AMV_TIPOLOGIE_RECORD Record: ds.update

} //AMV_TIPOLOGIE_RECORD Record: method update tail @22-FCB6E20C

void DeleteAction() { //AMV_TIPOLOGIE_RECORD Record: method delete @22-11FC2E1E

//AMV_TIPOLOGIE_RECORD Record: method delete head @22-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End AMV_TIPOLOGIE_RECORD Record: method delete head

//AMV_TIPOLOGIE_RECORD Record: method delete body @22-2CE0C8EC
            if (!model.isAllowDelete()) return;
            boolean isErrors = false;
            AMV_TIPOLOGIE_RECORDDataObject ds = new AMV_TIPOLOGIE_RECORDDataObject(page);
            ds.setComponent( model );
            AMV_TIPOLOGIE_RECORDRow row = new AMV_TIPOLOGIE_RECORDRow();
            ds.setRow(row);
            try {
                ds.setUrlID( page.getHttpGetParams().getParameter("ID"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID'" );
            }
//End AMV_TIPOLOGIE_RECORD Record: method delete body

//AMV_TIPOLOGIE_RECORD Record: ds.delete @22-3584344F
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
//End AMV_TIPOLOGIE_RECORD Record: ds.delete

} //AMV_TIPOLOGIE_RECORD Record: method delete tail @22-FCB6E20C

//AMV_TIPOLOGIE_RECORD Record: method validate @22-AF2F9214
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.TextBox NOME = (com.codecharge.components.TextBox) model.getChild( "NOME" );
            if (! NOME.validate()) { isControlError = true; }

            com.codecharge.components.TextArea DESCRIZIONE = (com.codecharge.components.TextArea) model.getChild( "DESCRIZIONE" );
            if (! DESCRIZIONE.validate()) { isControlError = true; }

            com.codecharge.components.TextBox SEQUENZA = (com.codecharge.components.TextBox) model.getChild( "SEQUENZA" );
            if (! SEQUENZA.validate()) { isControlError = true; }

            com.codecharge.components.TextBox LINK = (com.codecharge.components.TextBox) model.getChild( "LINK" );
            if (! LINK.validate()) { isControlError = true; }

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

            com.codecharge.components.Hidden ID_TIPOLOGIA = (com.codecharge.components.Hidden) model.getChild( "ID_TIPOLOGIA" );
            if (! ID_TIPOLOGIA.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AMV_TIPOLOGIE_RECORD Record: method validate

//AMV_TIPOLOGIE_RECORD Record Tail @22-FCB6E20C
    }
//End AMV_TIPOLOGIE_RECORD Record Tail

//AdmTipologie Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AdmTipologie Page: method validate

//AdmTipologieAction Tail @1-FCB6E20C
}
//End AdmTipologieAction Tail

