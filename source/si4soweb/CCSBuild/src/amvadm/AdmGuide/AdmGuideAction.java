//AdmGuideAction imports @1-C71694DD
package amvadm.AdmGuide;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmGuideAction imports

//AdmGuideAction class @1-79783F2D
public class AdmGuideAction extends Action {

//End AdmGuideAction class

//AdmGuideAction: method perform @1-9034CBE3
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AdmGuideModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AdmGuideModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AdmGuideAction: method perform

//AdmGuideAction: call children actions @1-05992C46
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
        if (result == null) {
            AMV_VOCIClass AMV_VOCI = new AMV_VOCIClass();
            AMV_VOCI.perform(page.getGrid("AMV_VOCI"));
        }
        if (result == null) {
            AMV_GUIDEClass AMV_GUIDE = new AMV_GUIDEClass();
            AMV_GUIDE.perform(page.getGrid("AMV_GUIDE"));
        }
        if (result == null) {
            AMV_GUIDE1Class AMV_GUIDE1 = new AMV_GUIDE1Class();
            if ( ( redirect = AMV_GUIDE1.perform( page.getRecord("AMV_GUIDE1")) ) != null ) result = redirect;
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
//End AdmGuideAction: call children actions

//AMV_VOCI Grid @41-A2A97E8E
    final class AMV_VOCIClass {
        com.codecharge.components.Grid model;
        Event e;
//End AMV_VOCI Grid

//AMV_VOCI Grid: method perform @41-B48879D3
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
//End AMV_VOCI Grid: method perform

//AMV_VOCI Grid: method read: head @41-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End AMV_VOCI Grid: method read: head

//AMV_VOCI Grid: method read: init @41-D496D64A
            if ( ! model.allowRead ) return true;
            AMV_VOCIDataObject ds = new AMV_VOCIDataObject(page);
            ds.setComponent( model );
//End AMV_VOCI Grid: method read: init

//AMV_VOCI Grid: set where parameters @41-8041AD55
            ds.setSesId( SessionStorage.getInstance(req).getAttribute("Id") );
//End AMV_VOCI Grid: set where parameters

//AMV_VOCI Grid: set grid properties @41-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End AMV_VOCI Grid: set grid properties

//AMV_VOCI Grid: retrieve data @41-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End AMV_VOCI Grid: retrieve data

//AMV_VOCI Grid: check errors @41-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End AMV_VOCI Grid: check errors

//AMV_VOCI Grid: method read: tail @41-F575E732
            return ( ! isErrors );
        }
//End AMV_VOCI Grid: method read: tail

//AMV_VOCI Grid: method bind @41-7905DFDA
        public void bind(com.codecharge.components.Component model, AMV_VOCIRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            AMV_VOCIRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("TITOLO_VOCE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("TITOLO_VOCE").clone();
                    c.setValue(row.getTITOLO_VOCE());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End AMV_VOCI Grid: method bind

//AMV_VOCI Directory: getRowFieldByName @41-6FFCD0BF
        public Object getRowFieldByName( String name, AMV_VOCIRow row ) {
            Object value = null;
            if ( "TITOLO_VOCE".equals(name) ) {
                value = row.getTITOLO_VOCE();
            } else if ( "ID_ARTICOLO".equals(name) ) {
                value = row.getID_ARTICOLO();
            } else if ( "VIS_LINK".equals(name) ) {
                value = row.getVIS_LINK();
            }
            return value;
        }
//End AMV_VOCI Directory: getRowFieldByName

//AMV_VOCI Grid: method validate @41-104025BA
        boolean validate() {
            return true;
        }
//End AMV_VOCI Grid: method validate

//AMV_VOCI Grid Tail @41-FCB6E20C
    }
//End AMV_VOCI Grid Tail

//AMV_GUIDE Grid @5-E5609C28
    final class AMV_GUIDEClass {
        com.codecharge.components.Grid model;
        Event e;
//End AMV_GUIDE Grid

//AMV_GUIDE Grid: method perform @5-B48879D3
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
//End AMV_GUIDE Grid: method perform

//AMV_GUIDE Grid: method read: head @5-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End AMV_GUIDE Grid: method read: head

//AMV_GUIDE Grid: method read: init @5-A33C2EF1
            if ( ! model.allowRead ) return true;
            AMV_GUIDEDataObject ds = new AMV_GUIDEDataObject(page);
            ds.setComponent( model );
//End AMV_GUIDE Grid: method read: init

//AMV_GUIDE Grid: set where parameters @5-BCC82353
            ds.setUrlID( page.getHttpGetParams().getParameter("ID") );
            ds.setSesId( SessionStorage.getInstance(req).getAttribute("Id") );
            ds.setSesMVCONTEXT( SessionStorage.getInstance(req).getAttribute("MVCONTEXT") );
//End AMV_GUIDE Grid: set where parameters

//AMV_GUIDE Grid: set grid properties @5-0DB21CA3
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
            Hashtable sortAscColumns = new Hashtable();
            Hashtable sortDescColumns = new Hashtable();
            sortAscColumns.put( "Sorter_TITOLO", "TITOLO" );
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
//End AMV_GUIDE Grid: set grid properties

//AMV_GUIDE Grid: retrieve data @5-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End AMV_GUIDE Grid: retrieve data

//AMV_GUIDE Grid: check errors @5-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End AMV_GUIDE Grid: check errors

//AMV_GUIDE Grid: method read: tail @5-F575E732
            return ( ! isErrors );
        }
//End AMV_GUIDE Grid: method read: tail

//AMV_GUIDE Grid: method bind @5-D4D0E9DB
        public void bind(com.codecharge.components.Component model, AMV_GUIDERow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            AMV_GUIDERow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("SEQUENZA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("SEQUENZA").clone();
                    c.setValue(row.getSEQUENZA());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("VOCE_RIF");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("VOCE_RIF").clone();
                    c.setValue(row.getVOCE_RIF());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("URL_RIF");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("URL_RIF").clone();
                    c.setValue(row.getURL_RIF());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("Modifica");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("Modifica").clone();
                    c.setValue(row.getModifica());
                    hashRow.put( c.getName(), c );
                }
                ((com.codecharge.components.Link) c).getParameter("guida").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("guida").getSourceName(), row ));
                ((com.codecharge.components.Link) c).getParameter("seq").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("seq").getSourceName(), row ));

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End AMV_GUIDE Grid: method bind

