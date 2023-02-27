//AdmArgomentiAction imports @1-401C6CAA
package amvadm.AdmArgomenti;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmArgomentiAction imports

//AdmArgomentiAction class @1-F6E8EABE
public class AdmArgomentiAction extends Action {

//End AdmArgomentiAction class

//AdmArgomentiAction: method perform @1-82A12736
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AdmArgomentiModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AdmArgomentiModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AdmArgomentiAction: method perform

//AdmArgomentiAction: call children actions @1-1CECCC53
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
            AMV_ARGOMENTIClass AMV_ARGOMENTI = new AMV_ARGOMENTIClass();
            AMV_ARGOMENTI.perform(page.getGrid("AMV_ARGOMENTI"));
        }
        if (result == null) {
            AMV_ARGOMENTI1Class AMV_ARGOMENTI1 = new AMV_ARGOMENTI1Class();
            if ( ( redirect = AMV_ARGOMENTI1.perform( page.getRecord("AMV_ARGOMENTI1")) ) != null ) result = redirect;
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
//End AdmArgomentiAction: call children actions

//AMV_ARGOMENTI Grid @5-7BE75D0D
    final class AMV_ARGOMENTIClass {
        com.codecharge.components.Grid model;
        Event e;
//End AMV_ARGOMENTI Grid

//AMV_ARGOMENTI Grid: method perform @5-B48879D3
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
//End AMV_ARGOMENTI Grid: method perform

//AMV_ARGOMENTI Grid: method read: head @5-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End AMV_ARGOMENTI Grid: method read: head

//AMV_ARGOMENTI Grid: method read: init @5-6FC4B2E6
            if ( ! model.allowRead ) return true;
            AMV_ARGOMENTIDataObject ds = new AMV_ARGOMENTIDataObject(page);
            ds.setComponent( model );
//End AMV_ARGOMENTI Grid: method read: init

//AMV_ARGOMENTI Grid: set grid properties @5-9A990644
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
            Hashtable sortAscColumns = new Hashtable();
            Hashtable sortDescColumns = new Hashtable();
            sortAscColumns.put( "Sorter_NOME", "NOME" );
            sortAscColumns.put( "Descrizione", "DESCRIZIONE" );
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
//End AMV_ARGOMENTI Grid: set grid properties

//AMV_ARGOMENTI Grid: retrieve data @5-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End AMV_ARGOMENTI Grid: retrieve data

//AMV_ARGOMENTI Grid: check errors @5-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End AMV_ARGOMENTI Grid: check errors

//AMV_ARGOMENTI Grid: method read: tail @5-F575E732
            return ( ! isErrors );
        }
//End AMV_ARGOMENTI Grid: method read: tail

//AMV_ARGOMENTI Grid: method bind @5-01456653
        public void bind(com.codecharge.components.Component model, AMV_ARGOMENTIRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            AMV_ARGOMENTIRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("NOME");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("NOME").clone();
                    c.setValue(row.getNOME());
                    hashRow.put( c.getName(), c );
                }
                ((com.codecharge.components.Link) c).getParameter("ID").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("ID").getSourceName(), row ));

                c = (com.codecharge.components.Control) hashRow.get("DESCRIZIONE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("DESCRIZIONE").clone();
                    c.setValue(row.getDESCRIZIONE());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End AMV_ARGOMENTI Grid: method bind

//AMV_ARGOMENTI Directory: getRowFieldByName @5-1E22A760
        public Object getRowFieldByName( String name, AMV_ARGOMENTIRow row ) {
            Object value = null;
            if ( "NOME".equals(name) ) {
                value = row.getNOME();
            } else if ( "DESCRIZIONE".equals(name) ) {
                value = row.getDESCRIZIONE();
            } else if ( "AFCNavigator".equals(name) ) {
                value = row.getAFCNavigator();
            } else if ( "ID".equals(name) ) {
                value = row.getID();
            } else if ( "ID_ARGOMENTO".equals(name) ) {
                value = row.getID_ARGOMENTO();
            }
            return value;
        }
//End AMV_ARGOMENTI Directory: getRowFieldByName

//AMV_ARGOMENTI Grid: method validate @5-104025BA
        boolean validate() {
            return true;
        }
//End AMV_ARGOMENTI Grid: method validate

//AMV_ARGOMENTI Grid Tail @5-FCB6E20C
    }
