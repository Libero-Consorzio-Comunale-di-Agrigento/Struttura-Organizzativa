//AmvDocumentiRicercaAction imports @1-BF22BE89
package common.AmvDocumentiRicerca;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvDocumentiRicercaAction imports

//AmvDocumentiRicercaAction class @1-C57A3812
public class AmvDocumentiRicercaAction extends Action {

//End AmvDocumentiRicercaAction class

//AmvDocumentiRicercaAction: method perform @1-C49E847F
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvDocumentiRicercaModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvDocumentiRicercaModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvDocumentiRicercaAction: method perform

//AmvDocumentiRicercaAction: call children actions @1-D2FEFC84
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
            AMV_VISTA_DOCUMENTISearchClass AMV_VISTA_DOCUMENTISearch = new AMV_VISTA_DOCUMENTISearchClass();
            if ( ( redirect = AMV_VISTA_DOCUMENTISearch.perform( page.getRecord("AMV_VISTA_DOCUMENTISearch")) ) != null ) result = redirect;
        }
        if (result == null) {
            AMV_VISTA_DOCUMENTIClass AMV_VISTA_DOCUMENTI = new AMV_VISTA_DOCUMENTIClass();
            AMV_VISTA_DOCUMENTI.perform(page.getGrid("AMV_VISTA_DOCUMENTI"));
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
//End AmvDocumentiRicercaAction: call children actions

//AMV_VISTA_DOCUMENTISearch Record @6-18160039
    final class AMV_VISTA_DOCUMENTISearchClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AMV_VISTA_DOCUMENTISearch Record

//AMV_VISTA_DOCUMENTISearch Record: method perform @6-3791C297
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AmvDocumentiRicerca" + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
//End AMV_VISTA_DOCUMENTISearch Record: method perform

//AMV_VISTA_DOCUMENTISearch Record: children actions @6-30DE82A4
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("AMV_VISTA_DOCUMENTISearch".equals(formName)) {
                setProperties(model, Action.POST);
                if (mode != -1) { // Update mode
                    model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                    if (page.getParameter("RicercaAvanzata") != null) {
                        if (validate()) {
                            RicercaAvanzataAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("DoSearch") != null) {
                        if (validate()) {
                            DoSearchSearchAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                } else { // Insert mode
                    model.setMode(com.codecharge.components.Record.INSERT_MODE);
                    if (page.getParameter("RicercaAvanzata") != null) {
                        if (validate()) {
                            RicercaAvanzataAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("DoSearch") != null) {
                        if (validate()) {
                            DoSearchSearchAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                }
            }
            setProperties(model, Action.GET, true );
            read();
            reads_DISPLAY(model.getListBox("s_DISPLAY"));
            reads_ID_SEZIONE(model.getListBox("s_ID_SEZIONE"));
            reads_ID_TIPOLOGIA(model.getListBox("s_ID_TIPOLOGIA"));
            reads_ID_CATEGORIA(model.getListBox("s_ID_CATEGORIA"));
            reads_ID_ARGOMENTO(model.getListBox("s_ID_ARGOMENTO"));
//End AMV_VISTA_DOCUMENTISearch Record: children actions

//AMV_VISTA_DOCUMENTISearch Record: method perform tail @6-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AMV_VISTA_DOCUMENTISearch Record: method perform tail

//RicercaAvanzata Button @89-E455597D
        void RicercaAvanzataAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("RicercaAvanzata");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AmvDocumentiRicerca" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
        }
//End RicercaAvanzata Button

//DoSearch Button @7-55D767F8
        void DoSearchSearchAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("DoSearch");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            for ( Iterator params = model.getChildren().iterator(); params.hasNext(); ) {
                excludeParams.add( ((com.codecharge.components.Model) params.next()).getName() );
            }
            page.setRedirectString( "AmvDocumentiRicerca" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) + "&" + page.getHttpPostParams().toString( buttonModel.getExcludeParams() ) );
            buttonModel.fireOnClickEvent();
        }
//End DoSearch Button

//ListBoxAction @75-29017EE9
        protected void reads_DISPLAY(com.codecharge.components.ListBox model) {
            DataObjectEvent e = new DataObjectEvent();
            e.setSql( "10;10;20;20;50;50;100;100" );
            model.fireBeforeBuildSelectEvent(e);
            model.fireBeforeExecuteSelectEvent(e);
            model.setListOfValues( e.getSql() );
            model.fireAfterExecuteSelectEvent(e);
        }
//End ListBoxAction

//ListBoxAction @72-5CDD2334
        protected void reads_ID_SEZIONE(com.codecharge.components.ListBox model) {
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            DataObjectEvent e = new DataObjectEvent();
            e.setSource(model);
            e.setCommand(command);
            e.setConnection(ds);
            command.setOptimizeSQL(false);

            command.setSql( "SELECT *  "
                        + "FROM AMV_SEZIONI" );
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

//ListBoxAction @8-6196F56B
        protected void reads_ID_TIPOLOGIA(com.codecharge.components.ListBox model) {
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            DataObjectEvent e = new DataObjectEvent();
            e.setSource(model);
            e.setCommand(command);
            e.setConnection(ds);
            command.setOptimizeSQL(false);

            command.setSql( "SELECT *  "
                        + "FROM AMV_TIPOLOGIE" );
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

//ListBoxAction @90-437DAF91
        protected void reads_ID_CATEGORIA(com.codecharge.components.ListBox model) {
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            DataObjectEvent e = new DataObjectEvent();
            e.setSource(model);
            e.setCommand(command);
            e.setConnection(ds);
            command.setOptimizeSQL(false);

            command.setSql( "SELECT *  "
                        + "FROM AMV_CATEGORIE" );
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

//ListBoxAction @91-8631E07C
        protected void reads_ID_ARGOMENTO(com.codecharge.components.ListBox model) {
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            DataObjectEvent e = new DataObjectEvent();
            e.setSource(model);
            e.setCommand(command);
            e.setConnection(ds);
            command.setOptimizeSQL(false);

            command.setSql( "SELECT *  "
                        + "FROM AMV_ARGOMENTI" );
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

void read() { //AMV_VISTA_DOCUMENTISearch Record: method read @6-7F8AAE5A

//AMV_VISTA_DOCUMENTISearch Record: method read head @6-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AMV_VISTA_DOCUMENTISearch Record: method read head

//AMV_VISTA_DOCUMENTISearch Record: init DataSource @6-353DD3AA
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AMV_VISTA_DOCUMENTISearchDataObject ds = new AMV_VISTA_DOCUMENTISearchDataObject(page);
            ds.setComponent( model );
            ds.setUrlMVTD( page.getHttpGetParams().getParameter("MVTD") );
            ds.setUrlS_ID_TIPOLOGIA( page.getHttpGetParams().getParameter("s_ID_TIPOLOGIA") );
            ds.setUrlS_ID_CATEGORIA( page.getHttpGetParams().getParameter("s_ID_CATEGORIA") );
            ds.setUrlID_CATEGORIA( page.getHttpGetParams().getParameter("ID_CATEGORIA") );
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End AMV_VISTA_DOCUMENTISearch Record: init DataSource

//AMV_VISTA_DOCUMENTISearch Record: check errors @6-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End AMV_VISTA_DOCUMENTISearch Record: check errors

} //AMV_VISTA_DOCUMENTISearch Record: method read tail @6-FCB6E20C

//AMV_VISTA_DOCUMENTISearch Record: bind @6-190A4847
            public void bind(com.codecharge.components.Component model, AMV_VISTA_DOCUMENTISearchRow row ) {
                if ( model == null || row == null ) return;
                if ( this.valid ) {
                    model.getControl("s_ID_TIPOLOGIA").setValue(row.getS_ID_TIPOLOGIA());
                }
            }
//End AMV_VISTA_DOCUMENTISearch Record: bind

//AMV_VISTA_DOCUMENTISearch Record: getRowFieldByName @6-B73A4FA4
            public Object getRowFieldByName( String name, AMV_VISTA_DOCUMENTISearchRow row ) {
                Object value = null;
                if ( "s_TESTO".equals(name) ) {
                    value = row.getS_TESTO();
                } else if ( "s_CERCA_TESTO".equals(name) ) {
                    value = row.getS_CERCA_TESTO();
                } else if ( "s_DISPLAY".equals(name) ) {
                    value = row.getS_DISPLAY();
                } else if ( "s_ID_SEZIONE".equals(name) ) {
                    value = row.getS_ID_SEZIONE();
                } else if ( "s_ID_TIPOLOGIA".equals(name) ) {
                    value = row.getS_ID_TIPOLOGIA();
                } else if ( "s_ID_CATEGORIA".equals(name) ) {
                    value = row.getS_ID_CATEGORIA();
                } else if ( "s_ID_ARGOMENTO".equals(name) ) {
                    value = row.getS_ID_ARGOMENTO();
                }
                return value;
            }
//End AMV_VISTA_DOCUMENTISearch Record: getRowFieldByName

void InsertAction() { //AMV_VISTA_DOCUMENTISearch Record: method insert @6-11643485

//AMV_VISTA_DOCUMENTISearch Record: components insert actions @6-68525650
            if (! model.hasErrors()) {
            }
//End AMV_VISTA_DOCUMENTISearch Record: components insert actions

} //AMV_VISTA_DOCUMENTISearch Record: method insert tail @6-FCB6E20C

void UpdateAction() { //AMV_VISTA_DOCUMENTISearch Record: method update @6-5771D0AA

//AMV_VISTA_DOCUMENTISearch Record: components update actions @6-68525650
            if (! model.hasErrors()) {
            }
//End AMV_VISTA_DOCUMENTISearch Record: components update actions

} //AMV_VISTA_DOCUMENTISearch Record: method update tail @6-FCB6E20C

void DeleteAction() { //AMV_VISTA_DOCUMENTISearch Record: method delete @6-11FC2E1E

//AMV_VISTA_DOCUMENTISearch Record: components delete actions @6-68525650
            if (! model.hasErrors()) {
            }
//End AMV_VISTA_DOCUMENTISearch Record: components delete actions

} //AMV_VISTA_DOCUMENTISearch Record: method delete tail @6-FCB6E20C

//AMV_VISTA_DOCUMENTISearch Record: method validate @6-39055DC6
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.TextBox s_TESTO = (com.codecharge.components.TextBox) model.getChild( "s_TESTO" );
            if (! s_TESTO.validate()) { isControlError = true; }

            com.codecharge.components.ListBox s_DISPLAY = (com.codecharge.components.ListBox) model.getChild( "s_DISPLAY" );
            if (! s_DISPLAY.validate()) { isControlError = true; }

            com.codecharge.components.ListBox s_ID_SEZIONE = (com.codecharge.components.ListBox) model.getChild( "s_ID_SEZIONE" );
            if (! s_ID_SEZIONE.validate()) { isControlError = true; }

            com.codecharge.components.ListBox s_ID_TIPOLOGIA = (com.codecharge.components.ListBox) model.getChild( "s_ID_TIPOLOGIA" );
            if (! s_ID_TIPOLOGIA.validate()) { isControlError = true; }

            com.codecharge.components.ListBox s_ID_CATEGORIA = (com.codecharge.components.ListBox) model.getChild( "s_ID_CATEGORIA" );
            if (! s_ID_CATEGORIA.validate()) { isControlError = true; }

            com.codecharge.components.ListBox s_ID_ARGOMENTO = (com.codecharge.components.ListBox) model.getChild( "s_ID_ARGOMENTO" );
            if (! s_ID_ARGOMENTO.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AMV_VISTA_DOCUMENTISearch Record: method validate

//AMV_VISTA_DOCUMENTISearch Record Tail @6-FCB6E20C
    }
//End AMV_VISTA_DOCUMENTISearch Record Tail

//AMV_VISTA_DOCUMENTI Grid @5-DC9A4FE9
    final class AMV_VISTA_DOCUMENTIClass {
        com.codecharge.components.Grid model;
        Event e;
//End AMV_VISTA_DOCUMENTI Grid

//AMV_VISTA_DOCUMENTI Grid: method perform @5-B48879D3
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
//End AMV_VISTA_DOCUMENTI Grid: method perform

//AMV_VISTA_DOCUMENTI Grid: method read: head @5-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End AMV_VISTA_DOCUMENTI Grid: method read: head

//AMV_VISTA_DOCUMENTI Grid: method read: init @5-B1FFABD9
            if ( ! model.allowRead ) return true;
            AMV_VISTA_DOCUMENTIDataObject ds = new AMV_VISTA_DOCUMENTIDataObject(page);
            ds.setComponent( model );
//End AMV_VISTA_DOCUMENTI Grid: method read: init

//AMV_VISTA_DOCUMENTI Grid: set where parameters @5-E9AB4823
            ds.setUrlS_ID_TIPOLOGIA( page.getHttpGetParams().getParameter("s_ID_TIPOLOGIA") );
            ds.setUrlS_TESTO( page.getHttpGetParams().getParameter("s_TESTO") );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setUrlS_CERCA_TESTO( page.getHttpGetParams().getParameter("s_CERCA_TESTO") );
            ds.setUrlS_ID_SEZIONE( page.getHttpGetParams().getParameter("s_ID_SEZIONE") );
            ds.setUrlS_ID_CATEGORIA( page.getHttpGetParams().getParameter("s_ID_CATEGORIA") );
            ds.setUrlS_ID_ARGOMENTO( page.getHttpGetParams().getParameter("s_ID_ARGOMENTO") );
            ds.setUrlMVTD( page.getHttpGetParams().getParameter("MVTD") );
            ds.setUrlID_CATEGORIA( page.getHttpGetParams().getParameter("ID_CATEGORIA") );
//End AMV_VISTA_DOCUMENTI Grid: set where parameters

//AMV_VISTA_DOCUMENTI Grid: set grid properties @5-D79495B9
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
            Hashtable sortAscColumns = new Hashtable();
            Hashtable sortDescColumns = new Hashtable();
            sortAscColumns.put( "Sorter_TITOLO", "TITOLO" );
            sortAscColumns.put( "SorterMODIFICA", "DATA_ULTIMA_MODIFICA" );
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
//End AMV_VISTA_DOCUMENTI Grid: set grid properties

//AMV_VISTA_DOCUMENTI Grid: retrieve data @5-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End AMV_VISTA_DOCUMENTI Grid: retrieve data

//AMV_VISTA_DOCUMENTI Grid: check errors @5-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End AMV_VISTA_DOCUMENTI Grid: check errors

//AMV_VISTA_DOCUMENTI Grid: method read: tail @5-F575E732
            return ( ! isErrors );
        }
//End AMV_VISTA_DOCUMENTI Grid: method read: tail

//AMV_VISTA_DOCUMENTI Grid: method bind @5-127F34F6
        public void bind(com.codecharge.components.Component model, AMV_VISTA_DOCUMENTIRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            AMV_VISTA_DOCUMENTIRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("TITOLO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("TITOLO").clone();
                    c.setValue(row.getTITOLO());
                    hashRow.put( c.getName(), c );
                }
                ((com.codecharge.components.Link) c).getParameter("ID").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("ID").getSourceName(), row ));
                ((com.codecharge.components.Link) c).getParameter("REV").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("REV").getSourceName(), row ));
                ((com.codecharge.components.Link) c).getParameter("MVTD").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("MVTD").getSourceName(), row ));
                ((com.codecharge.components.Link) c).getParameter("MVSZ").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("MVSZ").getSourceName(), row ));

                c = (com.codecharge.components.Control) hashRow.get("SEZIONE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("SEZIONE").clone();
                    c.setValue(row.getSEZIONE());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("DATA_ULTIMA_MODIFICA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("DATA_ULTIMA_MODIFICA").clone();
                    c.setValue(row.getDATA_ULTIMA_MODIFICA());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("MODIFICA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("MODIFICA").clone();
                    c.setValue(row.getMODIFICA());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End AMV_VISTA_DOCUMENTI Grid: method bind

//AMV_VISTA_DOCUMENTI Directory: getRowFieldByName @5-6D3154F9
        public Object getRowFieldByName( String name, AMV_VISTA_DOCUMENTIRow row ) {
            Object value = null;
            if ( "TITOLO".equals(name) ) {
                value = row.getTITOLO();
            } else if ( "SEZIONE".equals(name) ) {
                value = row.getSEZIONE();
            } else if ( "DATA_ULTIMA_MODIFICA".equals(name) ) {
                value = row.getDATA_ULTIMA_MODIFICA();
            } else if ( "MODIFICA".equals(name) ) {
                value = row.getMODIFICA();
            } else if ( "AFCNavigator".equals(name) ) {
                value = row.getAFCNavigator();
            } else if ( "ID".equals(name) ) {
                value = row.getID();
            } else if ( "ID_DOCUMENTO".equals(name) ) {
                value = row.getID_DOCUMENTO();
            } else if ( "REV".equals(name) ) {
                value = row.getREV();
            } else if ( "REVISIONE".equals(name) ) {
                value = row.getREVISIONE();
            } else if ( "MVTD".equals(name) ) {
                value = row.getMVTD();
            } else if ( "ID_TIPOLOGIA".equals(name) ) {
                value = row.getID_TIPOLOGIA();
            } else if ( "MVSZ".equals(name) ) {
                value = row.getMVSZ();
            } else if ( "ID_SEZIONE".equals(name) ) {
                value = row.getID_SEZIONE();
            }
            return value;
        }
//End AMV_VISTA_DOCUMENTI Directory: getRowFieldByName

//AMV_VISTA_DOCUMENTI Grid: method validate @5-104025BA
        boolean validate() {
            return true;
        }
//End AMV_VISTA_DOCUMENTI Grid: method validate

//AMV_VISTA_DOCUMENTI Grid Tail @5-FCB6E20C
    }
//End AMV_VISTA_DOCUMENTI Grid Tail

//AmvDocumentiRicerca Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvDocumentiRicerca Page: method validate

//AmvDocumentiRicercaAction Tail @1-FCB6E20C
}
//End AmvDocumentiRicercaAction Tail