//AMV_GUIDE Directory: getRowFieldByName @5-AD7669B6
        public Object getRowFieldByName( String name, AMV_GUIDERow row ) {
            Object value = null;
            if ( "TITOLO".equals(name) ) {
                value = row.getTITOLO();
            } else if ( "SEQUENZA".equals(name) ) {
                value = row.getSEQUENZA();
            } else if ( "VOCE_RIF".equals(name) ) {
                value = row.getVOCE_RIF();
            } else if ( "URL_RIF".equals(name) ) {
                value = row.getURL_RIF();
            } else if ( "Modifica".equals(name) ) {
                value = row.getModifica();
            } else if ( "AFCNavigator".equals(name) ) {
                value = row.getAFCNavigator();
            } else if ( "guida".equals(name) ) {
                value = row.getGuida();
            } else if ( "GUIDA".equals(name) ) {
                value = row.getGUIDA();
            } else if ( "seq".equals(name) ) {
                value = row.getSeq();
            }
            return value;
        }
//End AMV_GUIDE Directory: getRowFieldByName

//AMV_GUIDE Grid: method validate @5-104025BA
        boolean validate() {
            return true;
        }
//End AMV_GUIDE Grid: method validate

//AMV_GUIDE Grid Tail @5-FCB6E20C
    }
//End AMV_GUIDE Grid Tail

