//AdmRichiestaAction imports @1-8144FF58
package amvadm.AdmRichiesta;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmRichiestaAction imports

//AdmRichiestaAction class @1-3C2FEF0B
public class AdmRichiestaAction extends Action {

//End AdmRichiestaAction class

//AdmRichiestaAction: method perform @1-52E29F1C
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AdmRichiestaModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AdmRichiestaModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AdmRichiestaAction: method perform

//AdmRichiestaAction: call children actions @1-70A6AC8D
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
            AD4_RICHIESTE_ABILITAZIONEGridClass AD4_RICHIESTE_ABILITAZIONEGrid = new AD4_RICHIESTE_ABILITAZIONEGridClass();
            AD4_RICHIESTE_ABILITAZIONEGrid.perform(page.getGrid("AD4_RICHIESTE_ABILITAZIONEGrid"));
        }
        if (result == null) {
            AD4_RICHIESTE_ABILITAZIONERecordClass AD4_RICHIESTE_ABILITAZIONERecord = new AD4_RICHIESTE_ABILITAZIONERecordClass();
            if ( ( redirect = AD4_RICHIESTE_ABILITAZIONERecord.perform( page.getRecord("AD4_RICHIESTE_ABILITAZIONERecord")) ) != null ) result = redirect;
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
//End AdmRichiestaAction: call children actions

//AD4_RICHIESTE_ABILITAZIONEGrid Grid @30-E73E6BB0
    final class AD4_RICHIESTE_ABILITAZIONEGridClass {
        com.codecharge.components.Grid model;
        Event e;
//End AD4_RICHIESTE_ABILITAZIONEGrid Grid

//AD4_RICHIESTE_ABILITAZIONEGrid Grid: method perform @30-B48879D3
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
//End AD4_RICHIESTE_ABILITAZIONEGrid Grid: method perform

//AD4_RICHIESTE_ABILITAZIONEGrid Grid: method read: head @30-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End AD4_RICHIESTE_ABILITAZIONEGrid Grid: method read: head

//AD4_RICHIESTE_ABILITAZIONEGrid Grid: method read: init @30-A6801712
            if ( ! model.allowRead ) return true;
            AD4_RICHIESTE_ABILITAZIONEGridDataObject ds = new AD4_RICHIESTE_ABILITAZIONEGridDataObject(page);
            ds.setComponent( model );
//End AD4_RICHIESTE_ABILITAZIONEGrid Grid: method read: init

//AD4_RICHIESTE_ABILITAZIONEGrid Grid: set where parameters @30-6748F876
            ds.setUrlID( page.getHttpGetParams().getParameter("ID") );
//End AD4_RICHIESTE_ABILITAZIONEGrid Grid: set where parameters

//AD4_RICHIESTE_ABILITAZIONEGrid Grid: set grid properties @30-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End AD4_RICHIESTE_ABILITAZIONEGrid Grid: set grid properties

//AD4_RICHIESTE_ABILITAZIONEGrid Grid: retrieve data @30-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End AD4_RICHIESTE_ABILITAZIONEGrid Grid: retrieve data

//AD4_RICHIESTE_ABILITAZIONEGrid Grid: check errors @30-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End AD4_RICHIESTE_ABILITAZIONEGrid Grid: check errors

//AD4_RICHIESTE_ABILITAZIONEGrid Grid: method read: tail @30-F575E732
            return ( ! isErrors );
        }
//End AD4_RICHIESTE_ABILITAZIONEGrid Grid: method read: tail

//AD4_RICHIESTE_ABILITAZIONEGrid Grid: method bind @30-F9ECD90A
        public void bind(com.codecharge.components.Component model, AD4_RICHIESTE_ABILITAZIONEGridRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            AD4_RICHIESTE_ABILITAZIONEGridRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("DATA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("DATA").clone();
                    c.setValue(row.getDATA());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("SERVIZIO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("SERVIZIO").clone();
                    c.setValue(row.getSERVIZIO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("RICHIEDENTE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("RICHIEDENTE").clone();
                    c.setValue(row.getRICHIEDENTE());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("UTENTE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("UTENTE").clone();
                    c.setValue(row.getUTENTE());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("STATO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("STATO").clone();
                    c.setValue(row.getSTATO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("COD_STATO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("COD_STATO").clone();
                    c.setValue(row.getCOD_STATO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("NOTIFICATA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("NOTIFICATA").clone();
                    c.setValue(row.getNOTIFICATA());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("COD_NOTIFICATA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("COD_NOTIFICATA").clone();
                    c.setValue(row.getCOD_NOTIFICATA());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("TIPO_NOTIFICA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("TIPO_NOTIFICA").clone();
                    c.setValue(row.getTIPO_NOTIFICA());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("INDIRIZZO_NOTIFICA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("INDIRIZZO_NOTIFICA").clone();
                    c.setValue(row.getINDIRIZZO_NOTIFICA());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("MODIFICA_NOTIFICA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("MODIFICA_NOTIFICA").clone();
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End AD4_RICHIESTE_ABILITAZIONEGrid Grid: method bind

//AD4_RICHIESTE_ABILITAZIONEGrid Directory: getRowFieldByName @30-B05873E0
        public Object getRowFieldByName( String name, AD4_RICHIESTE_ABILITAZIONEGridRow row ) {
            Object value = null;
            if ( "DATA".equals(name) ) {
                value = row.getDATA();
            } else if ( "SERVIZIO".equals(name) ) {
                value = row.getSERVIZIO();
            } else if ( "RICHIEDENTE".equals(name) ) {
                value = row.getRICHIEDENTE();
            } else if ( "UTENTE".equals(name) ) {
                value = row.getUTENTE();
            } else if ( "STATO".equals(name) ) {
                value = row.getSTATO();
            } else if ( "COD_STATO".equals(name) ) {
                value = row.getCOD_STATO();
            } else if ( "NOTIFICATA".equals(name) ) {
                value = row.getNOTIFICATA();
            } else if ( "COD_NOTIFICATA".equals(name) ) {
                value = row.getCOD_NOTIFICATA();
            } else if ( "TIPO_NOTIFICA".equals(name) ) {
                value = row.getTIPO_NOTIFICA();
            } else if ( "INDIRIZZO_NOTIFICA".equals(name) ) {
                value = row.getINDIRIZZO_NOTIFICA();
            } else if ( "MODIFICA_NOTIFICA".equals(name) ) {
                value = row.getMODIFICA_NOTIFICA();
            }
            return value;
        }
//End AD4_RICHIESTE_ABILITAZIONEGrid Directory: getRowFieldByName

//AD4_RICHIESTE_ABILITAZIONEGrid Grid: method validate @30-104025BA
        boolean validate() {
            return true;
        }
//End AD4_RICHIESTE_ABILITAZIONEGrid Grid: method validate

//AD4_RICHIESTE_ABILITAZIONEGrid Grid Tail @30-FCB6E20C
    }
//End AD4_RICHIESTE_ABILITAZIONEGrid Grid Tail

//AD4_RICHIESTE_ABILITAZIONERecord Record @7-09DDA428
    final class AD4_RICHIESTE_ABILITAZIONERecordClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AD4_RICHIESTE_ABILITAZIONERecord Record

//AD4_RICHIESTE_ABILITAZIONERecord Record: method perform @7-3BD5E463
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( page.getActionPageName() + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowUpdate() ) model.getChild( "Respingi" ).setVisible( false );
//End AD4_RICHIESTE_ABILITAZIONERecord Record: method perform

//AD4_RICHIESTE_ABILITAZIONERecord Record: children actions @7-3CD2CA0B
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("AD4_RICHIESTE_ABILITAZIONERecord".equals(formName)) {
                setProperties(model, Action.POST);
                if (mode != -1) { // Update mode
                    model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                    if (page.getParameter("Annulla") != null) {
                        if (validate()) {
                            AnnullaAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Respingi") != null) {
                        if (validate()) {
                            RespingiAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Approva") != null) {
                        if (validate()) {
                            ApprovaAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Convalida") != null) {
                        if (validate()) {
                            ConvalidaAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Notifica") != null) {
                        if (validate()) {
                            NotificaAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                } else { // Insert mode
                    model.setMode(com.codecharge.components.Record.INSERT_MODE);
                    if (page.getParameter("Annulla") != null) {
                        if (validate()) {
                            AnnullaAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                }
            }
            setProperties(model, Action.GET, true );
            read();
//End AD4_RICHIESTE_ABILITAZIONERecord Record: children actions

//AD4_RICHIESTE_ABILITAZIONERecord Record: method perform tail @7-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AD4_RICHIESTE_ABILITAZIONERecord Record: method perform tail

//Annulla Button @46-D60D52D9
        void AnnullaAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Annulla");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmRichieste" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
        }
//End Annulla Button

//Respingi Button @26-6F45DC9B
        void RespingiAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Respingi");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( page.getActionPageName() + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Respingi Button

//Approva Button @9-15CC0E7B
        void ApprovaAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Approva");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmRichieste" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Approva Button

//Convalida Button @59-06C2AE30
        void ConvalidaAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Convalida");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( page.getActionPageName() + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Convalida Button

//Notifica Button @61-928BF28D
        void NotificaAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Notifica");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( page.getActionPageName() + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Notifica Button

void read() { //AD4_RICHIESTE_ABILITAZIONERecord Record: method read @7-7F8AAE5A

//AD4_RICHIESTE_ABILITAZIONERecord Record: method read head @7-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AD4_RICHIESTE_ABILITAZIONERecord Record: method read head

//AD4_RICHIESTE_ABILITAZIONERecord Record: init DataSource @7-E9675C3A
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AD4_RICHIESTE_ABILITAZIONERecordDataObject ds = new AD4_RICHIESTE_ABILITAZIONERecordDataObject(page);
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
//End AD4_RICHIESTE_ABILITAZIONERecord Record: init DataSource

//AD4_RICHIESTE_ABILITAZIONERecord Record: check errors @7-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End AD4_RICHIESTE_ABILITAZIONERecord Record: check errors

} //AD4_RICHIESTE_ABILITAZIONERecord Record: method read tail @7-FCB6E20C

//AD4_RICHIESTE_ABILITAZIONERecord Record: bind @7-E7768986
            public void bind(com.codecharge.components.Component model, AD4_RICHIESTE_ABILITAZIONERecordRow row ) {
                if ( model == null || row == null ) return;
                model.getControl("REVISIONE_PARAMETRI").setValue(row.getREVISIONE_PARAMETRI());
                model.getControl("REVISIONE_COMPETENZA").setValue(row.getREVISIONE_COMPETENZA());
                model.getLink("REVISIONE_PARAMETRI").setHrefSourceValue( getRowFieldByName(model.getLink("REVISIONE_PARAMETRI").getHrefSource(), row ));
                model.getLink("REVISIONE_COMPETENZA").setHrefSourceValue( getRowFieldByName(model.getLink("REVISIONE_COMPETENZA").getHrefSource(), row ));
                if ( this.valid ) {
                }
            }
//End AD4_RICHIESTE_ABILITAZIONERecord Record: bind

//AD4_RICHIESTE_ABILITAZIONERecord Record: getRowFieldByName @7-19EFA213
            public Object getRowFieldByName( String name, AD4_RICHIESTE_ABILITAZIONERecordRow row ) {
                Object value = null;
                if ( "REVISIONE_PARAMETRI".equals(name) ) {
                    value = row.getREVISIONE_PARAMETRI();
                } else if ( "REVISIONE_COMPETENZA".equals(name) ) {
                    value = row.getREVISIONE_COMPETENZA();
                } else if ( "REVISIONE_PARAMETRI_HREF".equals(name) ) {
                    value = row.getREVISIONE_PARAMETRI_HREF();
                } else if ( "REVISIONE_COMPETENZA_HREF".equals(name) ) {
                    value = row.getREVISIONE_COMPETENZA_HREF();
                }
                return value;
            }
//End AD4_RICHIESTE_ABILITAZIONERecord Record: getRowFieldByName

void InsertAction() { //AD4_RICHIESTE_ABILITAZIONERecord Record: method insert @7-11643485

//AD4_RICHIESTE_ABILITAZIONERecord Record: components insert actions @7-68525650
            if (! model.hasErrors()) {
            }
//End AD4_RICHIESTE_ABILITAZIONERecord Record: components insert actions

} //AD4_RICHIESTE_ABILITAZIONERecord Record: method insert tail @7-FCB6E20C

void UpdateAction() { //AD4_RICHIESTE_ABILITAZIONERecord Record: method update @7-5771D0AA

//AD4_RICHIESTE_ABILITAZIONERecord Record: method update head @7-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End AD4_RICHIESTE_ABILITAZIONERecord Record: method update head

//AD4_RICHIESTE_ABILITAZIONERecord Record: method update body @7-63CADF7E
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            AD4_RICHIESTE_ABILITAZIONERecordDataObject ds = new AD4_RICHIESTE_ABILITAZIONERecordDataObject(page);
            ds.setComponent( model );
            AD4_RICHIESTE_ABILITAZIONERecordRow row = new AD4_RICHIESTE_ABILITAZIONERecordRow();
            ds.setRow(row);
            try {
                ds.setUrlID( page.getHttpGetParams().getParameter("ID"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID'" );
            }
            ds.setUrlTC( page.getHttpGetParams().getParameter("TC") );
//End AD4_RICHIESTE_ABILITAZIONERecord Record: method update body

//AD4_RICHIESTE_ABILITAZIONERecord Record: ds.update @7-6E956EDC
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
//End AD4_RICHIESTE_ABILITAZIONERecord Record: ds.update

} //AD4_RICHIESTE_ABILITAZIONERecord Record: method update tail @7-FCB6E20C

void DeleteAction() { //AD4_RICHIESTE_ABILITAZIONERecord Record: method delete @7-11FC2E1E

//AD4_RICHIESTE_ABILITAZIONERecord Record: components delete actions @7-68525650
            if (! model.hasErrors()) {
            }
//End AD4_RICHIESTE_ABILITAZIONERecord Record: components delete actions

} //AD4_RICHIESTE_ABILITAZIONERecord Record: method delete tail @7-FCB6E20C

//AD4_RICHIESTE_ABILITAZIONERecord Record: method validate @7-A8FFD717
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AD4_RICHIESTE_ABILITAZIONERecord Record: method validate

//AD4_RICHIESTE_ABILITAZIONERecord Record Tail @7-FCB6E20C
    }
//End AD4_RICHIESTE_ABILITAZIONERecord Record Tail

//AdmRichiesta Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AdmRichiesta Page: method validate

//AdmRichiestaAction Tail @1-FCB6E20C
}
//End AdmRichiestaAction Tail

