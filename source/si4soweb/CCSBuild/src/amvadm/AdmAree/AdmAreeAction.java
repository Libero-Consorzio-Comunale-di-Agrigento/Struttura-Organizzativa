//AdmAreeAction imports @1-8F973797
package amvadm.AdmAree;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmAreeAction imports

//AdmAreeAction class @1-89C98F8A
public class AdmAreeAction extends Action {

//End AdmAreeAction class

//AdmAreeAction: method perform @1-45BA24F8
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AdmAreeModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AdmAreeModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AdmAreeAction: method perform

//AdmAreeAction: call children actions @1-479D3D0C
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
            AMV_AREEClass AMV_AREE = new AMV_AREEClass();
            AMV_AREE.perform(page.getGrid("AMV_AREE"));
        }
        if (result == null) {
            AMV_AREE1Class AMV_AREE1 = new AMV_AREE1Class();
            if ( ( redirect = AMV_AREE1.perform( page.getRecord("AMV_AREE1")) ) != null ) result = redirect;
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
//End AdmAreeAction: call children actions

//AMV_AREE Grid @2-1001D9BB
    final class AMV_AREEClass {
        com.codecharge.components.Grid model;
        Event e;
//End AMV_AREE Grid

//AMV_AREE Grid: method perform @2-B48879D3
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
//End AMV_AREE Grid: method perform

//AMV_AREE Grid: method read: head @2-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End AMV_AREE Grid: method read: head

//AMV_AREE Grid: method read: init @2-FCED8344
            if ( ! model.allowRead ) return true;
            AMV_AREEDataObject ds = new AMV_AREEDataObject(page);
            ds.setComponent( model );
//End AMV_AREE Grid: method read: init

//AMV_AREE Grid: set grid properties @2-2FB624D9
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
            Hashtable sortAscColumns = new Hashtable();
            Hashtable sortDescColumns = new Hashtable();
            sortAscColumns.put( "Sorter_NOME", "NOME" );
            sortAscColumns.put( "Sorter_DESCRIZIONE", "DESCRIZIONE" );
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
//End AMV_AREE Grid: set grid properties

//AMV_AREE Grid: retrieve data @2-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End AMV_AREE Grid: retrieve data

//AMV_AREE Grid: check errors @2-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End AMV_AREE Grid: check errors

//AMV_AREE Grid: method read: tail @2-F575E732
            return ( ! isErrors );
        }
//End AMV_AREE Grid: method read: tail

//AMV_AREE Grid: method bind @2-07312F7B
        public void bind(com.codecharge.components.Component model, AMV_AREERow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            AMV_AREERow row = null;
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
//End AMV_AREE Grid: method bind

//AMV_AREE Directory: getRowFieldByName @2-7F44670E
        public Object getRowFieldByName( String name, AMV_AREERow row ) {
            Object value = null;
            if ( "NOME".equals(name) ) {
                value = row.getNOME();
            } else if ( "DESCRIZIONE".equals(name) ) {
                value = row.getDESCRIZIONE();
            } else if ( "AFCNavigator".equals(name) ) {
                value = row.getAFCNavigator();
            } else if ( "ID".equals(name) ) {
                value = row.getID();
            } else if ( "ID_AREA".equals(name) ) {
                value = row.getID_AREA();
            }
            return value;
        }
//End AMV_AREE Directory: getRowFieldByName

//AMV_AREE Grid: method validate @2-104025BA
        boolean validate() {
            return true;
        }
//End AMV_AREE Grid: method validate

//AMV_AREE Grid Tail @2-FCB6E20C
    }
//End AMV_AREE Grid Tail

//AMV_AREE1 Record @11-C58DE607
    final class AMV_AREE1Class {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AMV_AREE1 Record

//AMV_AREE1 Record: method perform @11-16F32974
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AdmAree" + Names.ACTION_SUFFIX );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowInsert() ) model.getChild( "Insert" ).setVisible( false );
            if ( ! model.isAllowUpdate() ) model.getChild( "Update" ).setVisible( false );
            if ( ! model.isAllowDelete() ) model.getChild( "Delete" ).setVisible( false );
//End AMV_AREE1 Record: method perform

//AMV_AREE1 Record: children actions @11-400DB19F
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("AMV_AREE1".equals(formName)) {
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
//End AMV_AREE1 Record: children actions

//AMV_AREE1 Record: method perform tail @11-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AMV_AREE1 Record: method perform tail

//Insert Button @16-F1FDCF08
        void Insert16Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Insert");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmAree" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            InsertAction();
        }
//End Insert Button

//Update Button @17-A5E9CB2A
        void Update17Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Update");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmAree" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Update Button

//Delete Button @18-4BA8AD3B
        void Delete18Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Delete");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmAree" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            DeleteAction();
        }
//End Delete Button

//Cancel Button @19-4CFBE6C4
        void Cancel19Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Cancel");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmAree" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
        }
//End Cancel Button

void read() { //AMV_AREE1 Record: method read @11-7F8AAE5A

//AMV_AREE1 Record: method read head @11-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AMV_AREE1 Record: method read head

//AMV_AREE1 Record: init DataSource @11-505420C2
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AMV_AREE1DataObject ds = new AMV_AREE1DataObject(page);
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
//End AMV_AREE1 Record: init DataSource

//AMV_AREE1 Record: check errors @11-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End AMV_AREE1 Record: check errors

} //AMV_AREE1 Record: method read tail @11-FCB6E20C

