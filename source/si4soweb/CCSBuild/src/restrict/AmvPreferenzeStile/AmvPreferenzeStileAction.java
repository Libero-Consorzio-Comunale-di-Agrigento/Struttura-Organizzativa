



//AmvPreferenzeStileAction imports @1-2B541EB1
package restrict.AmvPreferenzeStile;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvPreferenzeStileAction imports

//AmvPreferenzeStileAction class @1-E4EBC08C
public class AmvPreferenzeStileAction extends Action {

//End AmvPreferenzeStileAction class

//AmvPreferenzeStileAction: method perform @1-B69DFD9D
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvPreferenzeStileModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvPreferenzeStileModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvPreferenzeStileAction: method perform

//AmvPreferenzeStileAction: call children actions @1-17E4641B
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
        if ( page.getChild( "AmvGuida" ).isVisible() ) {
            page.getRequest().setAttribute("AmvGuidaParent",page);
            common.AmvGuida.AmvGuidaAction AmvGuida = new common.AmvGuida.AmvGuidaAction();
            result = result != null ? result : AmvGuida.perform( req, resp,  context );
            page.setCookies();
        }
        if (result == null) {
            STILE_ATTUALEClass STILE_ATTUALE = new STILE_ATTUALEClass();
            STILE_ATTUALE.perform(page.getGrid("STILE_ATTUALE"));
        }
        if ( page.getChild( "AmvStili" ).isVisible() ) {
            page.getRequest().setAttribute("AmvStiliParent",page);
            restrict.AmvStili.AmvStiliAction AmvStili = new restrict.AmvStili.AmvStiliAction();
            result = result != null ? result : AmvStili.perform( req, resp,  context );
            page.setCookies();
        }
        if (result == null) {
            NewRecord1Class NewRecord1 = new NewRecord1Class();
            if ( ( redirect = NewRecord1.perform( page.getRecord("NewRecord1")) ) != null ) result = redirect;
        }
        if (result == null) {
            NewGrid1Class NewGrid1 = new NewGrid1Class();
            NewGrid1.perform(page.getGrid("NewGrid1"));
        }
        if (result == null) {
            copyrightClass copyright = new copyrightClass();
            copyright.perform(page.getGrid("copyright"));
        }
        if ( page.getChild( "Versione" ).isVisible() ) {
            page.getRequest().setAttribute("VersioneParent",page);
            common.Versione.VersioneAction Versione = new common.Versione.VersioneAction();
            result = result != null ? result : Versione.perform( req, resp,  context );
            page.setCookies();
        }
        if ( page.getChild( "AmvVersione" ).isVisible() ) {
            page.getRequest().setAttribute("AmvVersioneParent",page);
            common.AmvVersione.AmvVersioneAction AmvVersione = new common.AmvVersione.AmvVersioneAction();
            result = result != null ? result : AmvVersione.perform( req, resp,  context );
            page.setCookies();
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvPreferenzeStileAction: call children actions

//STILE_ATTUALE Grid @7-A6536830
    final class STILE_ATTUALEClass {
        com.codecharge.components.Grid model;
        Event e;
//End STILE_ATTUALE Grid

//STILE_ATTUALE Grid: method perform @7-B48879D3
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
//End STILE_ATTUALE Grid: method perform

//STILE_ATTUALE Grid: method read: head @7-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End STILE_ATTUALE Grid: method read: head

//STILE_ATTUALE Grid: method read: init @7-21C87AC2
            if ( ! model.allowRead ) return true;
            STILE_ATTUALEDataObject ds = new STILE_ATTUALEDataObject(page);
            ds.setComponent( model );
//End STILE_ATTUALE Grid: method read: init

//STILE_ATTUALE Grid: set where parameters @7-AFABBF4D
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setSesModulo( SessionStorage.getInstance(req).getAttribute("Modulo") );
            ds.setUrlSTYLE( page.getHttpGetParams().getParameter("STYLE") );
//End STILE_ATTUALE Grid: set where parameters

//STILE_ATTUALE Grid: set grid properties @7-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End STILE_ATTUALE Grid: set grid properties

//STILE_ATTUALE Grid: retrieve data @7-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End STILE_ATTUALE Grid: retrieve data

//STILE_ATTUALE Grid: check errors @7-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End STILE_ATTUALE Grid: check errors

//STILE_ATTUALE Grid: method read: tail @7-F575E732
            return ( ! isErrors );
        }
//End STILE_ATTUALE Grid: method read: tail

//STILE_ATTUALE Grid: method bind @7-85A61BFC
        public void bind(com.codecharge.components.Component model, STILE_ATTUALERow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            STILE_ATTUALERow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("STILE_SCELTO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("STILE_SCELTO").clone();
                    c.setValue(row.getSTILE_SCELTO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("STILE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("STILE").clone();
                    c.setValue(row.getSTILE());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("CONFERMA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("CONFERMA").clone();
                    hashRow.put( c.getName(), c );
                }
                ((com.codecharge.components.Link) c).getParameter("ccsForm").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("ccsForm").getSourceName(), row ));
                ((com.codecharge.components.Link) c).getParameter("STYLESHEET").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("STYLESHEET").getSourceName(), row ));
                ((com.codecharge.components.Link) c).getParameter("Button_Update").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("Button_Update").getSourceName(), row ));
                ((com.codecharge.components.Link) c).getParameter("MVID").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("MVID").getSourceName(), row ));

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End STILE_ATTUALE Grid: method bind

