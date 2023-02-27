//AdmAccessiAction imports @1-F2207326
package amvadm.AdmAccessi;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmAccessiAction imports

//AdmAccessiAction class @1-93CD87B4
public class AdmAccessiAction extends Action {

//End AdmAccessiAction class

//AdmAccessiAction: method perform @1-5B86BECA
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AdmAccessiModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AdmAccessiModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AdmAccessiAction: method perform

//AdmAccessiAction: call children actions @1-9E5230D1
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
            AD4_ACCESSISearchClass AD4_ACCESSISearch = new AD4_ACCESSISearchClass();
            if ( ( redirect = AD4_ACCESSISearch.perform( page.getRecord("AD4_ACCESSISearch")) ) != null ) result = redirect;
        }
        if (result == null) {
            AccessiDettaglioClass AccessiDettaglio = new AccessiDettaglioClass();
            AccessiDettaglio.perform(page.getGrid("AccessiDettaglio"));
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
//End AdmAccessiAction: call children actions

//AD4_ACCESSISearch Record @30-8E6E6D6A
    final class AD4_ACCESSISearchClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AD4_ACCESSISearch Record

//AD4_ACCESSISearch Record: method perform @30-FFA564B7
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AdmAccessi" + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
//End AD4_ACCESSISearch Record: method perform

//AD4_ACCESSISearch Record: children actions @30-E592F5A6
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("AD4_ACCESSISearch".equals(formName)) {
                setProperties(model, Action.POST);
                    if (validate()) {
                        DoSearchSearchAction();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
            }
            setProperties(model, Action.GET, true );
            read();
            readSM(model.getListBox("SM"));
//End AD4_ACCESSISearch Record: children actions

//AD4_ACCESSISearch Record: method perform tail @30-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AD4_ACCESSISearch Record: method perform tail

//DoSearch Button @34-13B9648D
        void DoSearchSearchAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("DoSearch");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            for ( Iterator params = model.getChildren().iterator(); params.hasNext(); ) {
                excludeParams.add( ((com.codecharge.components.Model) params.next()).getName() );
            }
            page.setRedirectString( "AdmAccessi" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) + "&" + page.getHttpPostParams().toString( buttonModel.getExcludeParams() ) );
            buttonModel.fireOnClickEvent();
        }
//End DoSearch Button

