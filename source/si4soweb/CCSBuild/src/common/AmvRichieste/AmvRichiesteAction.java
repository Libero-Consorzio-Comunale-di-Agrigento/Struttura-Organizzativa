//AmvRichiesteAction imports @1-C5E05387
package common.AmvRichieste;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvRichiesteAction imports

//AmvRichiesteAction class @1-5B3542F2
public class AmvRichiesteAction extends Action {

//End AmvRichiesteAction class

//AmvRichiesteAction: method perform @1-CBBB9BCB
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvRichiesteModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvRichiesteModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvRichiesteAction: method perform

//AmvRichiesteAction: call children actions @1-6124737C
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
            common.Footer.FooterAction Footer = new common.Footer.FooterAction();
            result = result != null ? result : Footer.perform( req, resp,  context );
            page.setCookies();
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvRichiesteAction: call children actions

//AMV_VISTA_DOCUMENTISearch Record @6-18160039
    final class AMV_VISTA_DOCUMENTISearchClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AMV_VISTA_DOCUMENTISearch Record

//AMV_VISTA_DOCUMENTISearch Record: method perform @6-78933C87
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AmvRichieste" + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
//End AMV_VISTA_DOCUMENTISearch Record: method perform

//AMV_VISTA_DOCUMENTISearch Record: children actions @6-82C46EB0
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
//End AMV_VISTA_DOCUMENTISearch Record: children actions

//AMV_VISTA_DOCUMENTISearch Record: method perform tail @6-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AMV_VISTA_DOCUMENTISearch Record: method perform tail

//DoSearch Button @7-54B0C263
        void DoSearchSearchAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("DoSearch");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            for ( Iterator params = model.getChildren().iterator(); params.hasNext(); ) {
                excludeParams.add( ((com.codecharge.components.Model) params.next()).getName() );
            }
            page.setRedirectString( "AmvRichieste" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) + "&" + page.getHttpPostParams().toString( buttonModel.getExcludeParams() ) );
            buttonModel.fireOnClickEvent();
        }
//End DoSearch Button

void read() { //AMV_VISTA_DOCUMENTISearch Record: method read @6-7F8AAE5A

//AMV_VISTA_DOCUMENTISearch Record: method read head @6-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AMV_VISTA_DOCUMENTISearch Record: method read head

//AMV_VISTA_DOCUMENTISearch Record: init DataSource @6-5DCF65D6
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AMV_VISTA_DOCUMENTISearchDataObject ds = new AMV_VISTA_DOCUMENTISearchDataObject(page);
            ds.setComponent( model );
            try {
                ds.setUrlIDRIC( page.getHttpGetParams().getParameter("IDRIC"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'IDRIC'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'IDRIC'" );
            }
            try {
                ds.setUrlREVRIC( page.getHttpGetParams().getParameter("REVRIC"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'REVRIC'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'REVRIC'" );
            }
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

//AMV_VISTA_DOCUMENTISearch Record: bind @6-4EEF0F58
            public void bind(com.codecharge.components.Component model, AMV_VISTA_DOCUMENTISearchRow row ) {
                if ( model == null || row == null ) return;
                model.getControl("NOME_TIPOLOGIA").setValue(row.getNOME_TIPOLOGIA());
                model.getControl("TITOLO").setValue(row.getTITOLO());
                if ( this.valid ) {
                }
            }
//End AMV_VISTA_DOCUMENTISearch Record: bind

//AMV_VISTA_DOCUMENTISearch Record: getRowFieldByName @6-391E888D
            public Object getRowFieldByName( String name, AMV_VISTA_DOCUMENTISearchRow row ) {
                Object value = null;
                if ( "NOME_TIPOLOGIA".equals(name) ) {
                    value = row.getNOME_TIPOLOGIA();
                } else if ( "TITOLO".equals(name) ) {
                    value = row.getTITOLO();
                } else if ( "s_TESTO".equals(name) ) {
                    value = row.getS_TESTO();
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

//AMV_VISTA_DOCUMENTISearch Record: method validate @6-7F9B9EBA
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.TextBox s_TESTO = (com.codecharge.components.TextBox) model.getChild( "s_TESTO" );
            if (! s_TESTO.validate()) { isControlError = true; }
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

//AMV_VISTA_DOCUMENTI Grid: set where parameters @5-A1A79683
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
//End AMV_VISTA_DOCUMENTI Grid: set where parameters

//AMV_VISTA_DOCUMENTI Grid: set grid properties @5-BF3AF0AC
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
            Hashtable sortAscColumns = new Hashtable();
            Hashtable sortDescColumns = new Hashtable();
            sortAscColumns.put( "Sorter_DATA_INSERIMENTO", "DATA_INSERIMENTO" );
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

//AMV_VISTA_DOCUMENTI Grid: method bind @5-10ABA345
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

                c = (com.codecharge.components.Control) hashRow.get("ID_DOCUMENTO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("ID_DOCUMENTO").clone();
                    c.setValue(row.getID_DOCUMENTO());
                    hashRow.put( c.getName(), c );
                }
                ((com.codecharge.components.Link) c).setHrefSourceValue( getRowFieldByName(((com.codecharge.components.Link) c).getHrefSource(), row ));

                c = (com.codecharge.components.Control) hashRow.get("DATA_INSERIMENTO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("DATA_INSERIMENTO").clone();
                    c.setValue(row.getDATA_INSERIMENTO());
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

//AMV_VISTA_DOCUMENTI Directory: getRowFieldByName @5-E62CF68F
        public Object getRowFieldByName( String name, AMV_VISTA_DOCUMENTIRow row ) {
            Object value = null;
            if ( "ID_DOCUMENTO".equals(name) ) {
                value = row.getID_DOCUMENTO();
            } else if ( "DATA_INSERIMENTO".equals(name) ) {
                value = row.getDATA_INSERIMENTO();
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

//AmvRichieste Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvRichieste Page: method validate

//AmvRichiesteAction Tail @1-FCB6E20C
}
//End AmvRichiesteAction Tail
