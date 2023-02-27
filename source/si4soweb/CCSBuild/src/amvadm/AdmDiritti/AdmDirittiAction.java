//AdmDirittiAction imports @1-22332270
package amvadm.AdmDiritti;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmDirittiAction imports

//AdmDirittiAction class @1-8994220C
public class AdmDirittiAction extends Action {

//End AdmDirittiAction class

//AdmDirittiAction: method perform @1-DB92FA13
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AdmDirittiModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AdmDirittiModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AdmDirittiAction: method perform

//AdmDirittiAction: call children actions @1-1E3D9C51
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
            AMV_DIRITTIClass AMV_DIRITTI = new AMV_DIRITTIClass();
            AMV_DIRITTI.perform(page.getGrid("AMV_DIRITTI"));
        }
        if (result == null) {
            AMV_DIRITTI1Class AMV_DIRITTI1 = new AMV_DIRITTI1Class();
            if ( ( redirect = AMV_DIRITTI1.perform( page.getRecord("AMV_DIRITTI1")) ) != null ) result = redirect;
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
//End AdmDirittiAction: call children actions

//AMV_VISTA_DOCUMENTISearch Record @31-18160039
    final class AMV_VISTA_DOCUMENTISearchClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AMV_VISTA_DOCUMENTISearch Record

//AMV_VISTA_DOCUMENTISearch Record: method perform @31-3791C297
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AmvDocumentiRicerca" + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
//End AMV_VISTA_DOCUMENTISearch Record: method perform

//AMV_VISTA_DOCUMENTISearch Record: children actions @31-46C53560
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("AMV_VISTA_DOCUMENTISearch".equals(formName)) {
                setProperties(model, Action.POST);
                    if (validate()) {
                        DoSearchSearchAction();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
            }
            setProperties(model, Action.GET, true );
            read();
            reads_AREA(model.getListBox("s_AREA"));
            reads_GRUPPO(model.getListBox("s_GRUPPO"));
            reads_DISPLAY(model.getListBox("s_DISPLAY"));
//End AMV_VISTA_DOCUMENTISearch Record: children actions

//AMV_VISTA_DOCUMENTISearch Record: method perform tail @31-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AMV_VISTA_DOCUMENTISearch Record: method perform tail

//DoSearch Button @40-E14A8E42
        void DoSearchSearchAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("DoSearch");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            for ( Iterator params = model.getChildren().iterator(); params.hasNext(); ) {
                excludeParams.add( ((com.codecharge.components.Model) params.next()).getName() );
            }
            page.setRedirectString( "AdmDiritti" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) + "&" + page.getHttpPostParams().toString( buttonModel.getExcludeParams() ) );
            buttonModel.fireOnClickEvent();
        }
//End DoSearch Button