//AMV_AREE1 Record: bind @11-B3412616
            public void bind(com.codecharge.components.Component model, AMV_AREE1Row row ) {
                if ( model == null || row == null ) return;
                if ( this.valid ) {
                    model.getControl("NOME").setValue(row.getNOME());
                    model.getControl("DESCRIZIONE").setValue(row.getDESCRIZIONE());
                    model.getControl("ID_AREA").setValue(row.getID_AREA());
                }
            }
//End AMV_AREE1 Record: bind

//AMV_AREE1 Record: getRowFieldByName @11-7318AAB5
            public Object getRowFieldByName( String name, AMV_AREE1Row row ) {
                Object value = null;
                if ( "NOME".equals(name) ) {
                    value = row.getNOME();
                } else if ( "DESCRIZIONE".equals(name) ) {
                    value = row.getDESCRIZIONE();
                } else if ( "ID_AREA".equals(name) ) {
                    value = row.getID_AREA();
                }
                return value;
            }
//End AMV_AREE1 Record: getRowFieldByName

void InsertAction() { //AMV_AREE1 Record: method insert @11-11643485

//AMV_AREE1 Record: method insert head @11-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End AMV_AREE1 Record: method insert head

//AMV_AREE1 Record: method insert body @11-CBA13453
            if (!model.isAllowInsert()) return;
            boolean isErrors = false;
            AMV_AREE1DataObject ds = new AMV_AREE1DataObject(page);
            ds.setComponent( model );
            AMV_AREE1Row row = new AMV_AREE1Row();
            ds.setRow(row);
            row.setNOME(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "NOME" )).getValue()));
            row.setDESCRIZIONE(Utils.convertToString(((com.codecharge.components.TextArea) model.getControl( "DESCRIZIONE" )).getValue()));
            row.setID_AREA(Utils.convertToLong(((com.codecharge.components.Hidden) model.getControl( "ID_AREA" )).getValue()));
            ds.setRow(row);
//End AMV_AREE1 Record: method insert body

//AMV_AREE1 Record: ds.insert @11-9320B03B
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
//End AMV_AREE1 Record: ds.insert

} //AMV_AREE1 Record: method insert tail @11-FCB6E20C

void UpdateAction() { //AMV_AREE1 Record: method update @11-5771D0AA

//AMV_AREE1 Record: method update head @11-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End AMV_AREE1 Record: method update head

//AMV_AREE1 Record: method update body @11-399C6D71
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            AMV_AREE1DataObject ds = new AMV_AREE1DataObject(page);
            ds.setComponent( model );
            AMV_AREE1Row row = new AMV_AREE1Row();
            ds.setRow(row);
            row.setNOME(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "NOME" )).getValue()));
            row.setDESCRIZIONE(Utils.convertToString(((com.codecharge.components.TextArea) model.getControl( "DESCRIZIONE" )).getValue()));
            row.setID_AREA(Utils.convertToLong(((com.codecharge.components.Hidden) model.getControl( "ID_AREA" )).getValue()));
            ds.setRow(row);
            try {
                ds.setUrlID( page.getHttpGetParams().getParameter("ID"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID'" );
            }
//End AMV_AREE1 Record: method update body

//AMV_AREE1 Record: ds.update @11-6E956EDC
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
//End AMV_AREE1 Record: ds.update

} //AMV_AREE1 Record: method update tail @11-FCB6E20C

void DeleteAction() { //AMV_AREE1 Record: method delete @11-11FC2E1E

//AMV_AREE1 Record: method delete head @11-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End AMV_AREE1 Record: method delete head

//AMV_AREE1 Record: method delete body @11-4C61E7D4
            if (!model.isAllowDelete()) return;
            boolean isErrors = false;
            AMV_AREE1DataObject ds = new AMV_AREE1DataObject(page);
            ds.setComponent( model );
            AMV_AREE1Row row = new AMV_AREE1Row();
            ds.setRow(row);
            try {
                ds.setUrlID( page.getHttpGetParams().getParameter("ID"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID'" );
            }
//End AMV_AREE1 Record: method delete body

//AMV_AREE1 Record: ds.delete @11-3584344F
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
//End AMV_AREE1 Record: ds.delete

} //AMV_AREE1 Record: method delete tail @11-FCB6E20C

//AMV_AREE1 Record: method validate @11-5A89E2D2
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.TextBox NOME = (com.codecharge.components.TextBox) model.getChild( "NOME" );
            if (! NOME.validate()) { isControlError = true; }

            com.codecharge.components.TextArea DESCRIZIONE = (com.codecharge.components.TextArea) model.getChild( "DESCRIZIONE" );
            if (! DESCRIZIONE.validate()) { isControlError = true; }

            com.codecharge.components.Hidden ID_AREA = (com.codecharge.components.Hidden) model.getChild( "ID_AREA" );
            if (! ID_AREA.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AMV_AREE1 Record: method validate

//AMV_AREE1 Record Tail @11-FCB6E20C
    }
//End AMV_AREE1 Record Tail

//AdmAree Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AdmAree Page: method validate

//AdmAreeAction Tail @1-FCB6E20C
}
//End AdmAreeAction Tail

