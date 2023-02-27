//AdmPreferenzeImpostazioneAction imports @1-C849F6ED
package amvadm.AdmPreferenzeImpostazione;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmPreferenzeImpostazioneAction imports

//AdmPreferenzeImpostazioneAction class @1-579E97E3
public class AdmPreferenzeImpostazioneAction extends Action {

//End AdmPreferenzeImpostazioneAction class

//AdmPreferenzeImpostazioneAction: method perform @1-6717DC6E
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AdmPreferenzeImpostazioneModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AdmPreferenzeImpostazioneModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AdmPreferenzeImpostazioneAction: method perform

//AdmPreferenzeImpostazioneAction: call children actions @1-A915BAB0
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
            TITLEGridClass TITLEGrid = new TITLEGridClass();
            TITLEGrid.perform(page.getGrid("TITLEGrid"));
        }
        if (result == null) {
            PREFERENZEClass PREFERENZE = new PREFERENZEClass();
            PREFERENZE.perform(page.getGrid("PREFERENZE"));
        }
        if (result == null) {
            PREFERENZAClass PREFERENZA = new PREFERENZAClass();
            if ( ( redirect = PREFERENZA.perform( page.getRecord("PREFERENZA")) ) != null ) result = redirect;
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
//End AdmPreferenzeImpostazioneAction: call children actions

//TITLEGrid Grid @31-58BEAD48
    final class TITLEGridClass {
        com.codecharge.components.Grid model;
        Event e;
//End TITLEGrid Grid

//TITLEGrid Grid: method perform @31-B48879D3
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
//End TITLEGrid Grid: method perform

//TITLEGrid Grid: method read: head @31-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End TITLEGrid Grid: method read: head

//TITLEGrid Grid: method read: init @31-96EAF3B0
            if ( ! model.allowRead ) return true;
            TITLEGridDataObject ds = new TITLEGridDataObject(page);
            ds.setComponent( model );
//End TITLEGrid Grid: method read: init

//TITLEGrid Grid: set where parameters @31-B6F789EB
            try {
                ds.setUrlMVAV( page.getHttpGetParams().getParameter("MVAV"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVAV'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVAV'" );
                return false;
            }
            ds.setSesModulo( SessionStorage.getInstance(req).getAttribute("Modulo") );
//End TITLEGrid Grid: set where parameters

//TITLEGrid Grid: set grid properties @31-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End TITLEGrid Grid: set grid properties

//TITLEGrid Grid: retrieve data @31-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End TITLEGrid Grid: retrieve data

//TITLEGrid Grid: check errors @31-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End TITLEGrid Grid: check errors

//TITLEGrid Grid: method read: tail @31-F575E732
            return ( ! isErrors );
        }
//End TITLEGrid Grid: method read: tail

//TITLEGrid Grid: method bind @31-3F99B103
        public void bind(com.codecharge.components.Component model, TITLEGridRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            TITLEGridRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("LIVELLO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("LIVELLO").clone();
                    c.setValue(row.getLIVELLO());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End TITLEGrid Grid: method bind

//TITLEGrid Directory: getRowFieldByName @31-8775FFED
        public Object getRowFieldByName( String name, TITLEGridRow row ) {
            Object value = null;
            if ( "TITOLO".equals(name) ) {
                value = row.getTITOLO();
            } else if ( "LIVELLO".equals(name) ) {
                value = row.getLIVELLO();
            }
            return value;
        }
//End TITLEGrid Directory: getRowFieldByName

//TITLEGrid Grid: method validate @31-104025BA
        boolean validate() {
            return true;
        }
//End TITLEGrid Grid: method validate

//TITLEGrid Grid Tail @31-FCB6E20C
    }
//End TITLEGrid Grid Tail

//PREFERENZE Grid @6-25D916AE
    final class PREFERENZEClass {
        com.codecharge.components.Grid model;
        Event e;
//End PREFERENZE Grid

//PREFERENZE Grid: method perform @6-B48879D3
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
//End PREFERENZE Grid: method perform

//PREFERENZE Grid: method read: head @6-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End PREFERENZE Grid: method read: head

//PREFERENZE Grid: method read: init @6-57D9335F
            if ( ! model.allowRead ) return true;
            PREFERENZEDataObject ds = new PREFERENZEDataObject(page);
            ds.setComponent( model );
//End PREFERENZE Grid: method read: init

//PREFERENZE Grid: set where parameters @6-0C288C66
            ds.setSesModulo( SessionStorage.getInstance(req).getAttribute("Modulo") );
            ds.setUrlMVAV( page.getHttpGetParams().getParameter("MVAV") );
//End PREFERENZE Grid: set where parameters

//PREFERENZE Grid: set grid properties @6-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End PREFERENZE Grid: set grid properties

//PREFERENZE Grid: retrieve data @6-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End PREFERENZE Grid: retrieve data

//PREFERENZE Grid: check errors @6-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End PREFERENZE Grid: check errors

//PREFERENZE Grid: method read: tail @6-F575E732
            return ( ! isErrors );
        }
//End PREFERENZE Grid: method read: tail

//PREFERENZE Grid: method bind @6-71A25F79
        public void bind(com.codecharge.components.Component model, PREFERENZERow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            PREFERENZERow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("STRINGA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("STRINGA").clone();
                    c.setValue(row.getSTRINGA());
                    hashRow.put( c.getName(), c );
                }
                ((com.codecharge.components.Link) c).getParameter("STRINGA").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("STRINGA").getSourceName(), row ));

                c = (com.codecharge.components.Control) hashRow.get("IMPOSTATA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("IMPOSTATA").clone();
                    c.setValue(row.getIMPOSTATA());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("VALORE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("VALORE").clone();
                    c.setValue(row.getVALORE());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("COMMENTO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("COMMENTO").clone();
                    c.setValue(row.getCOMMENTO());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End PREFERENZE Grid: method bind

//PREFERENZE Directory: getRowFieldByName @6-3167F54B
        public Object getRowFieldByName( String name, PREFERENZERow row ) {
            Object value = null;
            if ( "STRINGA".equals(name) ) {
                value = row.getSTRINGA();
            } else if ( "IMPOSTATA".equals(name) ) {
                value = row.getIMPOSTATA();
            } else if ( "VALORE".equals(name) ) {
                value = row.getVALORE();
            } else if ( "COMMENTO".equals(name) ) {
                value = row.getCOMMENTO();
            } else if ( "AFCNavigator".equals(name) ) {
                value = row.getAFCNavigator();
            }
            return value;
        }
//End PREFERENZE Directory: getRowFieldByName

//PREFERENZE Grid: method validate @6-104025BA
        boolean validate() {
            return true;
        }
//End PREFERENZE Grid: method validate

//PREFERENZE Grid Tail @6-FCB6E20C
    }
//End PREFERENZE Grid Tail

//PREFERENZA Record @17-DE2D9458
    final class PREFERENZAClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End PREFERENZA Record

//PREFERENZA Record: method perform @17-27B6F412
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AdmPreferenzeImpostazione" + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowUpdate() ) model.getChild( "Update" ).setVisible( false );
            if ( ! model.isAllowDelete() ) model.getChild( "Delete" ).setVisible( false );
//End PREFERENZA Record: method perform

//PREFERENZA Record: children actions @17-D30AA239
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("PREFERENZA".equals(formName)) {
                setProperties(model, Action.POST);
                if (mode != -1) { // Update mode
                    model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                    if (page.getParameter("Update") != null) {
                        if (validate()) {
                            Update21Action();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Delete") != null) {
                        Delete22Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                    if (page.getParameter("Cancel") != null) {
                        Cancel23Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                } else { // Insert mode
                    model.setMode(com.codecharge.components.Record.INSERT_MODE);
                    if (page.getParameter("Cancel") != null) {
                        Cancel23Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                }
            }
            setProperties(model, Action.GET, true );
            read();
//End PREFERENZA Record: children actions

//PREFERENZA Record: method perform tail @17-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End PREFERENZA Record: method perform tail

//Update Button @21-DC2B2241
        void Update21Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Update");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmPreferenzeImpostazione" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Update Button

//Delete Button @22-DECEB88D
        void Delete22Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Delete");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmPreferenzeImpostazione" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            DeleteAction();
        }
//End Delete Button

//Cancel Button @23-9F608F8C
        void Cancel23Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Cancel");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmPreferenzeImpostazione" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
        }
//End Cancel Button

void read() { //PREFERENZA Record: method read @17-7F8AAE5A

//PREFERENZA Record: method read head @17-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End PREFERENZA Record: method read head

//PREFERENZA Record: init DataSource @17-525B1125
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            PREFERENZADataObject ds = new PREFERENZADataObject(page);
            ds.setComponent( model );
            ds.setUrlSTRINGA( page.getHttpGetParams().getParameter("STRINGA") );
            ds.setUrlMVAV( page.getHttpGetParams().getParameter("MVAV") );
            ds.setSesModulo( SessionStorage.getInstance(req).getAttribute("Modulo") );
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End PREFERENZA Record: init DataSource

//PREFERENZA Record: check errors @17-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End PREFERENZA Record: check errors

} //PREFERENZA Record: method read tail @17-FCB6E20C

//PREFERENZA Record: bind @17-682CF108
            public void bind(com.codecharge.components.Component model, PREFERENZARow row ) {
                if ( model == null || row == null ) return;
                model.getControl("STRINGA_LABEL").setValue(row.getSTRINGA_LABEL());
                model.getControl("COMMENTO").setValue(row.getCOMMENTO());
                if ( this.valid ) {
                    model.getControl("VALORE").setValue(row.getVALORE());
                    model.getControl("STRINGA").setValue(row.getSTRINGA());
                    model.getControl("MODULO").setValue(row.getMODULO());
                }
            }
//End PREFERENZA Record: bind

//PREFERENZA Record: getRowFieldByName @17-062D5383
            public Object getRowFieldByName( String name, PREFERENZARow row ) {
                Object value = null;
                if ( "STRINGA_LABEL".equals(name) ) {
                    value = row.getSTRINGA_LABEL();
                } else if ( "COMMENTO".equals(name) ) {
                    value = row.getCOMMENTO();
                } else if ( "VALORE".equals(name) ) {
                    value = row.getVALORE();
                } else if ( "STRINGA".equals(name) ) {
                    value = row.getSTRINGA();
                } else if ( "MODULO".equals(name) ) {
                    value = row.getMODULO();
                }
                return value;
            }
//End PREFERENZA Record: getRowFieldByName

void InsertAction() { //PREFERENZA Record: method insert @17-11643485

//PREFERENZA Record: method insert head @17-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End PREFERENZA Record: method insert head

//PREFERENZA Record: components insert actions @17-68525650
            if (! model.hasErrors()) {
            }
//End PREFERENZA Record: components insert actions

} //PREFERENZA Record: method insert tail @17-FCB6E20C

void UpdateAction() { //PREFERENZA Record: method update @17-5771D0AA

//PREFERENZA Record: method update head @17-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End PREFERENZA Record: method update head

//PREFERENZA Record: method update body @17-B64D2F32
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            PREFERENZADataObject ds = new PREFERENZADataObject(page);
            ds.setComponent( model );
            PREFERENZARow row = new PREFERENZARow();
            ds.setRow(row);
            ds.setPostSTRINGA( page.getHttpPostParams().getParameter("STRINGA") );
            ds.setPostVALORE( page.getHttpPostParams().getParameter("VALORE") );
            ds.setPostMODULO( page.getHttpPostParams().getParameter("MODULO") );
            ds.setExprKey43( ( "" ) );
//End PREFERENZA Record: method update body

//PREFERENZA Record: ds.update @17-6E956EDC
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
//End PREFERENZA Record: ds.update

} //PREFERENZA Record: method update tail @17-FCB6E20C

void DeleteAction() { //PREFERENZA Record: method delete @17-11FC2E1E

//PREFERENZA Record: method delete head @17-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End PREFERENZA Record: method delete head

//PREFERENZA Record: method delete body @17-8911C295
            if (!model.isAllowDelete()) return;
            boolean isErrors = false;
            PREFERENZADataObject ds = new PREFERENZADataObject(page);
            ds.setComponent( model );
            PREFERENZARow row = new PREFERENZARow();
            ds.setRow(row);
            ds.setPostSTRINGA( page.getHttpPostParams().getParameter("STRINGA") );
            ds.setExprKey41( ( null ) );
            ds.setPostMODULO( page.getHttpPostParams().getParameter("MODULO") );
            ds.setUrlP_UTENTE( page.getHttpGetParams().getParameter("P_UTENTE") );
//End PREFERENZA Record: method delete body

//PREFERENZA Record: ds.delete @17-3584344F
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
//End PREFERENZA Record: ds.delete

} //PREFERENZA Record: method delete tail @17-FCB6E20C

//PREFERENZA Record: method validate @17-1B9C7540
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.TextArea VALORE = (com.codecharge.components.TextArea) model.getChild( "VALORE" );
            if (! VALORE.validate()) { isControlError = true; }

            com.codecharge.components.Hidden STRINGA = (com.codecharge.components.Hidden) model.getChild( "STRINGA" );
            if (! STRINGA.validate()) { isControlError = true; }

            com.codecharge.components.Hidden MODULO = (com.codecharge.components.Hidden) model.getChild( "MODULO" );
            if (! MODULO.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End PREFERENZA Record: method validate

//PREFERENZA Record Tail @17-FCB6E20C
    }
//End PREFERENZA Record Tail

//AdmPreferenzeImpostazione Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AdmPreferenzeImpostazione Page: method validate

//AdmPreferenzeImpostazioneAction Tail @1-FCB6E20C
}
//End AdmPreferenzeImpostazioneAction Tail




