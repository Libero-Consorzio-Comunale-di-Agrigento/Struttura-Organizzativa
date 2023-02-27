//AdmGruppoUtentiAction imports @1-4DFF4CB5
package amvadm.AdmGruppoUtenti;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmGruppoUtentiAction imports

//AdmGruppoUtentiAction class @1-910F911D
public class AdmGruppoUtentiAction extends Action {

//End AdmGruppoUtentiAction class

//AdmGruppoUtentiAction: method perform @1-8F859F48
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AdmGruppoUtentiModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AdmGruppoUtentiModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AdmGruppoUtentiAction: method perform

//AdmGruppoUtentiAction: call children actions @1-D41C057F
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
        if ( page.getChild( "AmvUtenteNominativo_i" ).isVisible() ) {
            page.getRequest().setAttribute("AmvUtenteNominativo_iParent",page);
            common.AmvUtenteNominativo_i.AmvUtenteNominativo_iAction AmvUtenteNominativo_i = new common.AmvUtenteNominativo_i.AmvUtenteNominativo_iAction();
            result = result != null ? result : AmvUtenteNominativo_i.perform( req, resp,  context );
            page.setCookies();
        }
        if (result == null) {
            AD4_UTENTISearchClass AD4_UTENTISearch = new AD4_UTENTISearchClass();
            if ( ( redirect = AD4_UTENTISearch.perform( page.getRecord("AD4_UTENTISearch")) ) != null ) result = redirect;
        }
        if (result == null) {
            AD4_UTENTIClass AD4_UTENTI = new AD4_UTENTIClass();
            AD4_UTENTI.perform(page.getGrid("AD4_UTENTI"));
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
//End AdmGruppoUtentiAction: call children actions

//AD4_UTENTISearch Record @68-441220D3
    final class AD4_UTENTISearchClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AD4_UTENTISearch Record

//AD4_UTENTISearch Record: method perform @68-6CE8FA2C
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AmvDocumenti" + Names.ACTION_SUFFIX );
            page.setRedirectString( performReturnPage.toString() );
//End AD4_UTENTISearch Record: method perform

//AD4_UTENTISearch Record: children actions @68-B4BB5B90
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("AD4_UTENTISearch".equals(formName)) {
                setProperties(model, Action.POST);
                    if (validate()) {
                        DoSearchSearchAction();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
            }
            setProperties(model, Action.GET, true );
            read();
//End AD4_UTENTISearch Record: children actions

//AD4_UTENTISearch Record: method perform tail @68-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AD4_UTENTISearch Record: method perform tail

//DoSearch Button @72-C916455B
        void DoSearchSearchAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("DoSearch");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            for ( Iterator params = model.getChildren().iterator(); params.hasNext(); ) {
                excludeParams.add( ((com.codecharge.components.Model) params.next()).getName() );
            }
            page.setRedirectString( "AdmGruppoUtenti" + Names.ACTION_SUFFIX + "?"  + "&" + page.getHttpPostParams().toString( buttonModel.getExcludeParams() ) );
            buttonModel.fireOnClickEvent();
        }
//End DoSearch Button

void read() { //AD4_UTENTISearch Record: method read @68-7F8AAE5A

//AD4_UTENTISearch Record: method read head @68-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AD4_UTENTISearch Record: method read head

//AD4_UTENTISearch Record: init DataSource @68-74BE1F52
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AD4_UTENTISearchDataObject ds = new AD4_UTENTISearchDataObject(page);
            ds.setComponent( model );
            ds.setSesMVUTE( SessionStorage.getInstance(req).getAttribute("MVUTE") );
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End AD4_UTENTISearch Record: init DataSource

//AD4_UTENTISearch Record: check errors @68-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End AD4_UTENTISearch Record: check errors

} //AD4_UTENTISearch Record: method read tail @68-FCB6E20C

//AD4_UTENTISearch Record: bind @68-6A5D2C04
            public void bind(com.codecharge.components.Component model, AD4_UTENTISearchRow row ) {
                if ( model == null || row == null ) return;
                if ( this.valid ) {
                    model.getControl("ID").setValue(row.getID());
                    model.getControl("RICERCA").setValue(row.getRICERCA());
                }
            }
//End AD4_UTENTISearch Record: bind

//AD4_UTENTISearch Record: getRowFieldByName @68-1F84F7C8
            public Object getRowFieldByName( String name, AD4_UTENTISearchRow row ) {
                Object value = null;
                if ( "s_TESTO".equals(name) ) {
                    value = row.getS_TESTO();
                } else if ( "ID".equals(name) ) {
                    value = row.getID();
                } else if ( "RICERCA".equals(name) ) {
                    value = row.getRICERCA();
                }
                return value;
            }
//End AD4_UTENTISearch Record: getRowFieldByName

void InsertAction() { //AD4_UTENTISearch Record: method insert @68-11643485

//AD4_UTENTISearch Record: components insert actions @68-68525650
            if (! model.hasErrors()) {
            }
//End AD4_UTENTISearch Record: components insert actions

} //AD4_UTENTISearch Record: method insert tail @68-FCB6E20C

void UpdateAction() { //AD4_UTENTISearch Record: method update @68-5771D0AA

//AD4_UTENTISearch Record: components update actions @68-68525650
            if (! model.hasErrors()) {
            }
//End AD4_UTENTISearch Record: components update actions

} //AD4_UTENTISearch Record: method update tail @68-FCB6E20C

void DeleteAction() { //AD4_UTENTISearch Record: method delete @68-11FC2E1E

//AD4_UTENTISearch Record: components delete actions @68-68525650
            if (! model.hasErrors()) {
            }
//End AD4_UTENTISearch Record: components delete actions

} //AD4_UTENTISearch Record: method delete tail @68-FCB6E20C

//AD4_UTENTISearch Record: method validate @68-A76427EF
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.TextBox s_TESTO = (com.codecharge.components.TextBox) model.getChild( "s_TESTO" );
            if (! s_TESTO.validate()) { isControlError = true; }

            com.codecharge.components.Hidden ID = (com.codecharge.components.Hidden) model.getChild( "ID" );
            if (! ID.validate()) { isControlError = true; }

            com.codecharge.components.Hidden RICERCA = (com.codecharge.components.Hidden) model.getChild( "RICERCA" );
            if (! RICERCA.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AD4_UTENTISearch Record: method validate

//AD4_UTENTISearch Record Tail @68-FCB6E20C
    }
//End AD4_UTENTISearch Record Tail

//AD4_UTENTI Grid @74-005CC3E1
    final class AD4_UTENTIClass {
        com.codecharge.components.Grid model;
        Event e;
//End AD4_UTENTI Grid

//AD4_UTENTI Grid: method perform @74-B48879D3
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
//End AD4_UTENTI Grid: method perform

//AD4_UTENTI Grid: method read: head @74-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End AD4_UTENTI Grid: method read: head

//AD4_UTENTI Grid: method read: init @74-4F14A888
            if ( ! model.allowRead ) return true;
            AD4_UTENTIDataObject ds = new AD4_UTENTIDataObject(page);
            ds.setComponent( model );
//End AD4_UTENTI Grid: method read: init

//AD4_UTENTI Grid: set where parameters @74-48399F64
            ds.setUrlID( page.getHttpGetParams().getParameter("ID") );
            ds.setUrlS_TESTO( page.getHttpGetParams().getParameter("s_TESTO") );
            ds.setSesProgetto( SessionStorage.getInstance(req).getAttribute("Progetto") );
            ds.setSesIstanza( SessionStorage.getInstance(req).getAttribute("Istanza") );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            try {
                ds.setSesGroupID( SessionStorage.getInstance(req).getAttribute("GroupID"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'GroupID'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'GroupID'" );
                return false;
            }
            ds.setUrlRICERCA( page.getHttpGetParams().getParameter("RICERCA") );
//End AD4_UTENTI Grid: set where parameters

//AD4_UTENTI Grid: set grid properties @74-864A8DDA
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
            Hashtable sortAscColumns = new Hashtable();
            Hashtable sortDescColumns = new Hashtable();
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
//End AD4_UTENTI Grid: set grid properties

//AD4_UTENTI Grid: retrieve data @74-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End AD4_UTENTI Grid: retrieve data

//AD4_UTENTI Grid: check errors @74-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End AD4_UTENTI Grid: check errors

//AD4_UTENTI Grid: method read: tail @74-F575E732
            return ( ! isErrors );
        }
//End AD4_UTENTI Grid: method read: tail

//AD4_UTENTI Grid: method bind @74-07BFCC01
        public void bind(com.codecharge.components.Component model, AD4_UTENTIRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            AD4_UTENTIRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("NOMINATIVO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("NOMINATIVO").clone();
                    c.setValue(row.getNOMINATIVO());
                    hashRow.put( c.getName(), c );
                }
                ((com.codecharge.components.Link) c).getParameter("IDUTE").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("IDUTE").getSourceName(), row ));

                c = (com.codecharge.components.Control) hashRow.get("GRUPPI");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("GRUPPI").clone();
                    c.setValue(row.getGRUPPI());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End AD4_UTENTI Grid: method bind

//AD4_UTENTI Directory: getRowFieldByName @74-43A7C10C
        public Object getRowFieldByName( String name, AD4_UTENTIRow row ) {
            Object value = null;
            if ( "NOMINATIVO".equals(name) ) {
                value = row.getNOMINATIVO();
            } else if ( "GRUPPI".equals(name) ) {
                value = row.getGRUPPI();
            } else if ( "AFCNavigator".equals(name) ) {
                value = row.getAFCNavigator();
            } else if ( "IDUTE".equals(name) ) {
                value = row.getIDUTE();
            } else if ( "UTENTE".equals(name) ) {
                value = row.getUTENTE();
            }
            return value;
        }
//End AD4_UTENTI Directory: getRowFieldByName

//AD4_UTENTI Grid: method validate @74-104025BA
        boolean validate() {
            return true;
        }
//End AD4_UTENTI Grid: method validate

//AD4_UTENTI Grid Tail @74-FCB6E20C
    }
//End AD4_UTENTI Grid Tail

//AdmGruppoUtenti Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AdmGruppoUtenti Page: method validate

//AdmGruppoUtentiAction Tail @1-FCB6E20C
}
//End AdmGruppoUtentiAction Tail