//ListBoxAction @47-4DE3ED1E
        protected void reads_AREA(com.codecharge.components.ListBox model) {
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            DataObjectEvent e = new DataObjectEvent();
            e.setSource(model);
            e.setCommand(command);
            e.setConnection(ds);
            command.setOptimizeSQL(false);

            command.setSql( "SELECT *  "
                        + "FROM AMV_AREE" );
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

//ListBoxAction @45-7B468733
        protected void reads_GRUPPO(com.codecharge.components.ListBox model) {

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

            command.setSql( "SELECT UTENTE,  "
                        + "NOMINATIVO FROM AD4_UTENTI "
                        + "WHERE AD4_UTENTI.TIPO_UTENTE ='G' "
                        + "AND upper(UTENTE) = UTENTE "
                        + "AND UTENTE IN  "
                        + "(SELECT DISTINCT g.GRUPPO  "
                        + "   FROM AD4_UTENTI_GRUPPO g, AD4_DIRITTI_ACCESSO d, AD4_MODULI m "
                        + "  WHERE m.PROGETTO = '{Progetto}' "
                        + "    AND d.MODULO = m.MODULO "
                        + "    AND g.UTENTE = d.UTENTE) "
                        + "" );
            if ( StringUtils.isEmpty( (String) sesProgetto.getObjectValue() ) ) sesProgetto.setValue( "" );
            command.addParameter( "Progetto", sesProgetto, null );
            command.setOrder( "AD4_UTENTI.NOMINATIVO" );

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

//ListBoxAction @34-29017EE9
        protected void reads_DISPLAY(com.codecharge.components.ListBox model) {
            DataObjectEvent e = new DataObjectEvent();
            e.setSql( "10;10;20;20;50;50;100;100" );
            model.fireBeforeBuildSelectEvent(e);
            model.fireBeforeExecuteSelectEvent(e);
            model.setListOfValues( e.getSql() );
            model.fireAfterExecuteSelectEvent(e);
        }
//End ListBoxAction

void read() { //AMV_VISTA_DOCUMENTISearch Record: method read @31-7F8AAE5A

//AMV_VISTA_DOCUMENTISearch Record: method read head @31-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AMV_VISTA_DOCUMENTISearch Record: method read head

//AMV_VISTA_DOCUMENTISearch Record: init DataSource @31-3FD0FFCB
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AMV_VISTA_DOCUMENTISearchDataObject ds = new AMV_VISTA_DOCUMENTISearchDataObject(page);
            ds.setComponent( model );
            ds.setUrlS_AREA( page.getHttpGetParams().getParameter("s_AREA") );
            ds.setUrlS_GRUPPO( page.getHttpGetParams().getParameter("s_GRUPPO") );
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End AMV_VISTA_DOCUMENTISearch Record: init DataSource

//AMV_VISTA_DOCUMENTISearch Record: check errors @31-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End AMV_VISTA_DOCUMENTISearch Record: check errors

} //AMV_VISTA_DOCUMENTISearch Record: method read tail @31-FCB6E20C

//AMV_VISTA_DOCUMENTISearch Record: bind @31-3B53BC27
            public void bind(com.codecharge.components.Component model, AMV_VISTA_DOCUMENTISearchRow row ) {
                if ( model == null || row == null ) return;
                if ( this.valid ) {
                    model.getControl("s_AREA").setValue(row.getS_AREA());
                    model.getControl("s_GRUPPO").setValue(row.getS_GRUPPO());
                }
            }
//End AMV_VISTA_DOCUMENTISearch Record: bind

//AMV_VISTA_DOCUMENTISearch Record: getRowFieldByName @31-1FE0F0BD
            public Object getRowFieldByName( String name, AMV_VISTA_DOCUMENTISearchRow row ) {
                Object value = null;
                if ( "s_AREA".equals(name) ) {
                    value = row.getS_AREA();
                } else if ( "s_GRUPPO".equals(name) ) {
                    value = row.getS_GRUPPO();
                } else if ( "s_DISPLAY".equals(name) ) {
                    value = row.getS_DISPLAY();
                }
                return value;
            }
//End AMV_VISTA_DOCUMENTISearch Record: getRowFieldByName

void InsertAction() { //AMV_VISTA_DOCUMENTISearch Record: method insert @31-11643485

//AMV_VISTA_DOCUMENTISearch Record: components insert actions @31-68525650
            if (! model.hasErrors()) {
            }
//End AMV_VISTA_DOCUMENTISearch Record: components insert actions

} //AMV_VISTA_DOCUMENTISearch Record: method insert tail @31-FCB6E20C

void UpdateAction() { //AMV_VISTA_DOCUMENTISearch Record: method update @31-5771D0AA

//AMV_VISTA_DOCUMENTISearch Record: components update actions @31-68525650
            if (! model.hasErrors()) {
            }
//End AMV_VISTA_DOCUMENTISearch Record: components update actions

} //AMV_VISTA_DOCUMENTISearch Record: method update tail @31-FCB6E20C

void DeleteAction() { //AMV_VISTA_DOCUMENTISearch Record: method delete @31-11FC2E1E

//AMV_VISTA_DOCUMENTISearch Record: components delete actions @31-68525650
            if (! model.hasErrors()) {
            }
//End AMV_VISTA_DOCUMENTISearch Record: components delete actions

} //AMV_VISTA_DOCUMENTISearch Record: method delete tail @31-FCB6E20C

//AMV_VISTA_DOCUMENTISearch Record: method validate @31-CD9C4CA6
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.ListBox s_AREA = (com.codecharge.components.ListBox) model.getChild( "s_AREA" );
            if (! s_AREA.validate()) { isControlError = true; }

            com.codecharge.components.ListBox s_GRUPPO = (com.codecharge.components.ListBox) model.getChild( "s_GRUPPO" );
            if (! s_GRUPPO.validate()) { isControlError = true; }

            com.codecharge.components.ListBox s_DISPLAY = (com.codecharge.components.ListBox) model.getChild( "s_DISPLAY" );
            if (! s_DISPLAY.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AMV_VISTA_DOCUMENTISearch Record: method validate

//AMV_VISTA_DOCUMENTISearch Record Tail @31-FCB6E20C
    }
//End AMV_VISTA_DOCUMENTISearch Record Tail

//AMV_DIRITTI Grid @5-C11B00EC
    final class AMV_DIRITTIClass {
        com.codecharge.components.Grid model;
        Event e;
//End AMV_DIRITTI Grid

//AMV_DIRITTI Grid: method perform @5-B48879D3
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
//End AMV_DIRITTI Grid: method perform

//AMV_DIRITTI Grid: method read: head @5-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End AMV_DIRITTI Grid: method read: head

//AMV_DIRITTI Grid: method read: init @5-9BA574F8
            if ( ! model.allowRead ) return true;
            AMV_DIRITTIDataObject ds = new AMV_DIRITTIDataObject(page);
            ds.setComponent( model );
//End AMV_DIRITTI Grid: method read: init

//AMV_DIRITTI Grid: set where parameters @5-252D60BF
            ds.setUrlS_GRUPPO( page.getHttpGetParams().getParameter("s_GRUPPO") );
            ds.setUrlS_AREA( page.getHttpGetParams().getParameter("s_AREA") );
//End AMV_DIRITTI Grid: set where parameters

//AMV_DIRITTI Grid: set grid properties @5-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End AMV_DIRITTI Grid: set grid properties

//AMV_DIRITTI Grid: retrieve data @5-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End AMV_DIRITTI Grid: retrieve data

//AMV_DIRITTI Grid: check errors @5-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End AMV_DIRITTI Grid: check errors

//AMV_DIRITTI Grid: method read: tail @5-F575E732
            return ( ! isErrors );
        }
//End AMV_DIRITTI Grid: method read: tail

//AMV_DIRITTI Grid: method bind @5-27D03C8C
        public void bind(com.codecharge.components.Component model, AMV_DIRITTIRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            AMV_DIRITTIRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("HEADER_AREA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("HEADER_AREA").clone();
                    c.setValue(row.getHEADER_AREA());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("GRUPPO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("GRUPPO").clone();
                    c.setValue(row.getGRUPPO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("NOME_TIPOLOGIA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("NOME_TIPOLOGIA").clone();
                    c.setValue(row.getNOME_TIPOLOGIA());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("ACCESSO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("ACCESSO").clone();
                    c.setValue(row.getACCESSO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("Edit");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("Edit").clone();
                    c.setValue(row.getEdit());
                    hashRow.put( c.getName(), c );
                }
                ((com.codecharge.components.Link) c).getParameter("ID").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("ID").getSourceName(), row ));

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End AMV_DIRITTI Grid: method bind

//AMV_DIRITTI Directory: getRowFieldByName @5-77A97640
        public Object getRowFieldByName( String name, AMV_DIRITTIRow row ) {
            Object value = null;
            if ( "HEADER_AREA".equals(name) ) {
                value = row.getHEADER_AREA();
            } else if ( "GRUPPO".equals(name) ) {
                value = row.getGRUPPO();
            } else if ( "NOME_TIPOLOGIA".equals(name) ) {
                value = row.getNOME_TIPOLOGIA();
            } else if ( "ACCESSO".equals(name) ) {
                value = row.getACCESSO();
            } else if ( "Edit".equals(name) ) {
                value = row.getEdit();
            } else if ( "AFCNavigator".equals(name) ) {
                value = row.getAFCNavigator();
            } else if ( "ID".equals(name) ) {
                value = row.getID();
            } else if ( "ID_DIRITTO".equals(name) ) {
                value = row.getID_DIRITTO();
            }
            return value;
        }
//End AMV_DIRITTI Directory: getRowFieldByName

//AMV_DIRITTI Grid: method validate @5-104025BA
        boolean validate() {
            return true;
        }
//End AMV_DIRITTI Grid: method validate

//AMV_DIRITTI Grid Tail @5-FCB6E20C
    }
//End AMV_DIRITTI Grid Tail

//AMV_DIRITTI1 Record @15-089438BF
    final class AMV_DIRITTI1Class {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AMV_DIRITTI1 Record

//AMV_DIRITTI1 Record: method perform @15-4A40C3B1
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AdmDiritti" + Names.ACTION_SUFFIX );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowInsert() ) model.getChild( "Insert" ).setVisible( false );
            if ( ! model.isAllowUpdate() ) model.getChild( "Update" ).setVisible( false );
            if ( ! model.isAllowDelete() ) model.getChild( "Delete" ).setVisible( false );
//End AMV_DIRITTI1 Record: method perform

//AMV_DIRITTI1 Record: children actions @15-183D890E
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("AMV_DIRITTI1".equals(formName)) {
                setProperties(model, Action.POST);
                if (mode != -1) { // Update mode
                    model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                    if (page.getParameter("Update") != null) {
                        if (validate()) {
                            Update17Action();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Delete") != null) {
                        Delete18Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                    if (page.getParameter("Cancel") != null) {
                        Cancel19Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                } else { // Insert mode
                    model.setMode(com.codecharge.components.Record.INSERT_MODE);
                    if (page.getParameter("Insert") != null) {
                        if (validate()) {
                            Insert16Action();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Cancel") != null) {
                        Cancel19Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                }
            }
            setProperties(model, Action.GET, true );
            read();
            readID_AREA(model.getListBox("ID_AREA"));
            readID_TIPOLOGIA(model.getListBox("ID_TIPOLOGIA"));
            readGRUPPO(model.getListBox("GRUPPO"));
            readACCESSO(model.getListBox("ACCESSO"));
//End AMV_DIRITTI1 Record: children actions

//AMV_DIRITTI1 Record: method perform tail @15-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AMV_DIRITTI1 Record: method perform tail

//Insert Button @16-CEB25B32
        void Insert16Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Insert");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmDiritti" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            InsertAction();
        }
//End Insert Button

//Update Button @17-DEEA3589
        void Update17Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Update");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmDiritti" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Update Button

//Delete Button @18-01E03ED8
        void Delete18Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Delete");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmDiritti" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            DeleteAction();
        }
//End Delete Button

//Cancel Button @19-0E355E50
        void Cancel19Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Cancel");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmDiritti" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
        }
//End Cancel Button

//ListBoxAction @22-B5631522
        protected void readID_AREA(com.codecharge.components.ListBox model) {
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            DataObjectEvent e = new DataObjectEvent();
            e.setSource(model);
            e.setCommand(command);
            e.setConnection(ds);
            command.setOptimizeSQL(false);

            command.setSql( "SELECT *  "
                        + "FROM AMV_AREE" );
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

//ListBoxAction @25-F94ADE81
        protected void readID_TIPOLOGIA(com.codecharge.components.ListBox model) {
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

//ListBoxAction @23-AEDBC880
        protected void readGRUPPO(com.codecharge.components.ListBox model) {

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

            command.setSql( "SELECT UTENTE,  "
                        + "NOMINATIVO FROM AD4_UTENTI "
                        + "WHERE AD4_UTENTI.TIPO_UTENTE ='G' "
                        + "AND upper(UTENTE) = UTENTE "
                        + "AND UTENTE IN  "
                        + "(SELECT DISTINCT g.GRUPPO  "
                        + "   FROM AD4_UTENTI_GRUPPO g, AD4_DIRITTI_ACCESSO d, AD4_MODULI m "
                        + "  WHERE m.PROGETTO = '{Progetto}' "
                        + "    AND d.MODULO = m.MODULO "
                        + "    AND g.UTENTE = d.UTENTE) "
                        + "" );
            if ( StringUtils.isEmpty( (String) sesProgetto.getObjectValue() ) ) sesProgetto.setValue( "" );
            command.addParameter( "Progetto", sesProgetto, null );
            command.setOrder( "AD4_UTENTI.NOMINATIVO" );

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

//ListBoxAction @24-7EC65B4E
        protected void readACCESSO(com.codecharge.components.ListBox model) {
            DataObjectEvent e = new DataObjectEvent();
            e.setSql( "R;Lettura;C;Redazione;V;Verifica;A;Approvazione;U;Aggiornamento" );
            model.fireBeforeBuildSelectEvent(e);
            model.fireBeforeExecuteSelectEvent(e);
            model.setListOfValues( e.getSql() );
            model.fireAfterExecuteSelectEvent(e);
        }
//End ListBoxAction

void read() { //AMV_DIRITTI1 Record: method read @15-7F8AAE5A

//AMV_DIRITTI1 Record: method read head @15-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AMV_DIRITTI1 Record: method read head

//AMV_DIRITTI1 Record: init DataSource @15-6A00ABC7
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AMV_DIRITTI1DataObject ds = new AMV_DIRITTI1DataObject(page);
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
//End AMV_DIRITTI1 Record: init DataSource

//AMV_DIRITTI1 Record: check errors @15-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End AMV_DIRITTI1 Record: check errors

} //AMV_DIRITTI1 Record: method read tail @15-FCB6E20C

//AMV_DIRITTI1 Record: bind @15-B09D080C
            public void bind(com.codecharge.components.Component model, AMV_DIRITTI1Row row ) {
                if ( model == null || row == null ) return;
                if ( this.valid ) {
                    model.getControl("ID_AREA").setValue(row.getID_AREA());
                    model.getControl("ID_TIPOLOGIA").setValue(row.getID_TIPOLOGIA());
                    model.getControl("GRUPPO").setValue(row.getGRUPPO());
                    model.getControl("ACCESSO").setValue(row.getACCESSO());
                    model.getControl("ID_DIRITTO").setValue(row.getID_DIRITTO());
                }
            }
//End AMV_DIRITTI1 Record: bind

//AMV_DIRITTI1 Record: getRowFieldByName @15-A6C345B9
            public Object getRowFieldByName( String name, AMV_DIRITTI1Row row ) {
                Object value = null;
                if ( "ID_AREA".equals(name) ) {
                    value = row.getID_AREA();
                } else if ( "ID_TIPOLOGIA".equals(name) ) {
                    value = row.getID_TIPOLOGIA();
                } else if ( "GRUPPO".equals(name) ) {
                    value = row.getGRUPPO();
                } else if ( "ACCESSO".equals(name) ) {
                    value = row.getACCESSO();
                } else if ( "ID_DIRITTO".equals(name) ) {
                    value = row.getID_DIRITTO();
                }
                return value;
            }
//End AMV_DIRITTI1 Record: getRowFieldByName

void InsertAction() { //AMV_DIRITTI1 Record: method insert @15-11643485

//AMV_DIRITTI1 Record: method insert head @15-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End AMV_DIRITTI1 Record: method insert head

//AMV_DIRITTI1 Record: method insert body @15-30C84337
            if (!model.isAllowInsert()) return;
            boolean isErrors = false;
            AMV_DIRITTI1DataObject ds = new AMV_DIRITTI1DataObject(page);
            ds.setComponent( model );
            AMV_DIRITTI1Row row = new AMV_DIRITTI1Row();
            ds.setRow(row);
            row.setID_AREA(Utils.convertToLong(((com.codecharge.components.ListBox) model.getControl( "ID_AREA" )).getValue()));
            row.setID_TIPOLOGIA(Utils.convertToLong(((com.codecharge.components.ListBox) model.getControl( "ID_TIPOLOGIA" )).getValue()));
            row.setGRUPPO(Utils.convertToString(((com.codecharge.components.ListBox) model.getControl( "GRUPPO" )).getValue()));
            row.setACCESSO(Utils.convertToString(((com.codecharge.components.ListBox) model.getControl( "ACCESSO" )).getValue()));
            row.setID_DIRITTO(Utils.convertToLong(((com.codecharge.components.Hidden) model.getControl( "ID_DIRITTO" )).getValue()));
            ds.setRow(row);
//End AMV_DIRITTI1 Record: method insert body

//AMV_DIRITTI1 Record: ds.insert @15-9320B03B
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
//End AMV_DIRITTI1 Record: ds.insert

} //AMV_DIRITTI1 Record: method insert tail @15-FCB6E20C

void UpdateAction() { //AMV_DIRITTI1 Record: method update @15-5771D0AA

//AMV_DIRITTI1 Record: method update head @15-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End AMV_DIRITTI1 Record: method update head

//AMV_DIRITTI1 Record: method update body @15-1469E564
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            AMV_DIRITTI1DataObject ds = new AMV_DIRITTI1DataObject(page);
            ds.setComponent( model );
            AMV_DIRITTI1Row row = new AMV_DIRITTI1Row();
            ds.setRow(row);
            row.setID_AREA(Utils.convertToLong(((com.codecharge.components.ListBox) model.getControl( "ID_AREA" )).getValue()));
            row.setID_TIPOLOGIA(Utils.convertToLong(((com.codecharge.components.ListBox) model.getControl( "ID_TIPOLOGIA" )).getValue()));
            row.setGRUPPO(Utils.convertToString(((com.codecharge.components.ListBox) model.getControl( "GRUPPO" )).getValue()));
            row.setACCESSO(Utils.convertToString(((com.codecharge.components.ListBox) model.getControl( "ACCESSO" )).getValue()));
            row.setID_DIRITTO(Utils.convertToLong(((com.codecharge.components.Hidden) model.getControl( "ID_DIRITTO" )).getValue()));
            ds.setRow(row);
            try {
                ds.setUrlID( page.getHttpGetParams().getParameter("ID"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID'" );
            }
//End AMV_DIRITTI1 Record: method update body

//AMV_DIRITTI1 Record: ds.update @15-6E956EDC
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
//End AMV_DIRITTI1 Record: ds.update

} //AMV_DIRITTI1 Record: method update tail @15-FCB6E20C

void DeleteAction() { //AMV_DIRITTI1 Record: method delete @15-11FC2E1E

//AMV_DIRITTI1 Record: method delete head @15-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End AMV_DIRITTI1 Record: method delete head

//AMV_DIRITTI1 Record: method delete body @15-DBB5987D
            if (!model.isAllowDelete()) return;
            boolean isErrors = false;
            AMV_DIRITTI1DataObject ds = new AMV_DIRITTI1DataObject(page);
            ds.setComponent( model );
            AMV_DIRITTI1Row row = new AMV_DIRITTI1Row();
            ds.setRow(row);
            try {
                ds.setUrlID( page.getHttpGetParams().getParameter("ID"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID'" );
            }
//End AMV_DIRITTI1 Record: method delete body

//AMV_DIRITTI1 Record: ds.delete @15-3584344F
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
//End AMV_DIRITTI1 Record: ds.delete

} //AMV_DIRITTI1 Record: method delete tail @15-FCB6E20C

//AMV_DIRITTI1 Record: method validate @15-0B74CB4F
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.ListBox ID_AREA = (com.codecharge.components.ListBox) model.getChild( "ID_AREA" );
            if (! ID_AREA.validate()) { isControlError = true; }

            com.codecharge.components.ListBox ID_TIPOLOGIA = (com.codecharge.components.ListBox) model.getChild( "ID_TIPOLOGIA" );
            if (! ID_TIPOLOGIA.validate()) { isControlError = true; }

            com.codecharge.components.ListBox GRUPPO = (com.codecharge.components.ListBox) model.getChild( "GRUPPO" );
            if (! GRUPPO.validate()) { isControlError = true; }

            com.codecharge.components.ListBox ACCESSO = (com.codecharge.components.ListBox) model.getChild( "ACCESSO" );
            if (! ACCESSO.validate()) { isControlError = true; }

            com.codecharge.components.Hidden ID_DIRITTO = (com.codecharge.components.Hidden) model.getChild( "ID_DIRITTO" );
            if (! ID_DIRITTO.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AMV_DIRITTI1 Record: method validate

//AMV_DIRITTI1 Record Tail @15-FCB6E20C
    }
//End AMV_DIRITTI1 Record Tail

//AdmDiritti Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AdmDiritti Page: method validate

//AdmDirittiAction Tail @1-FCB6E20C
}
//End AdmDirittiAction Tail

