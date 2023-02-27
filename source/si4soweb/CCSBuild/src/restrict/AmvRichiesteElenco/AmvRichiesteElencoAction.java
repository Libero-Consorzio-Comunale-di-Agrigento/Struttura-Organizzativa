//AmvRichiesteElencoAction imports @1-B6CEC40D
package restrict.AmvRichiesteElenco;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvRichiesteElencoAction imports

//AmvRichiesteElencoAction class @1-DE123CC6
public class AmvRichiesteElencoAction extends Action {

//End AmvRichiesteElencoAction class

//AmvRichiesteElencoAction: method perform @1-2A8F9153
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvRichiesteElencoModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvRichiesteElencoModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvRichiesteElencoAction: method perform

//AmvRichiesteElencoAction: call children actions @1-C6D59550
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
        if ( page.getChild( "Right" ).isVisible() ) {
            page.getRequest().setAttribute("RightParent",page);
            common.Right.RightAction Right = new common.Right.RightAction();
            result = result != null ? result : Right.perform( req, resp,  context );
            page.setCookies();
        }
        if ( page.getChild( "Footer" ).isVisible() ) {
            page.getRequest().setAttribute("FooterParent",page);
            common.AmvFooter.AmvFooterAction Footer = new common.AmvFooter.AmvFooterAction();
            result = result != null ? result : Footer.perform( req, resp,  context );
            page.setCookies();
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvRichiesteElencoAction: call children actions

//AMV_VISTA_DOCUMENTISearch Record @87-18160039
    final class AMV_VISTA_DOCUMENTISearchClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AMV_VISTA_DOCUMENTISearch Record

//AMV_VISTA_DOCUMENTISearch Record: method perform @87-B273AA90
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AmvRichiesteElenco" + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
//End AMV_VISTA_DOCUMENTISearch Record: method perform

//AMV_VISTA_DOCUMENTISearch Record: children actions @87-917CCBBB
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
            reads_MODELLO(model.getListBox("s_MODELLO"));
//End AMV_VISTA_DOCUMENTISearch Record: children actions

//AMV_VISTA_DOCUMENTISearch Record: method perform tail @87-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AMV_VISTA_DOCUMENTISearch Record: method perform tail

//DoSearch Button @91-3A738C6C
        void DoSearchSearchAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("DoSearch");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            for ( Iterator params = model.getChildren().iterator(); params.hasNext(); ) {
                excludeParams.add( ((com.codecharge.components.Model) params.next()).getName() );
            }
            page.setRedirectString( "AmvRichiesteElenco" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) + "&" + page.getHttpPostParams().toString( buttonModel.getExcludeParams() ) );
            buttonModel.fireOnClickEvent();
        }
//End DoSearch Button