//End AMV_ARGOMENTI Grid Tail

//AMV_ARGOMENTI1 Record @14-9F8A1F8A
    final class AMV_ARGOMENTI1Class {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AMV_ARGOMENTI1 Record

//AMV_ARGOMENTI1 Record: method perform @14-4E82F9B5
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AdmArgomenti" + Names.ACTION_SUFFIX );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowInsert() ) model.getChild( "Insert" ).setVisible( false );
            if ( ! model.isAllowUpdate() ) model.getChild( "Update" ).setVisible( false );
            if ( ! model.isAllowDelete() ) model.getChild( "Delete" ).setVisible( false );
//End AMV_ARGOMENTI1 Record: method perform

//AMV_ARGOMENTI1 Record: children actions @14-69E801EB
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("AMV_ARGOMENTI1".equals(formName)) {
                setProperties(model, Action.POST);
                if (mode != -1) { // Update mode
                    model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                    if (page.getParameter("Update") != null) {
                        if (validate()) {
                            Update16Action();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Delete") != null) {
                        Delete17Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                    if (page.getParameter("Cancel") != null) {
                        Cancel18Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                } else { // Insert mode
                    model.setMode(com.codecharge.components.Record.INSERT_MODE);
                    if (page.getParameter("Insert") != null) {
                        if (validate()) {
                            Insert15Action();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Cancel") != null) {
                        Cancel18Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                }
            }
            setProperties(model, Action.GET, true );
            read();
//End AMV_ARGOMENTI1 Record: children actions

//AMV_ARGOMENTI1 Record: method perform tail @14-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AMV_ARGOMENTI1 Record: method perform tail

//Insert Button @15-31ABD8FC
        void Insert15Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Insert");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmArgomenti" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            InsertAction();
        }
//End Insert Button

//Update Button @16-6B1F445B
        void Update16Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Update");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmArgomenti" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Update Button

//Delete Button @17-E2155741
        void Delete17Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Delete");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmArgomenti" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            DeleteAction();
        }
//End Delete Button

//Cancel Button @18-8E5EB046
        void Cancel18Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Cancel");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmArgomenti" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
        }
//End Cancel Button

void read() { //AMV_ARGOMENTI1 Record: method read @14-7F8AAE5A

//AMV_ARGOMENTI1 Record: method read head @14-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AMV_ARGOMENTI1 Record: method read head

//AMV_ARGOMENTI1 Record: init DataSource @14-CB9A326E
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AMV_ARGOMENTI1DataObject ds = new AMV_ARGOMENTI1DataObject(page);
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
//End AMV_ARGOMENTI1 Record: init DataSource

//AMV_ARGOMENTI1 Record: check errors @14-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End AMV_ARGOMENTI1 Record: check errors

} //AMV_ARGOMENTI1 Record: method read tail @14-FCB6E20C

//AMV_ARGOMENTI1 Record: bind @14-56723F4F
            public void bind(com.codecharge.components.Component model, AMV_ARGOMENTI1Row row ) {
                if ( model == null || row == null ) return;
                if ( this.valid ) {
                    model.getControl("NOME").setValue(row.getNOME());
                    model.getControl("DESCRIZIONE").setValue(row.getDESCRIZIONE());
                    model.getControl("ID_ARGOMENTO").setValue(row.getID_ARGOMENTO());
                }
            }
//End AMV_ARGOMENTI1 Record: bind

//AMV_ARGOMENTI1 Record: getRowFieldByName @14-A30C3354
            public Object getRowFieldByName( String name, AMV_ARGOMENTI1Row row ) {
                Object value = null;
                if ( "NOME".equals(name) ) {
                    value = row.getNOME();
                } else if ( "DESCRIZIONE".equals(name) ) {
                    value = row.getDESCRIZIONE();
                } else if ( "ID_ARGOMENTO".equals(name) ) {
                    value = row.getID_ARGOMENTO();
                }
                return value;
            }
//End AMV_ARGOMENTI1 Record: getRowFieldByName

void InsertAction() { //AMV_ARGOMENTI1 Record: method insert @14-11643485

//AMV_ARGOMENTI1 Record: method insert head @14-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End AMV_ARGOMENTI1 Record: method insert head

//AMV_ARGOMENTI1 Record: method insert body @14-C55F4407
            if (!model.isAllowInsert()) return;
            boolean isErrors = false;
            AMV_ARGOMENTI1DataObject ds = new AMV_ARGOMENTI1DataObject(page);
            ds.setComponent( model );
            AMV_ARGOMENTI1Row row = new AMV_ARGOMENTI1Row();
            ds.setRow(row);
            row.setNOME(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "NOME" )).getValue()));
            row.setDESCRIZIONE(Utils.convertToString(((com.codecharge.components.TextArea) model.getControl( "DESCRIZIONE" )).getValue()));
            row.setID_ARGOMENTO(Utils.convertToLong(((com.codecharge.components.Hidden) model.getControl( "ID_ARGOMENTO" )).getValue()));
            ds.setRow(row);
//End AMV_ARGOMENTI1 Record: method insert body

//AMV_ARGOMENTI1 Record: ds.insert @14-9320B03B
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
//End AMV_ARGOMENTI1 Record: ds.insert

} //AMV_ARGOMENTI1 Record: method insert tail @14-FCB6E20C