//AMV_GUIDE1 Record @19-15802D9C
    final class AMV_GUIDE1Class {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AMV_GUIDE1 Record

//AMV_GUIDE1 Record: method perform @19-CAFCDC4E
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AdmGuide" + Names.ACTION_SUFFIX );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowInsert() ) model.getChild( "Insert" ).setVisible( false );
            if ( ! model.isAllowUpdate() ) model.getChild( "Update" ).setVisible( false );
            if ( ! model.isAllowDelete() ) model.getChild( "Delete" ).setVisible( false );
//End AMV_GUIDE1 Record: method perform

//AMV_GUIDE1 Record: children actions @19-1DB6CD73
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("AMV_GUIDE1".equals(formName)) {
                setProperties(model, Action.POST);
                if (mode != -1) { // Update mode
                    model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                    if (page.getParameter("Update") != null) {
                        if (validate()) {
                            Update25Action();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Delete") != null) {
                        Delete26Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                    if (page.getParameter("Cancel") != null) {
                        Cancel27Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                } else { // Insert mode
                    model.setMode(com.codecharge.components.Record.INSERT_MODE);
                    if (page.getParameter("Insert") != null) {
                        if (validate()) {
                            Insert24Action();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Cancel") != null) {
                        Cancel27Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                }
            }
            setProperties(model, Action.GET, true );
            read();
            readVOCE_MENU(model.getListBox("VOCE_MENU"));
            readVOCE_RIF(model.getListBox("VOCE_RIF"));
//End AMV_GUIDE1 Record: children actions

//AMV_GUIDE1 Record: method perform tail @19-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AMV_GUIDE1 Record: method perform tail

//Insert Button @24-71348D52
        void Insert24Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Insert");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmGuide" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            InsertAction();
        }
//End Insert Button

//Update Button @25-BAECA816
        void Update25Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Update");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmGuide" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Update Button

//Delete Button @26-DBF67550
        void Delete26Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Delete");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmGuide" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            DeleteAction();
        }
//End Delete Button

//Cancel Button @27-7F69DF72
        void Cancel27Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Cancel");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmMenu" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
        }
//End Cancel Button

//ListBoxAction @22-82A2C4B3
        protected void readVOCE_MENU(com.codecharge.components.ListBox model) {

            TextField sesProgetto = new TextField(null, null);
            
            sesProgetto.setValue( SessionStorage.getInstance(req).getAttribute("Progetto") );
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            DataObjectEvent e = new DataObjectEvent();
            e.setSource(model);
            e.setCommand(command);
            e.setConnection(ds);
            command.setOptimizeSQL(false);

            command.setSql( "SELECT VOCE,  "
                        + "TITOLO||' ('||VOCE||')' TITOLO FROM AMV_VOCI WHERE PROGETTO = '{Progetto}' "
                        + "" );
            if ( StringUtils.isEmpty( (String) sesProgetto.getObjectValue() ) ) sesProgetto.setValue( "AMV" );
            command.addParameter( "Progetto", sesProgetto, null );
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

//ListBoxAction @47-131A1230
        protected void readVOCE_RIF(com.codecharge.components.ListBox model) {

            TextField sesProgetto = new TextField(null, null);
            
            sesProgetto.setValue( SessionStorage.getInstance(req).getAttribute("Progetto") );
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            DataObjectEvent e = new DataObjectEvent();
            e.setSource(model);
            e.setCommand(command);
            e.setConnection(ds);
            command.setOptimizeSQL(false);

            command.setSql( "SELECT VOCE,  "
                        + "TITOLO||' ('||VOCE||')' TITOLO  FROM AMV_VOCI WHERE PROGETTO = '{Progetto}' "
                        + "" );
            if ( StringUtils.isEmpty( (String) sesProgetto.getObjectValue() ) ) sesProgetto.setValue( "AMV" );
            command.addParameter( "Progetto", sesProgetto, null );
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

void read() { //AMV_GUIDE1 Record: method read @19-7F8AAE5A

//AMV_GUIDE1 Record: method read head @19-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AMV_GUIDE1 Record: method read head

//AMV_GUIDE1 Record: init DataSource @19-4269B7BE
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AMV_GUIDE1DataObject ds = new AMV_GUIDE1DataObject(page);
            ds.setComponent( model );
            ds.setUrlGuida( page.getHttpGetParams().getParameter("guida") );
            try {
                ds.setUrlSeq( page.getHttpGetParams().getParameter("seq"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'seq'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'seq'" );
            }
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End AMV_GUIDE1 Record: init DataSource

//AMV_GUIDE1 Record: check errors @19-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End AMV_GUIDE1 Record: check errors

} //AMV_GUIDE1 Record: method read tail @19-FCB6E20C

//AMV_GUIDE1 Record: bind @19-9FEA7953
            public void bind(com.codecharge.components.Component model, AMV_GUIDE1Row row ) {
                if ( model == null || row == null ) return;
                if ( this.valid ) {
                    model.getControl("TITOLO").setValue(row.getTITOLO());
                    model.getControl("GUIDA").setValue(row.getGUIDA());
                    model.getControl("SEQUENZA").setValue(row.getSEQUENZA());
                    model.getControl("VOCE_MENU").setValue(row.getVOCE_MENU());
                    model.getControl("ALIAS").setValue(row.getALIAS());
                    model.getControl("VOCE_RIF").setValue(row.getVOCE_RIF());
                }
            }
//End AMV_GUIDE1 Record: bind

//AMV_GUIDE1 Record: getRowFieldByName @19-9BE020C1
            public Object getRowFieldByName( String name, AMV_GUIDE1Row row ) {
                Object value = null;
                if ( "TITOLO".equals(name) ) {
                    value = row.getTITOLO();
                } else if ( "GUIDA".equals(name) ) {
                    value = row.getGUIDA();
                } else if ( "SEQUENZA".equals(name) ) {
                    value = row.getSEQUENZA();
                } else if ( "VOCE_MENU".equals(name) ) {
                    value = row.getVOCE_MENU();
                } else if ( "ALIAS".equals(name) ) {
                    value = row.getALIAS();
                } else if ( "VOCE_RIF".equals(name) ) {
                    value = row.getVOCE_RIF();
                }
                return value;
            }
//End AMV_GUIDE1 Record: getRowFieldByName

void InsertAction() { //AMV_GUIDE1 Record: method insert @19-11643485

//AMV_GUIDE1 Record: method insert head @19-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End AMV_GUIDE1 Record: method insert head

//AMV_GUIDE1 Record: method insert body @19-BD4A6E69
            if (!model.isAllowInsert()) return;
            boolean isErrors = false;
            AMV_GUIDE1DataObject ds = new AMV_GUIDE1DataObject(page);
            ds.setComponent( model );
            AMV_GUIDE1Row row = new AMV_GUIDE1Row();
            ds.setRow(row);
            row.setTITOLO(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "TITOLO" )).getValue()));
            row.setGUIDA(Utils.convertToString(((com.codecharge.components.Hidden) model.getControl( "GUIDA" )).getValue()));
            row.setSEQUENZA(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "SEQUENZA" )).getValue()));
            row.setVOCE_MENU(Utils.convertToString(((com.codecharge.components.ListBox) model.getControl( "VOCE_MENU" )).getValue()));
            row.setALIAS(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "ALIAS" )).getValue()));
            row.setVOCE_RIF(Utils.convertToString(((com.codecharge.components.ListBox) model.getControl( "VOCE_RIF" )).getValue()));
            ds.setRow(row);