//ListBoxAction @89-D64FB359
        protected void reads_MODELLO(com.codecharge.components.ListBox model) {

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

            command.setSql( "select id_documento,  "
                        + "titolo "
                        + "from amv_documenti "
                        + "where tipo_testo = 'Form' "
                        + "  and amv_revisione.get_diritto('{Utente}',id_documento,  "
                        + "revisione) is not null "
                        + "  and stato in ('U','R') "
                        + "" );
            if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
            command.addParameter( "Utente", sesUtente, null );
            command.setOrder( "titolo" );

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

void read() { //AMV_VISTA_DOCUMENTISearch Record: method read @87-7F8AAE5A

//AMV_VISTA_DOCUMENTISearch Record: method read head @87-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AMV_VISTA_DOCUMENTISearch Record: method read head

} //AMV_VISTA_DOCUMENTISearch Record: method read tail @87-FCB6E20C

void InsertAction() { //AMV_VISTA_DOCUMENTISearch Record: method insert @87-11643485

//AMV_VISTA_DOCUMENTISearch Record: components insert actions @87-68525650
            if (! model.hasErrors()) {
            }
//End AMV_VISTA_DOCUMENTISearch Record: components insert actions

} //AMV_VISTA_DOCUMENTISearch Record: method insert tail @87-FCB6E20C

void UpdateAction() { //AMV_VISTA_DOCUMENTISearch Record: method update @87-5771D0AA

//AMV_VISTA_DOCUMENTISearch Record: components update actions @87-68525650
            if (! model.hasErrors()) {
            }
//End AMV_VISTA_DOCUMENTISearch Record: components update actions

} //AMV_VISTA_DOCUMENTISearch Record: method update tail @87-FCB6E20C

void DeleteAction() { //AMV_VISTA_DOCUMENTISearch Record: method delete @87-11FC2E1E

//AMV_VISTA_DOCUMENTISearch Record: components delete actions @87-68525650
            if (! model.hasErrors()) {
            }
//End AMV_VISTA_DOCUMENTISearch Record: components delete actions

} //AMV_VISTA_DOCUMENTISearch Record: method delete tail @87-FCB6E20C

//AMV_VISTA_DOCUMENTISearch Record: method validate @87-E8985DEF
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.TextBox s_TESTO = (com.codecharge.components.TextBox) model.getChild( "s_TESTO" );
            if (! s_TESTO.validate()) { isControlError = true; }

            com.codecharge.components.ListBox s_MODELLO = (com.codecharge.components.ListBox) model.getChild( "s_MODELLO" );
            if (! s_MODELLO.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AMV_VISTA_DOCUMENTISearch Record: method validate

//AMV_VISTA_DOCUMENTISearch Record Tail @87-FCB6E20C
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

//AMV_VISTA_DOCUMENTI Grid: set where parameters @5-587B8A66
            ds.setUrlS_TESTO( page.getHttpGetParams().getParameter("s_TESTO") );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            try {
                ds.setUrlIDRIC( page.getHttpGetParams().getParameter("IDRIC"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'IDRIC'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'IDRIC'" );
                return false;
            }
            ds.setUrlREVRIC( page.getHttpGetParams().getParameter("REVRIC") );
            ds.setUrlMVTD( page.getHttpGetParams().getParameter("MVTD") );
            ds.setUrlMVSZ( page.getHttpGetParams().getParameter("MVSZ") );
            try {
                ds.setUrlS_MODELLO( page.getHttpGetParams().getParameter("s_MODELLO"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 's_MODELLO'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 's_MODELLO'" );
                return false;
            }
            try {
                ds.setSesMVID( SessionStorage.getInstance(req).getAttribute("MVID"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVID'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVID'" );
                return false;
            }
//End AMV_VISTA_DOCUMENTI Grid: set where parameters

//AMV_VISTA_DOCUMENTI Grid: set grid properties @5-37318C7E
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
            Hashtable sortAscColumns = new Hashtable();
            Hashtable sortDescColumns = new Hashtable();
            sortAscColumns.put( "Sorter_DATA_INSERIMENTO", "DATA_INSERIMENTO" );
            sortAscColumns.put( "SorterMODELLO", "MODELLO" );
            sortAscColumns.put( "SorterSTATO", "STATO" );
            sortAscColumns.put( "SorterAUTORE", "NOME_AUTORE" );
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

//AMV_VISTA_DOCUMENTI Grid: method bind @5-E7A7A529
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

                c = (com.codecharge.components.Control) hashRow.get("DOCUMENTO_LINK");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("DOCUMENTO_LINK").clone();
                    c.setValue(row.getDOCUMENTO_LINK());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("DATA_INSERIMENTO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("DATA_INSERIMENTO").clone();
                    c.setValue(row.getDATA_INSERIMENTO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("MODELLO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("MODELLO").clone();
                    c.setValue(row.getMODELLO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("STATO_DOCUMENTO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("STATO_DOCUMENTO").clone();
                    c.setValue(row.getSTATO_DOCUMENTO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("FLUSSO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("FLUSSO").clone();
                    c.setValue(row.getFLUSSO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("AUTORE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("AUTORE").clone();
                    c.setValue(row.getAUTORE());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End AMV_VISTA_DOCUMENTI Grid: method bind

//AMV_VISTA_DOCUMENTI Directory: getRowFieldByName @5-A18D85B7
        public Object getRowFieldByName( String name, AMV_VISTA_DOCUMENTIRow row ) {
            Object value = null;
            if ( "DOCUMENTO_LINK".equals(name) ) {
                value = row.getDOCUMENTO_LINK();
            } else if ( "DATA_INSERIMENTO".equals(name) ) {
                value = row.getDATA_INSERIMENTO();
            } else if ( "MODELLO".equals(name) ) {
                value = row.getMODELLO();
            } else if ( "STATO_DOCUMENTO".equals(name) ) {
                value = row.getSTATO_DOCUMENTO();
            } else if ( "FLUSSO".equals(name) ) {
                value = row.getFLUSSO();
            } else if ( "AUTORE".equals(name) ) {
                value = row.getAUTORE();
            } else if ( "AFCNavigator".equals(name) ) {
                value = row.getAFCNavigator();
            } else if ( "HREF".equals(name) ) {
                value = row.getHREF();
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

//AmvRichiesteElenco Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvRichiesteElenco Page: method validate

//AmvRichiesteElencoAction Tail @1-FCB6E20C
}
//End AmvRichiesteElencoAction Tail