void UpdateAction() { //AMV_ARGOMENTI1 Record: method update @14-5771D0AA

//AMV_ARGOMENTI1 Record: method update head @14-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End AMV_ARGOMENTI1 Record: method update head

//AMV_ARGOMENTI1 Record: method update body @14-8DFC11D0
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            AMV_ARGOMENTI1DataObject ds = new AMV_ARGOMENTI1DataObject(page);
            ds.setComponent( model );
            AMV_ARGOMENTI1Row row = new AMV_ARGOMENTI1Row();
            ds.setRow(row);
            row.setNOME(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "NOME" )).getValue()));
            row.setDESCRIZIONE(Utils.convertToString(((com.codecharge.components.TextArea) model.getControl( "DESCRIZIONE" )).getValue()));
            row.setID_ARGOMENTO(Utils.convertToLong(((com.codecharge.components.Hidden) model.getControl( "ID_ARGOMENTO" )).getValue()));
            ds.setRow(row);
            try {
                ds.setUrlID( page.getHttpGetParams().getParameter("ID"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID'" );
            }
//End AMV_ARGOMENTI1 Record: method update body

//AMV_ARGOMENTI1 Record: ds.update @14-6E956EDC
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
//End AMV_ARGOMENTI1 Record: ds.update

} //AMV_ARGOMENTI1 Record: method update tail @14-FCB6E20C

void DeleteAction() { //AMV_ARGOMENTI1 Record: method delete @14-11FC2E1E

//AMV_ARGOMENTI1 Record: method delete head @14-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End AMV_ARGOMENTI1 Record: method delete head

//AMV_ARGOMENTI1 Record: method delete body @14-B2493FB5
            if (!model.isAllowDelete()) return;
            boolean isErrors = false;
            AMV_ARGOMENTI1DataObject ds = new AMV_ARGOMENTI1DataObject(page);
            ds.setComponent( model );
            AMV_ARGOMENTI1Row row = new AMV_ARGOMENTI1Row();
            ds.setRow(row);
            try {
                ds.setUrlID( page.getHttpGetParams().getParameter("ID"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID'" );
            }
//End AMV_ARGOMENTI1 Record: method delete body

//AMV_ARGOMENTI1 Record: ds.delete @14-3584344F
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
//End AMV_ARGOMENTI1 Record: ds.delete

} //AMV_ARGOMENTI1 Record: method delete tail @14-FCB6E20C

//AMV_ARGOMENTI1 Record: method validate @14-AA80E073
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.TextBox NOME = (com.codecharge.components.TextBox) model.getChild( "NOME" );
            if (! NOME.validate()) { isControlError = true; }

            com.codecharge.components.TextArea DESCRIZIONE = (com.codecharge.components.TextArea) model.getChild( "DESCRIZIONE" );
            if (! DESCRIZIONE.validate()) { isControlError = true; }

            com.codecharge.components.Hidden ID_ARGOMENTO = (com.codecharge.components.Hidden) model.getChild( "ID_ARGOMENTO" );
            if (! ID_ARGOMENTO.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AMV_ARGOMENTI1 Record: method validate

//AMV_ARGOMENTI1 Record Tail @14-FCB6E20C
    }
//End AMV_ARGOMENTI1 Record Tail

//AdmArgomenti Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AdmArgomenti Page: method validate

//AdmArgomentiAction Tail @1-FCB6E20C
}
//End AdmArgomentiAction Tail