//ListBoxAction @38-69AA2EC7
        protected void readSM(com.codecharge.components.ListBox model) {

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

            command.setSql( "SELECT distinct m.*  "
                        + "FROM AD4_MODULI m,  "
                        + "AMV_ABILITAZIONI a "
                        + "WHERE PROGETTO = '{Progetto}' "
                        + "  AND a.MODULO = m.MODULO "
                        + "" );
            if ( StringUtils.isEmpty( (String) sesProgetto.getObjectValue() ) ) sesProgetto.setValue( "" );
            command.addParameter( "Progetto", sesProgetto, null );
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

void read() { //AD4_ACCESSISearch Record: method read @30-7F8AAE5A

//AD4_ACCESSISearch Record: method read head @30-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AD4_ACCESSISearch Record: method read head

} //AD4_ACCESSISearch Record: method read tail @30-FCB6E20C

void InsertAction() { //AD4_ACCESSISearch Record: method insert @30-11643485

//AD4_ACCESSISearch Record: components insert actions @30-68525650
            if (! model.hasErrors()) {
            }
//End AD4_ACCESSISearch Record: components insert actions

} //AD4_ACCESSISearch Record: method insert tail @30-FCB6E20C

void UpdateAction() { //AD4_ACCESSISearch Record: method update @30-5771D0AA

//AD4_ACCESSISearch Record: components update actions @30-68525650
            if (! model.hasErrors()) {
            }
//End AD4_ACCESSISearch Record: components update actions

} //AD4_ACCESSISearch Record: method update tail @30-FCB6E20C

void DeleteAction() { //AD4_ACCESSISearch Record: method delete @30-11FC2E1E

//AD4_ACCESSISearch Record: components delete actions @30-68525650
            if (! model.hasErrors()) {
            }
//End AD4_ACCESSISearch Record: components delete actions

} //AD4_ACCESSISearch Record: method delete tail @30-FCB6E20C

//AD4_ACCESSISearch Record: method validate @30-D93B29B3
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.TextBox DAL = (com.codecharge.components.TextBox) model.getChild( "DAL" );
            if (! DAL.validate()) { isControlError = true; }

            com.codecharge.components.TextBox AL = (com.codecharge.components.TextBox) model.getChild( "AL" );
            if (! AL.validate()) { isControlError = true; }

            com.codecharge.components.ListBox SM = (com.codecharge.components.ListBox) model.getChild( "SM" );
            if (! SM.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AD4_ACCESSISearch Record: method validate

//AD4_ACCESSISearch Record Tail @30-FCB6E20C
    }
//End AD4_ACCESSISearch Record Tail

//AccessiDettaglio Grid @41-B9D84E55
    final class AccessiDettaglioClass {
        com.codecharge.components.Grid model;
        Event e;
//End AccessiDettaglio Grid

//AccessiDettaglio Grid: method perform @41-B48879D3
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
//End AccessiDettaglio Grid: method perform

//AccessiDettaglio Grid: method read: head @41-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End AccessiDettaglio Grid: method read: head

//AccessiDettaglio Grid: method read: init @41-F851FE6A
            if ( ! model.allowRead ) return true;
            AccessiDettaglioDataObject ds = new AccessiDettaglioDataObject(page);
            ds.setComponent( model );
//End AccessiDettaglio Grid: method read: init

//AccessiDettaglio Grid: set where parameters @41-29274033
            ds.setUrlSM( page.getHttpGetParams().getParameter("SM") );
            ds.setUrlDAL( page.getHttpGetParams().getParameter("DAL") );
            ds.setUrlAL( page.getHttpGetParams().getParameter("AL") );
            ds.setSesIstanza( SessionStorage.getInstance(req).getAttribute("Istanza") );
//End AccessiDettaglio Grid: set where parameters

//AccessiDettaglio Grid: set grid properties @41-2BB11CE9
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
            Hashtable sortAscColumns = new Hashtable();
            Hashtable sortDescColumns = new Hashtable();
            sortAscColumns.put( "Sorter_ACCESSO", "DATA_ACCESSO" );
            sortAscColumns.put( "Sorter_NOMINATIVO", "NOMINATIVO" );
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
//End AccessiDettaglio Grid: set grid properties

//AccessiDettaglio Grid: retrieve data @41-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End AccessiDettaglio Grid: retrieve data

//AccessiDettaglio Grid: check errors @41-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End AccessiDettaglio Grid: check errors

//AccessiDettaglio Grid: method read: tail @41-F575E732
            return ( ! isErrors );
        }
//End AccessiDettaglio Grid: method read: tail

//AccessiDettaglio Grid: method bind @41-BD0D09A3
        public void bind(com.codecharge.components.Component model, AccessiDettaglioRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            AccessiDettaglioRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("DATA_ACCESSO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("DATA_ACCESSO").clone();
                    c.setValue(row.getDATA_ACCESSO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("NOMINATIVO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("NOMINATIVO").clone();
                    c.setValue(row.getNOMINATIVO());
                    hashRow.put( c.getName(), c );
                }
                ((com.codecharge.components.Link) c).getParameter("IDUTE").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("IDUTE").getSourceName(), row ));

                c = (com.codecharge.components.Control) hashRow.get("SESSIONE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("SESSIONE").clone();
                    c.setValue(row.getSESSIONE());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End AccessiDettaglio Grid: method bind

//AccessiDettaglio Directory: getRowFieldByName @41-A717428F
        public Object getRowFieldByName( String name, AccessiDettaglioRow row ) {
            Object value = null;
            if ( "DATA_ACCESSO".equals(name) ) {
                value = row.getDATA_ACCESSO();
            } else if ( "NOMINATIVO".equals(name) ) {
                value = row.getNOMINATIVO();
            } else if ( "SESSIONE".equals(name) ) {
                value = row.getSESSIONE();
            } else if ( "AFCNavigator".equals(name) ) {
                value = row.getAFCNavigator();
            } else if ( "IDUTE".equals(name) ) {
                value = row.getIDUTE();
            } else if ( "UTENTE".equals(name) ) {
                value = row.getUTENTE();
            }
            return value;
        }
//End AccessiDettaglio Directory: getRowFieldByName

//AccessiDettaglio Grid: method validate @41-104025BA
        boolean validate() {
            return true;
        }
//End AccessiDettaglio Grid: method validate

//AccessiDettaglio Grid Tail @41-FCB6E20C
    }
//End AccessiDettaglio Grid Tail

//AdmAccessi Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AdmAccessi Page: method validate

//AdmAccessiAction Tail @1-FCB6E20C
}
//End AdmAccessiAction Tail


