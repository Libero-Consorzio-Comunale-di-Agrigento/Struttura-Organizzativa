//AdmRilevanzeAction imports @1-4499526F
package amvadm.AdmRilevanze;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmRilevanzeAction imports

//AdmRilevanzeAction class @1-243D42CA
public class AdmRilevanzeAction extends Action {

//End AdmRilevanzeAction class

//AdmRilevanzeAction: method perform @1-8B89F9CC
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AdmRilevanzeModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AdmRilevanzeModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AdmRilevanzeAction: method perform

//AdmRilevanzeAction: call children actions @1-4ABF02B3
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
            AMV_RILEVANZEClass AMV_RILEVANZE = new AMV_RILEVANZEClass();
            AMV_RILEVANZE.perform(page.getGrid("AMV_RILEVANZE"));
        }
        if (result == null) {
            AMV_RILEVANZE_RECORDClass AMV_RILEVANZE_RECORD = new AMV_RILEVANZE_RECORDClass();
            if ( ( redirect = AMV_RILEVANZE_RECORD.perform( page.getRecord("AMV_RILEVANZE_RECORD")) ) != null ) result = redirect;
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
//End AdmRilevanzeAction: call children actions

//AMV_RILEVANZE Grid @5-AFD5CA91
    final class AMV_RILEVANZEClass {
        com.codecharge.components.Grid model;
        Event e;
//End AMV_RILEVANZE Grid

//AMV_RILEVANZE Grid: method perform @5-B48879D3
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
//End AMV_RILEVANZE Grid: method perform

//AMV_RILEVANZE Grid: method read: head @5-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End AMV_RILEVANZE Grid: method read: head

//AMV_RILEVANZE Grid: method read: init @5-CF099C08
            if ( ! model.allowRead ) return true;
            AMV_RILEVANZEDataObject ds = new AMV_RILEVANZEDataObject(page);
            ds.setComponent( model );
//End AMV_RILEVANZE Grid: method read: init

//AMV_RILEVANZE Grid: set grid properties @5-BE5FF520
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
            Hashtable sortAscColumns = new Hashtable();
            Hashtable sortDescColumns = new Hashtable();
            sortAscColumns.put( "Sorter_NOME", "NOME" );
            sortAscColumns.put( "Sorter_IMPORTANZA", "IMPORTANZA" );
            sortAscColumns.put( "Sorter_SEQUENZA", "SEQUENZA" );
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
//End AMV_RILEVANZE Grid: set grid properties

//AMV_RILEVANZE Grid: retrieve data @5-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End AMV_RILEVANZE Grid: retrieve data

//AMV_RILEVANZE Grid: check errors @5-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End AMV_RILEVANZE Grid: check errors

//AMV_RILEVANZE Grid: method read: tail @5-F575E732
            return ( ! isErrors );
        }
//End AMV_RILEVANZE Grid: method read: tail

//AMV_RILEVANZE Grid: method bind @5-4BB9EAEA
        public void bind(com.codecharge.components.Component model, AMV_RILEVANZERow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            AMV_RILEVANZERow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("IMPORTANZA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("IMPORTANZA").clone();
                    c.setValue(row.getIMPORTANZA());
                    hashRow.put( c.getName(), c );
                }

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

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End AMV_RILEVANZE Grid: method bind

//AMV_RILEVANZE Directory: getRowFieldByName @5-28284B8F
        public Object getRowFieldByName( String name, AMV_RILEVANZERow row ) {
            Object value = null;
            if ( "NOME".equals(name) ) {
                value = row.getNOME();
            } else if ( "IMPORTANZA".equals(name) ) {
                value = row.getIMPORTANZA();
            } else if ( "ZONA".equals(name) ) {
                value = row.getZONA();
            } else if ( "SEQUENZA".equals(name) ) {
                value = row.getSEQUENZA();
            } else if ( "AFCNavigator".equals(name) ) {
                value = row.getAFCNavigator();
            } else if ( "ID".equals(name) ) {
                value = row.getID();
            } else if ( "ID_RILEVANZA".equals(name) ) {
                value = row.getID_RILEVANZA();
            }
            return value;
        }
//End AMV_RILEVANZE Directory: getRowFieldByName

//AMV_RILEVANZE Grid: method validate @5-104025BA
        boolean validate() {
            return true;
        }
//End AMV_RILEVANZE Grid: method validate

//AMV_RILEVANZE Grid Tail @5-FCB6E20C
    }
//End AMV_RILEVANZE Grid Tail

//AMV_RILEVANZE_RECORD Record @14-31766FD7
    final class AMV_RILEVANZE_RECORDClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AMV_RILEVANZE_RECORD Record

//AMV_RILEVANZE_RECORD Record: method perform @14-FA967171
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AdmRilevanze" + Names.ACTION_SUFFIX );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowInsert() ) model.getChild( "Insert" ).setVisible( false );
            if ( ! model.isAllowUpdate() ) model.getChild( "Update" ).setVisible( false );
            if ( ! model.isAllowDelete() ) model.getChild( "Delete" ).setVisible( false );
//End AMV_RILEVANZE_RECORD Record: method perform

//AMV_RILEVANZE_RECORD Record: children actions @14-26CB4444
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("AMV_RILEVANZE_RECORD".equals(formName)) {
                setProperties(model, Action.POST);
                if (mode != -1) { // Update mode
                    model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                    if (page.getParameter("Update") != null) {
                        if (validate()) {
                            Update16Action();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Delete") != null) {
                        Delete17Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                    if (page.getParameter("Cancel") != null) {
                        Cancel18Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                } else { // Insert mode
                    model.setMode(com.codecharge.components.Record.INSERT_MODE);
                    if (page.getParameter("Insert") != null) {
                        if (validate()) {
                            Insert15Action();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Cancel") != null) {
                        Cancel18Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                }
            }
            setProperties(model, Action.GET, true );
            read();
            readZONA(model.getRadioButton("ZONA"));
            readZONA_VISIBILITA(model.getRadioButton("ZONA_VISIBILITA"));
            readZONA_FORMATO(model.getRadioButton("ZONA_FORMATO"));
            readIMPORTANZA(model.getRadioButton("IMPORTANZA"));
//End AMV_RILEVANZE_RECORD Record: children actions

//AMV_RILEVANZE_RECORD Record: method perform tail @14-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AMV_RILEVANZE_RECORD Record: method perform tail

//Insert Button @15-651B41F4
        void Insert15Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Insert");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmRilevanze" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            InsertAction();
        }
//End Insert Button

//Update Button @16-3FAFDD53
        void Update16Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Update");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmRilevanze" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Update Button

//Delete Button @17-B6A5CE49
        void Delete17Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Delete");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmRilevanze" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            DeleteAction();
        }
//End Delete Button

//Cancel Button @18-577E30B8
        void Cancel18Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Cancel");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmRilevanze" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
        }
//End Cancel Button

//RadioButtonAction @26-B8CF2EE3
        protected void readZONA(com.codecharge.components.RadioButton model) {
            DataObjectEvent e = new DataObjectEvent();
            e.setSql( ";Nessuna;C;Centro" );
            model.fireBeforeBuildSelectEvent(e);
            model.fireBeforeExecuteSelectEvent(e);
            model.setListOfValues( e.getSql() );
            model.fireAfterExecuteSelectEvent(e);
        }
//End RadioButtonAction

//RadioButtonAction @30-A119EF6E
        protected void readZONA_VISIBILITA(com.codecharge.components.RadioButton model) {
            DataObjectEvent e = new DataObjectEvent();
            e.setSql( "S;Sempre;H;Home Page;C;Sezione" );
            model.fireBeforeBuildSelectEvent(e);
            model.fireBeforeExecuteSelectEvent(e);
            model.setListOfValues( e.getSql() );
            model.fireAfterExecuteSelectEvent(e);
        }
//End RadioButtonAction

//RadioButtonAction @27-D67E19BB
        protected void readZONA_FORMATO(com.codecharge.components.RadioButton model) {
            DataObjectEvent e = new DataObjectEvent();
            e.setSql( "T;Testo;I;Immagine" );
            model.fireBeforeBuildSelectEvent(e);
            model.fireBeforeExecuteSelectEvent(e);
            model.setListOfValues( e.getSql() );
            model.fireAfterExecuteSelectEvent(e);
        }
//End RadioButtonAction

//RadioButtonAction @22-601C14F2
        protected void readIMPORTANZA(com.codecharge.components.RadioButton model) {
            DataObjectEvent e = new DataObjectEvent();
            e.setSql( ";Elenco;HL;Estesa" );
            model.fireBeforeBuildSelectEvent(e);
            model.fireBeforeExecuteSelectEvent(e);
            model.setListOfValues( e.getSql() );
            model.fireAfterExecuteSelectEvent(e);
        }
//End RadioButtonAction

void read() { //AMV_RILEVANZE_RECORD Record: method read @14-7F8AAE5A

//AMV_RILEVANZE_RECORD Record: method read head @14-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AMV_RILEVANZE_RECORD Record: method read head

//AMV_RILEVANZE_RECORD Record: init DataSource @14-23FA8818
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AMV_RILEVANZE_RECORDDataObject ds = new AMV_RILEVANZE_RECORDDataObject(page);
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
//End AMV_RILEVANZE_RECORD Record: init DataSource

//AMV_RILEVANZE_RECORD Record: check errors @14-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End AMV_RILEVANZE_RECORD Record: check errors

} //AMV_RILEVANZE_RECORD Record: method read tail @14-FCB6E20C

//AMV_RILEVANZE_RECORD Record: bind @14-8B7895CD
            public void bind(com.codecharge.components.Component model, AMV_RILEVANZE_RECORDRow row ) {
                if ( model == null || row == null ) return;
                if ( this.valid ) {
                    model.getControl("NOME").setValue(row.getNOME());
                    model.getControl("SEQUENZA").setValue(row.getSEQUENZA());
                    model.getControl("ZONA").setValue(row.getZONA());
                    model.getControl("ZONA_VISIBILITA").setValue(row.getZONA_VISIBILITA());
                    model.getControl("ZONA_FORMATO").setValue(row.getZONA_FORMATO());
                    model.getControl("IMMAGINE").setValue(row.getIMMAGINE());
                    model.getControl("MAX_VIS").setValue(row.getMAX_VIS());
                    model.getControl("IMPORTANZA").setValue(row.getIMPORTANZA());
                    model.getControl("ICONA").setValue(row.getICONA());
                    model.getControl("ID_RILEVANZA").setValue(row.getID_RILEVANZA());
                }
            }
//End AMV_RILEVANZE_RECORD Record: bind

//AMV_RILEVANZE_RECORD Record: getRowFieldByName @14-58C5A8A0
            public Object getRowFieldByName( String name, AMV_RILEVANZE_RECORDRow row ) {
                Object value = null;
                if ( "NOME".equals(name) ) {
                    value = row.getNOME();
                } else if ( "SEQUENZA".equals(name) ) {
                    value = row.getSEQUENZA();
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
                } else if ( "IMPORTANZA".equals(name) ) {
                    value = row.getIMPORTANZA();
                } else if ( "ICONA".equals(name) ) {
                    value = row.getICONA();
                } else if ( "ID_RILEVANZA".equals(name) ) {
                    value = row.getID_RILEVANZA();
                }
                return value;
            }
//End AMV_RILEVANZE_RECORD Record: getRowFieldByName

void InsertAction() { //AMV_RILEVANZE_RECORD Record: method insert @14-11643485

//AMV_RILEVANZE_RECORD Record: method insert head @14-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End AMV_RILEVANZE_RECORD Record: method insert head

//AMV_RILEVANZE_RECORD Record: method insert body @14-C01BD654
            if (!model.isAllowInsert()) return;
            boolean isErrors = false;
            AMV_RILEVANZE_RECORDDataObject ds = new AMV_RILEVANZE_RECORDDataObject(page);
            ds.setComponent( model );
            AMV_RILEVANZE_RECORDRow row = new AMV_RILEVANZE_RECORDRow();
            ds.setRow(row);
            row.setNOME(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "NOME" )).getValue()));
            row.setSEQUENZA(Utils.convertToLong(((com.codecharge.components.TextBox) model.getControl( "SEQUENZA" )).getValue()));
            row.setZONA(Utils.convertToString(((com.codecharge.components.RadioButton) model.getControl( "ZONA" )).getValue()));
            row.setZONA_VISIBILITA(Utils.convertToString(((com.codecharge.components.RadioButton) model.getControl( "ZONA_VISIBILITA" )).getValue()));
            row.setZONA_FORMATO(Utils.convertToString(((com.codecharge.components.RadioButton) model.getControl( "ZONA_FORMATO" )).getValue()));
            row.setIMMAGINE(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "IMMAGINE" )).getValue()));
            row.setMAX_VIS(Utils.convertToLong(((com.codecharge.components.TextBox) model.getControl( "MAX_VIS" )).getValue()));
            row.setIMPORTANZA(Utils.convertToString(((com.codecharge.components.RadioButton) model.getControl( "IMPORTANZA" )).getValue()));
            row.setICONA(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "ICONA" )).getValue()));
            row.setID_RILEVANZA(Utils.convertToLong(((com.codecharge.components.Hidden) model.getControl( "ID_RILEVANZA" )).getValue()));
            ds.setRow(row);