//STILE_ATTUALE Directory: getRowFieldByName @7-A2C0516C
        public Object getRowFieldByName( String name, STILE_ATTUALERow row ) {
            Object value = null;
            if ( "STILE_SCELTO".equals(name) ) {
                value = row.getSTILE_SCELTO();
            } else if ( "STILE".equals(name) ) {
                value = row.getSTILE();
            } else if ( "CONFERMA".equals(name) ) {
                value = row.getCONFERMA();
            } else if ( "ccsForm".equals(name) ) {
                value = row.getCcsForm();
            } else if ( "CCSFORM".equals(name) ) {
                value = row.getCCSFORM();
            } else if ( "STYLESHEET".equals(name) ) {
                value = row.getSTYLESHEET();
            } else if ( "Button_Update".equals(name) ) {
                value = row.getButton_Update();
            } else if ( "BUTTONUPDATE".equals(name) ) {
                value = row.getBUTTONUPDATE();
            } else if ( "MVID".equals(name) ) {
                value = row.getMVID();
            }
            return value;
        }
//End STILE_ATTUALE Directory: getRowFieldByName

//STILE_ATTUALE Grid: method validate @7-104025BA
        boolean validate() {
            return true;
        }
//End STILE_ATTUALE Grid: method validate

//STILE_ATTUALE Grid Tail @7-FCB6E20C
    }
//End STILE_ATTUALE Grid Tail

