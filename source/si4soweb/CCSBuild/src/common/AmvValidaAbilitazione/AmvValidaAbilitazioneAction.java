









//AmvValidaAbilitazioneAction imports @1-D7CBFA5D
package common.AmvValidaAbilitazione;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvValidaAbilitazioneAction imports

//AmvValidaAbilitazioneAction class @1-573F20A1
public class AmvValidaAbilitazioneAction extends Action {

//End AmvValidaAbilitazioneAction class

//AmvValidaAbilitazioneAction: method perform @1-FFE12A31
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvValidaAbilitazioneModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvValidaAbilitazioneModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvValidaAbilitazioneAction: method perform

//AmvValidaAbilitazioneAction: call children actions @1-C8D8E607
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
            RICHIESTAClass RICHIESTA = new RICHIESTAClass();
            RICHIESTA.perform(page.getGrid("RICHIESTA"));
        }
        if (result == null) {
            GESTISCI_RICHIESTAClass GESTISCI_RICHIESTA = new GESTISCI_RICHIESTAClass();
            if ( ( redirect = GESTISCI_RICHIESTA.perform( page.getRecord("GESTISCI_RICHIESTA")) ) != null ) result = redirect;
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
//End AmvValidaAbilitazioneAction: call children actions

//RICHIESTA Grid @22-04ED6E3B
    final class RICHIESTAClass {
        com.codecharge.components.Grid model;
        Event e;
//End RICHIESTA Grid

//RICHIESTA Grid: method perform @22-B48879D3
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
//End RICHIESTA Grid: method perform

//RICHIESTA Grid: method read: head @22-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End RICHIESTA Grid: method read: head

//RICHIESTA Grid: method read: init @22-34A85EE3
            if ( ! model.allowRead ) return true;
            RICHIESTADataObject ds = new RICHIESTADataObject(page);
            ds.setComponent( model );
//End RICHIESTA Grid: method read: init

//RICHIESTA Grid: set where parameters @22-C7D381D9
            ds.setSesMVRIC( SessionStorage.getInstance(req).getAttribute("MVRIC") );
            ds.setSesMVPWD( SessionStorage.getInstance(req).getAttribute("MVPWD") );
//End RICHIESTA Grid: set where parameters

//RICHIESTA Grid: set grid properties @22-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End RICHIESTA Grid: set grid properties

//RICHIESTA Grid: retrieve data @22-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End RICHIESTA Grid: retrieve data

//RICHIESTA Grid: check errors @22-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End RICHIESTA Grid: check errors

//RICHIESTA Grid: method read: tail @22-F575E732
            return ( ! isErrors );
        }
//End RICHIESTA Grid: method read: tail

//RICHIESTA Grid: method bind @22-90D43DAA
        public void bind(com.codecharge.components.Component model, RICHIESTARow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            RICHIESTARow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("SERVIZIO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("SERVIZIO").clone();
                    c.setValue(row.getSERVIZIO());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End RICHIESTA Grid: method bind

//RICHIESTA Directory: getRowFieldByName @22-BC678DE6
        public Object getRowFieldByName( String name, RICHIESTARow row ) {
            Object value = null;
            if ( "NOMINATIVO".equals(name) ) {
                value = row.getNOMINATIVO();
            } else if ( "SERVIZIO".equals(name) ) {
                value = row.getSERVIZIO();
            }
            return value;
        }
//End RICHIESTA Directory: getRowFieldByName

//RICHIESTA Grid: method validate @22-104025BA
        boolean validate() {
            return true;
        }
//End RICHIESTA Grid: method validate

//RICHIESTA Grid Tail @22-FCB6E20C
    }
//End RICHIESTA Grid Tail

//GESTISCI_RICHIESTA Record @7-63D31E74
    final class GESTISCI_RICHIESTAClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End GESTISCI_RICHIESTA Record

//GESTISCI_RICHIESTA Record: method perform @7-87F2393A
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AmvRegistrazioneFine" + Names.ACTION_SUFFIX );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowUpdate() ) model.getChild( "Update" ).setVisible( false );
//End GESTISCI_RICHIESTA Record: method perform

//GESTISCI_RICHIESTA Record: children actions @7-2B09DFF1
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("GESTISCI_RICHIESTA".equals(formName)) {
                setProperties(model, Action.POST);
                if (mode != -1) { // Update mode
                    model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                    if (page.getParameter("Indietro") != null) {
                        if (validate()) {
                            IndietroAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Update") != null) {
                        if (validate()) {
                            Update12Action();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Fine") != null) {
                        if (validate()) {
                            FineAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                        if (validate()) {
                            FineAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                } else { // Insert mode
                    model.setMode(com.codecharge.components.Record.INSERT_MODE);
                    if (page.getParameter("Indietro") != null) {
                        if (validate()) {
                            IndietroAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Fine") != null) {
                        if (validate()) {
                            FineAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                        if (validate()) {
                            FineAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                }
            }
            setProperties(model, Action.GET, true );
            read();
//End GESTISCI_RICHIESTA Record: children actions

//GESTISCI_RICHIESTA Record: method perform tail @7-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End GESTISCI_RICHIESTA Record: method perform tail

//Indietro Button @18-56BF124B
        void IndietroAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Indietro");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AmvServiziRichiesta" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
        }
//End Indietro Button

//Update Button @12-8956B93B
        void Update12Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Update");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AmvRegistrazioneFine" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Update Button

//Fine Button @19-826F2A4F
        void FineAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Fine");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AmvRegistrazioneFine" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
        }
//End Fine Button

void read() { //GESTISCI_RICHIESTA Record: method read @7-7F8AAE5A

//GESTISCI_RICHIESTA Record: method read head @7-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End GESTISCI_RICHIESTA Record: method read head

//GESTISCI_RICHIESTA Record: init DataSource @7-0EAAC124
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            GESTISCI_RICHIESTADataObject ds = new GESTISCI_RICHIESTADataObject(page);
            ds.setComponent( model );
            try {
                ds.setSesMVRIC( SessionStorage.getInstance(req).getAttribute("MVRIC"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVRIC'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVRIC'" );
            }
            ds.setSesMVPWD( SessionStorage.getInstance(req).getAttribute("MVPWD") );
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End GESTISCI_RICHIESTA Record: init DataSource

//GESTISCI_RICHIESTA Record: check errors @7-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End GESTISCI_RICHIESTA Record: check errors

} //GESTISCI_RICHIESTA Record: method read tail @7-FCB6E20C

//GESTISCI_RICHIESTA Record: bind @7-EE313642
            public void bind(com.codecharge.components.Component model, GESTISCI_RICHIESTARow row ) {
                if ( model == null || row == null ) return;
                if ( this.valid ) {
                }
            }
//End GESTISCI_RICHIESTA Record: bind

//GESTISCI_RICHIESTA Record: getRowFieldByName @7-878CD21B
            public Object getRowFieldByName( String name, GESTISCI_RICHIESTARow row ) {
                Object value = null;
                return value;
            }
//End GESTISCI_RICHIESTA Record: getRowFieldByName

void InsertAction() { //GESTISCI_RICHIESTA Record: method insert @7-11643485

//GESTISCI_RICHIESTA Record: method insert head @7-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End GESTISCI_RICHIESTA Record: method insert head

//GESTISCI_RICHIESTA Record: components insert actions @7-68525650
            if (! model.hasErrors()) {
            }
//End GESTISCI_RICHIESTA Record: components insert actions

} //GESTISCI_RICHIESTA Record: method insert tail @7-FCB6E20C

void UpdateAction() { //GESTISCI_RICHIESTA Record: method update @7-5771D0AA

//GESTISCI_RICHIESTA Record: method update head @7-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End GESTISCI_RICHIESTA Record: method update head

//GESTISCI_RICHIESTA Record: method update body @7-68C0C877
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            GESTISCI_RICHIESTADataObject ds = new GESTISCI_RICHIESTADataObject(page);
            ds.setComponent( model );
            GESTISCI_RICHIESTARow row = new GESTISCI_RICHIESTARow();
            ds.setRow(row);
            try {
                ds.setSesMVRIC( SessionStorage.getInstance(req).getAttribute("MVRIC"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVRIC'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVRIC'" );
            }
            ds.setExprKey21( ( "C" ) );
//End GESTISCI_RICHIESTA Record: method update body

//GESTISCI_RICHIESTA Record: ds.update @7-6E956EDC
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
//End GESTISCI_RICHIESTA Record: ds.update

} //GESTISCI_RICHIESTA Record: method update tail @7-FCB6E20C

void DeleteAction() { //GESTISCI_RICHIESTA Record: method delete @7-11FC2E1E

//GESTISCI_RICHIESTA Record: method delete head @7-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End GESTISCI_RICHIESTA Record: method delete head

//GESTISCI_RICHIESTA Record: components delete actions @7-68525650
            if (! model.hasErrors()) {
            }
//End GESTISCI_RICHIESTA Record: components delete actions

} //GESTISCI_RICHIESTA Record: method delete tail @7-FCB6E20C

//GESTISCI_RICHIESTA Record: method validate @7-A8FFD717
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End GESTISCI_RICHIESTA Record: method validate

//GESTISCI_RICHIESTA Record Tail @7-FCB6E20C
    }
//End GESTISCI_RICHIESTA Record Tail

//AmvValidaAbilitazione Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvValidaAbilitazione Page: method validate

//AmvValidaAbilitazioneAction Tail @1-FCB6E20C
}
//End AmvValidaAbilitazioneAction Tail