//End AMV_RILEVANZE_RECORD Record: method insert body

//AMV_RILEVANZE_RECORD Record: ds.insert @14-9320B03B
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
//End AMV_RILEVANZE_RECORD Record: ds.insert

} //AMV_RILEVANZE_RECORD Record: method insert tail @14-FCB6E20C

void UpdateAction() { //AMV_RILEVANZE_RECORD Record: method update @14-5771D0AA

//AMV_RILEVANZE_RECORD Record: method update head @14-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End AMV_RILEVANZE_RECORD Record: method update head

//AMV_RILEVANZE_RECORD Record: method update body @14-F31AACE6
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            AMV_RILEVANZE_RECORDDataObject ds = new AMV_RILEVANZE_RECORDDataObject(page);
            ds.setComponent( model );
            AMV_RILEVANZE_RECORDRow row = new AMV_RILEVANZE_RECORDRow();
            ds.setRow(row);
            row.setNOME(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "NOME" )).getValue()));
            row.setSEQUENZA(Utils.convertToLong(((com.codecharge.components.TextBox) model.getControl( "SEQUENZA" )).getValue()));
            row.setZONA(Utils.convertToString(((com.codecharge.components.RadioButton) model.getControl( "ZONA" )).getValue()));
            row.setZONA_VISIBILITA(Utils.convertToString(((com.codecharge.components.RadioButton) model.getControl( "ZONA_VISIBILITA" )).getValue()));
            row.setZONA_FORMATO(Utils.convertToString(((com.codecharge.components.RadioButton) model.getControl( "ZONA_FORMATO" )).getValue()));
            row.setIMMAGINE(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "IMMAGINE" )).getValue()));
            row.setMAX_VIS(Utils.convertToLong(((com.codecharge.components.TextBox) model.getControl( "MAX_VIS" )).getValue()));
            row.setIMPORTANZA(Utils.convertToString(((com.codecharge.components.RadioButton) model.getControl( "IMPORTANZA" )).getValue()));
            row.setICONA(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "ICONA" )).getValue()));
            row.setID_RILEVANZA(Utils.convertToLong(((com.codecharge.components.Hidden) model.getControl( "ID_RILEVANZA" )).getValue()));
            ds.setRow(row);
            try {
                ds.setUrlID( page.getHttpGetParams().getParameter("ID"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID'" );
            }
//End AMV_RILEVANZE_RECORD Record: method update body

//AMV_RILEVANZE_RECORD Record: ds.update @14-6E956EDC
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
//End AMV_RILEVANZE_RECORD Record: ds.update

} //AMV_RILEVANZE_RECORD Record: method update tail @14-FCB6E20C

void DeleteAction() { //AMV_RILEVANZE_RECORD Record: method delete @14-11FC2E1E

//AMV_RILEVANZE_RECORD Record: method delete head @14-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End AMV_RILEVANZE_RECORD Record: method delete head

//AMV_RILEVANZE_RECORD Record: method delete body @14-740823FD
            if (!model.isAllowDelete()) return;
            boolean isErrors = false;
            AMV_RILEVANZE_RECORDDataObject ds = new AMV_RILEVANZE_RECORDDataObject(page);
            ds.setComponent( model );
            AMV_RILEVANZE_RECORDRow row = new AMV_RILEVANZE_RECORDRow();
            ds.setRow(row);
            try {
                ds.setUrlID( page.getHttpGetParams().getParameter("ID"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID'" );
            }
//End AMV_RILEVANZE_RECORD Record: method delete body

//AMV_RILEVANZE_RECORD Record: ds.delete @14-3584344F
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
//End AMV_RILEVANZE_RECORD Record: ds.delete

} //AMV_RILEVANZE_RECORD Record: method delete tail @14-FCB6E20C

//AMV_RILEVANZE_RECORD Record: method validate @14-0083A98B
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.TextBox NOME = (com.codecharge.components.TextBox) model.getChild( "NOME" );
            if (! NOME.validate()) { isControlError = true; }

            com.codecharge.components.TextBox SEQUENZA = (com.codecharge.components.TextBox) model.getChild( "SEQUENZA" );
            if (! SEQUENZA.validate()) { isControlError = true; }

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

            com.codecharge.components.RadioButton IMPORTANZA = (com.codecharge.components.RadioButton) model.getChild( "IMPORTANZA" );
            if (! IMPORTANZA.validate()) { isControlError = true; }

            com.codecharge.components.TextBox ICONA = (com.codecharge.components.TextBox) model.getChild( "ICONA" );
            if (! ICONA.validate()) { isControlError = true; }

            com.codecharge.components.Hidden ID_RILEVANZA = (com.codecharge.components.Hidden) model.getChild( "ID_RILEVANZA" );
            if (! ID_RILEVANZA.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AMV_RILEVANZE_RECORD Record: method validate

//AMV_RILEVANZE_RECORD Record Tail @14-FCB6E20C
    }
//End AMV_RILEVANZE_RECORD Record Tail

//AdmRilevanze Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AdmRilevanze Page: method validate

//AdmRilevanzeAction Tail @1-FCB6E20C
}
//End AdmRilevanzeAction Tail