//End AMV_GUIDE1 Record: method insert body

//AMV_GUIDE1 Record: ds.insert @19-9320B03B
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
//End AMV_GUIDE1 Record: ds.insert

} //AMV_GUIDE1 Record: method insert tail @19-FCB6E20C

void UpdateAction() { //AMV_GUIDE1 Record: method update @19-5771D0AA

//AMV_GUIDE1 Record: method update head @19-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End AMV_GUIDE1 Record: method update head

//AMV_GUIDE1 Record: method update body @19-63E6683A
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            AMV_GUIDE1DataObject ds = new AMV_GUIDE1DataObject(page);
            ds.setComponent( model );
            AMV_GUIDE1Row row = new AMV_GUIDE1Row();
            ds.setRow(row);
            row.setTITOLO(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "TITOLO" )).getValue()));
            row.setGUIDA(Utils.convertToString(((com.codecharge.components.Hidden) model.getControl( "GUIDA" )).getValue()));
            row.setSEQUENZA(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "SEQUENZA" )).getValue()));
            row.setVOCE_MENU(Utils.convertToString(((com.codecharge.components.ListBox) model.getControl( "VOCE_MENU" )).getValue()));
            row.setALIAS(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "ALIAS" )).getValue()));
            row.setVOCE_RIF(Utils.convertToString(((com.codecharge.components.ListBox) model.getControl( "VOCE_RIF" )).getValue()));
            ds.setRow(row);
            ds.setUrlGuida( page.getHttpGetParams().getParameter("guida") );
            try {
                ds.setUrlSeq( page.getHttpGetParams().getParameter("seq"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'seq'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'seq'" );
            }
//End AMV_GUIDE1 Record: method update body

//AMV_GUIDE1 Record: ds.update @19-6E956EDC
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
//End AMV_GUIDE1 Record: ds.update

} //AMV_GUIDE1 Record: method update tail @19-FCB6E20C

void DeleteAction() { //AMV_GUIDE1 Record: method delete @19-11FC2E1E

//AMV_GUIDE1 Record: method delete head @19-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End AMV_GUIDE1 Record: method delete head

//AMV_GUIDE1 Record: method delete body @19-C6D915AA
            if (!model.isAllowDelete()) return;
            boolean isErrors = false;
            AMV_GUIDE1DataObject ds = new AMV_GUIDE1DataObject(page);
            ds.setComponent( model );
            AMV_GUIDE1Row row = new AMV_GUIDE1Row();
            ds.setRow(row);
            ds.setUrlGuida( page.getHttpGetParams().getParameter("guida") );
            try {
                ds.setUrlSeq( page.getHttpGetParams().getParameter("seq"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'seq'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'seq'" );
            }
//End AMV_GUIDE1 Record: method delete body

//AMV_GUIDE1 Record: ds.delete @19-3584344F
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
//End AMV_GUIDE1 Record: ds.delete

} //AMV_GUIDE1 Record: method delete tail @19-FCB6E20C

//AMV_GUIDE1 Record: method validate @19-7D151E8B
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.TextBox TITOLO = (com.codecharge.components.TextBox) model.getChild( "TITOLO" );
            if (! TITOLO.validate()) { isControlError = true; }

            com.codecharge.components.Hidden GUIDA = (com.codecharge.components.Hidden) model.getChild( "GUIDA" );
            if (! GUIDA.validate()) { isControlError = true; }

            com.codecharge.components.TextBox SEQUENZA = (com.codecharge.components.TextBox) model.getChild( "SEQUENZA" );
            if (! SEQUENZA.validate()) { isControlError = true; }

            com.codecharge.components.ListBox VOCE_MENU = (com.codecharge.components.ListBox) model.getChild( "VOCE_MENU" );
            if (! VOCE_MENU.validate()) { isControlError = true; }

            com.codecharge.components.TextBox ALIAS = (com.codecharge.components.TextBox) model.getChild( "ALIAS" );
            if (! ALIAS.validate()) { isControlError = true; }

            com.codecharge.components.ListBox VOCE_RIF = (com.codecharge.components.ListBox) model.getChild( "VOCE_RIF" );
            if (! VOCE_RIF.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AMV_GUIDE1 Record: method validate

//AMV_GUIDE1 Record Tail @19-FCB6E20C
    }
//End AMV_GUIDE1 Record Tail

//AdmGuide Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AdmGuide Page: method validate

//AdmGuideAction Tail @1-FCB6E20C
}
//End AdmGuideAction Tail