//NewRecord1 Record @42-61C5735A
    final class NewRecord1Class {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End NewRecord1 Record

//NewRecord1 Record: method perform @42-65A7DEFC
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( page.getActionPageName() + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
//End NewRecord1 Record: method perform

//NewRecord1 Record: children actions @42-4434D1D4
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("NewRecord1".equals(formName)) {
                setProperties(model, Action.POST);
                if (mode != -1) { // Update mode
                    model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                    if (page.getParameter("Button_Update") != null) {
                        if (validate()) {
                            Button_UpdateAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Button_Delete") != null) {
                        Button_DeleteAction();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                } else { // Insert mode
                    model.setMode(com.codecharge.components.Record.INSERT_MODE);
                    if (page.getParameter("Button_Update") != null) {
                        if (validate()) {
                            Button_UpdateAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Button_Delete") != null) {
                        Button_DeleteAction();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                }
            }
            setProperties(model, Action.GET, true );
            read();
//End NewRecord1 Record: children actions

//NewRecord1 Record: method perform tail @42-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End NewRecord1 Record: method perform tail

//Button_Update Button @46-4286FE86
        void Button_UpdateAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Button_Update");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( page.getActionPageName() + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
        }
//End Button_Update Button

//Button_Delete Button @47-8DC91482
        void Button_DeleteAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Button_Delete");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( page.getActionPageName() + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
        }
//End Button_Delete Button

void read() { //NewRecord1 Record: method read @42-7F8AAE5A

//NewRecord1 Record: method read head @42-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End NewRecord1 Record: method read head

//NewRecord1 Record: init DataSource @42-82856B48
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            NewRecord1DataObject ds = new NewRecord1DataObject(page);
            ds.setComponent( model );
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End NewRecord1 Record: init DataSource

//NewRecord1 Record: check errors @42-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End NewRecord1 Record: check errors

} //NewRecord1 Record: method read tail @42-FCB6E20C

//NewRecord1 Record: bind @42-9A3F4863
            public void bind(com.codecharge.components.Component model, NewRecord1Row row ) {
                if ( model == null || row == null ) return;
                if ( this.valid ) {
                    model.getControl("TextBox0").setValue(row.getTextBox0());
                    model.getControl("TextBox1").setValue(row.getTextBox1());
                    model.getControl("TextBox2").setValue(row.getTextBox2());
                    model.getControl("TextBox3").setValue(row.getTextBox3());
                    model.getControl("TextArea1").setValue(row.getTextArea1());
                }
            }
//End NewRecord1 Record: bind

//NewRecord1 Record: getRowFieldByName @42-4FDBD79E
            public Object getRowFieldByName( String name, NewRecord1Row row ) {
                Object value = null;
                if ( "TextBox0".equals(name) ) {
                    value = row.getTextBox0();
                } else if ( "TextBox1".equals(name) ) {
                    value = row.getTextBox1();
                } else if ( "TextBox2".equals(name) ) {
                    value = row.getTextBox2();
                } else if ( "TextBox3".equals(name) ) {
                    value = row.getTextBox3();
                } else if ( "Modifica".equals(name) ) {
                    value = row.getModifica();
                } else if ( "TextArea1".equals(name) ) {
                    value = row.getTextArea1();
                } else if ( "Link1".equals(name) ) {
                    value = row.getLink1();
                }
                return value;
            }
//End NewRecord1 Record: getRowFieldByName

void InsertAction() { //NewRecord1 Record: method insert @42-11643485

//NewRecord1 Record: method insert head @42-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End NewRecord1 Record: method insert head

//NewRecord1 Record: components insert actions @42-68525650
            if (! model.hasErrors()) {
            }
//End NewRecord1 Record: components insert actions

} //NewRecord1 Record: method insert tail @42-FCB6E20C

void UpdateAction() { //NewRecord1 Record: method update @42-5771D0AA

//NewRecord1 Record: method update head @42-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End NewRecord1 Record: method update head

//NewRecord1 Record: components update actions @42-68525650
            if (! model.hasErrors()) {
            }
//End NewRecord1 Record: components update actions

} //NewRecord1 Record: method update tail @42-FCB6E20C

void DeleteAction() { //NewRecord1 Record: method delete @42-11FC2E1E

//NewRecord1 Record: method delete head @42-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End NewRecord1 Record: method delete head

//NewRecord1 Record: components delete actions @42-68525650
            if (! model.hasErrors()) {
            }
//End NewRecord1 Record: components delete actions

} //NewRecord1 Record: method delete tail @42-FCB6E20C

//NewRecord1 Record: method validate @42-0038F4D4
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.TextBox TextBox0 = (com.codecharge.components.TextBox) model.getChild( "TextBox0" );
            if (! TextBox0.validate()) { isControlError = true; }

            com.codecharge.components.TextBox TextBox1 = (com.codecharge.components.TextBox) model.getChild( "TextBox1" );
            if (! TextBox1.validate()) { isControlError = true; }

            com.codecharge.components.TextBox TextBox2 = (com.codecharge.components.TextBox) model.getChild( "TextBox2" );
            if (! TextBox2.validate()) { isControlError = true; }

            com.codecharge.components.TextBox TextBox3 = (com.codecharge.components.TextBox) model.getChild( "TextBox3" );
            if (! TextBox3.validate()) { isControlError = true; }

            com.codecharge.components.TextArea TextArea1 = (com.codecharge.components.TextArea) model.getChild( "TextArea1" );
            if (! TextArea1.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End NewRecord1 Record: method validate

//NewRecord1 Record Tail @42-FCB6E20C
    }
//End NewRecord1 Record Tail

//NewGrid1 Grid @48-6A1F7436
    final class NewGrid1Class {
        com.codecharge.components.Grid model;
        Event e;
//End NewGrid1 Grid

//NewGrid1 Grid: method perform @48-B48879D3
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
//End NewGrid1 Grid: method perform

//NewGrid1 Grid: method read: head @48-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End NewGrid1 Grid: method read: head

//NewGrid1 Grid: method read: init @48-2EA3AAF9
            if ( ! model.allowRead ) return true;
            NewGrid1DataObject ds = new NewGrid1DataObject(page);
            ds.setComponent( model );
//End NewGrid1 Grid: method read: init

//NewGrid1 Grid: set grid properties @48-C9A30ADE
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
            Hashtable sortAscColumns = new Hashtable();
            Hashtable sortDescColumns = new Hashtable();
            sortAscColumns.put( "Sorter1", "" );
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
//End NewGrid1 Grid: set grid properties

//NewGrid1 Grid: retrieve data @48-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End NewGrid1 Grid: retrieve data

//NewGrid1 Grid: check errors @48-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End NewGrid1 Grid: check errors

//NewGrid1 Grid: method read: tail @48-F575E732
            return ( ! isErrors );
        }
//End NewGrid1 Grid: method read: tail

//NewGrid1 Grid: method bind @48-4DA09D21
        public void bind(com.codecharge.components.Component model, NewGrid1Row[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            NewGrid1Row row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("Link1");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("Link1").clone();
                    c.setValue(row.getLink1());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("Label2");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("Label2").clone();
                    c.setValue(row.getLabel2());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End NewGrid1 Grid: method bind

//NewGrid1 Directory: getRowFieldByName @48-00EF7B0F
        public Object getRowFieldByName( String name, NewGrid1Row row ) {
            Object value = null;
            if ( "Link1".equals(name) ) {
                value = row.getLink1();
            } else if ( "Label2".equals(name) ) {
                value = row.getLabel2();
            }
            return value;
        }
//End NewGrid1 Directory: getRowFieldByName

//NewGrid1 Grid: method validate @48-104025BA
        boolean validate() {
            return true;
        }
//End NewGrid1 Grid: method validate

//NewGrid1 Grid Tail @48-FCB6E20C
    }
//End NewGrid1 Grid Tail

//copyright Grid @25-A7DD67FE
    final class copyrightClass {
        com.codecharge.components.Grid model;
        Event e;
//End copyright Grid

//copyright Grid: method perform @25-B48879D3
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
//End copyright Grid: method perform

//copyright Grid: method read: head @25-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End copyright Grid: method read: head

//copyright Grid: method read: init @25-03D75372
            if ( ! model.allowRead ) return true;
            copyrightDataObject ds = new copyrightDataObject(page);
            ds.setComponent( model );
//End copyright Grid: method read: init

//copyright Grid: set where parameters @25-AFABBF4D
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setSesModulo( SessionStorage.getInstance(req).getAttribute("Modulo") );
            ds.setUrlSTYLE( page.getHttpGetParams().getParameter("STYLE") );
//End copyright Grid: set where parameters

//copyright Grid: set grid properties @25-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End copyright Grid: set grid properties

//copyright Grid: retrieve data @25-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End copyright Grid: retrieve data

//copyright Grid: check errors @25-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End copyright Grid: check errors

//copyright Grid: method read: tail @25-F575E732
            return ( ! isErrors );
        }
//End copyright Grid: method read: tail

//copyright Grid: method bind @25-94C66190
        public void bind(com.codecharge.components.Component model, copyrightRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            copyrightRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("MESSAGGIO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("MESSAGGIO").clone();
                    c.setValue(row.getMESSAGGIO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("STILE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("STILE").clone();
                    c.setValue(row.getSTILE());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End copyright Grid: method bind

//copyright Directory: getRowFieldByName @25-EF1B84B2
        public Object getRowFieldByName( String name, copyrightRow row ) {
            Object value = null;
            if ( "MESSAGGIO".equals(name) ) {
                value = row.getMESSAGGIO();
            } else if ( "STILE".equals(name) ) {
                value = row.getSTILE();
            }
            return value;
        }
//End copyright Directory: getRowFieldByName

//copyright Grid: method validate @25-104025BA
        boolean validate() {
            return true;
        }
//End copyright Grid: method validate

//copyright Grid Tail @25-FCB6E20C
    }
//End copyright Grid Tail

//AmvPreferenzeStile Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvPreferenzeStile Page: method validate

//AmvPreferenzeStileAction Tail @1-FCB6E20C
}
//End AmvPreferenzeStileAction Tail


