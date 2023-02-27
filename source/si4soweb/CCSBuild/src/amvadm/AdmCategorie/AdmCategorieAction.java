//AdmCategorieAction imports @1-8349EBAF
package amvadm.AdmCategorie;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmCategorieAction imports

//AdmCategorieAction class @1-5E1FD9AA
public class AdmCategorieAction extends Action {

//End AdmCategorieAction class

//AdmCategorieAction: method perform @1-03E9AA25
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AdmCategorieModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AdmCategorieModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AdmCategorieAction: method perform

//AdmCategorieAction: call children actions @1-FC66EF3D
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
            AMV_CATEGORIEClass AMV_CATEGORIE = new AMV_CATEGORIEClass();
            AMV_CATEGORIE.perform(page.getGrid("AMV_CATEGORIE"));
        }
        if (result == null) {
            AMV_CATEGORIE1Class AMV_CATEGORIE1 = new AMV_CATEGORIE1Class();
            if ( ( redirect = AMV_CATEGORIE1.perform( page.getRecord("AMV_CATEGORIE1")) ) != null ) result = redirect;
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
//End AdmCategorieAction: call children actions

//AMV_CATEGORIE Grid @2-019BD283
    final class AMV_CATEGORIEClass {
        com.codecharge.components.Grid model;
        Event e;
//End AMV_CATEGORIE Grid

//AMV_CATEGORIE Grid: method perform @2-B48879D3
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
//End AMV_CATEGORIE Grid: method perform

//AMV_CATEGORIE Grid: method read: head @2-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End AMV_CATEGORIE Grid: method read: head

//AMV_CATEGORIE Grid: method read: init @2-8BE34EB1
            if ( ! model.allowRead ) return true;
            AMV_CATEGORIEDataObject ds = new AMV_CATEGORIEDataObject(page);
            ds.setComponent( model );
//End AMV_CATEGORIE Grid: method read: init

//AMV_CATEGORIE Grid: set grid properties @2-2FB624D9
            
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
//End AMV_CATEGORIE Grid: set grid properties

//AMV_CATEGORIE Grid: retrieve data @2-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End AMV_CATEGORIE Grid: retrieve data

//AMV_CATEGORIE Grid: check errors @2-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End AMV_CATEGORIE Grid: check errors

//AMV_CATEGORIE Grid: method read: tail @2-F575E732
            return ( ! isErrors );
        }
//End AMV_CATEGORIE Grid: method read: tail

//AMV_CATEGORIE Grid: method bind @2-17F30040
        public void bind(com.codecharge.components.Component model, AMV_CATEGORIERow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            AMV_CATEGORIERow row = null;
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
//End AMV_CATEGORIE Grid: method bind

//AMV_CATEGORIE Directory: getRowFieldByName @2-E670B783
        public Object getRowFieldByName( String name, AMV_CATEGORIERow row ) {
            Object value = null;
            if ( "NOME".equals(name) ) {
                value = row.getNOME();
            } else if ( "DESCRIZIONE".equals(name) ) {
                value = row.getDESCRIZIONE();
            } else if ( "AFCNavigator".equals(name) ) {
                value = row.getAFCNavigator();
            } else if ( "ID".equals(name) ) {
                value = row.getID();
            } else if ( "ID_CATEGORIA".equals(name) ) {
                value = row.getID_CATEGORIA();
            }
            return value;
        }
//End AMV_CATEGORIE Directory: getRowFieldByName

//AMV_CATEGORIE Grid: method validate @2-104025BA
        boolean validate() {
            return true;
        }
//End AMV_CATEGORIE Grid: method validate

//AMV_CATEGORIE Grid Tail @2-FCB6E20C
    }
//End AMV_CATEGORIE Grid Tail

//AMV_CATEGORIE1 Record @11-C6FD5123
    final class AMV_CATEGORIE1Class {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AMV_CATEGORIE1 Record

//AMV_CATEGORIE1 Record: method perform @11-057BEBDC
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AdmCategorie" + Names.ACTION_SUFFIX );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowInsert() ) model.getChild( "Insert" ).setVisible( false );
            if ( ! model.isAllowUpdate() ) model.getChild( "Update" ).setVisible( false );
            if ( ! model.isAllowDelete() ) model.getChild( "Delete" ).setVisible( false );
//End AMV_CATEGORIE1 Record: method perform

//AMV_CATEGORIE1 Record: children actions @11-EFE93430
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("AMV_CATEGORIE1".equals(formName)) {
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
//End AMV_CATEGORIE1 Record: children actions

//AMV_CATEGORIE1 Record: method perform tail @11-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AMV_CATEGORIE1 Record: method perform tail

//Insert Button @16-A0F6F3F9
        void Insert16Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Insert");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmCategorie" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            InsertAction();
        }
//End Insert Button

//Update Button @17-C28423A8
        void Update17Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Update");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmCategorie" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Update Button

//Delete Button @18-E1DDD670
        void Delete18Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Delete");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmCategorie" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            DeleteAction();
        }
//End Delete Button

//Cancel Button @19-62C05CBC
        void Cancel19Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Cancel");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmCategorie" + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
        }
//End Cancel Button

void read() { //AMV_CATEGORIE1 Record: method read @11-7F8AAE5A

//AMV_CATEGORIE1 Record: method read head @11-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AMV_CATEGORIE1 Record: method read head

//AMV_CATEGORIE1 Record: init DataSource @11-2B570215
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AMV_CATEGORIE1DataObject ds = new AMV_CATEGORIE1DataObject(page);
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
//End AMV_CATEGORIE1 Record: init DataSource

//AMV_CATEGORIE1 Record: check errors @11-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End AMV_CATEGORIE1 Record: check errors

} //AMV_CATEGORIE1 Record: method read tail @11-FCB6E20C

//AMV_CATEGORIE1 Record: bind @11-E45AD724
            public void bind(com.codecharge.components.Component model, AMV_CATEGORIE1Row row ) {
                if ( model == null || row == null ) return;
                if ( this.valid ) {
                    model.getControl("NOME").setValue(row.getNOME());
                    model.getControl("DESCRIZIONE").setValue(row.getDESCRIZIONE());
                    model.getControl("ID_CATEGORIA").setValue(row.getID_CATEGORIA());
                }
            }
//End AMV_CATEGORIE1 Record: bind

//AMV_CATEGORIE1 Record: getRowFieldByName @11-92383AFF
            public Object getRowFieldByName( String name, AMV_CATEGORIE1Row row ) {
                Object value = null;
                if ( "NOME".equals(name) ) {
                    value = row.getNOME();
                } else if ( "DESCRIZIONE".equals(name) ) {
                    value = row.getDESCRIZIONE();
                } else if ( "ID_CATEGORIA".equals(name) ) {
                    value = row.getID_CATEGORIA();
                }
                return value;
            }
//End AMV_CATEGORIE1 Record: getRowFieldByName

void InsertAction() { //AMV_CATEGORIE1 Record: method insert @11-11643485

//AMV_CATEGORIE1 Record: method insert head @11-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End AMV_CATEGORIE1 Record: method insert head

//AMV_CATEGORIE1 Record: method insert body @11-57F30CBE
            if (!model.isAllowInsert()) return;
            boolean isErrors = false;
            AMV_CATEGORIE1DataObject ds = new AMV_CATEGORIE1DataObject(page);
            ds.setComponent( model );
            AMV_CATEGORIE1Row row = new AMV_CATEGORIE1Row();
            ds.setRow(row);
            row.setNOME(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "NOME" )).getValue()));
            row.setDESCRIZIONE(Utils.convertToString(((com.codecharge.components.TextArea) model.getControl( "DESCRIZIONE" )).getValue()));
            row.setID_CATEGORIA(Utils.convertToLong(((com.codecharge.components.Hidden) model.getControl( "ID_CATEGORIA" )).getValue()));
            ds.setRow(row);
//End AMV_CATEGORIE1 Record: method insert body

//AMV_CATEGORIE1 Record: ds.insert @11-9320B03B
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
//End AMV_CATEGORIE1 Record: ds.insert

} //AMV_CATEGORIE1 Record: method insert tail @11-FCB6E20C

void UpdateAction() { //AMV_CATEGORIE1 Record: method update @11-5771D0AA

//AMV_CATEGORIE1 Record: method update head @11-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End AMV_CATEGORIE1 Record: method update head

//AMV_CATEGORIE1 Record: method update body @11-FDB2FA46
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            AMV_CATEGORIE1DataObject ds = new AMV_CATEGORIE1DataObject(page);
            ds.setComponent( model );
            AMV_CATEGORIE1Row row = new AMV_CATEGORIE1Row();
            ds.setRow(row);
            row.setNOME(Utils.convertToString(((com.codecharge.components.TextBox) model.getControl( "NOME" )).getValue()));
            row.setDESCRIZIONE(Utils.convertToString(((com.codecharge.components.TextArea) model.getControl( "DESCRIZIONE" )).getValue()));
            row.setID_CATEGORIA(Utils.convertToLong(((com.codecharge.components.Hidden) model.getControl( "ID_CATEGORIA" )).getValue()));
            ds.setRow(row);
            try {
                ds.setUrlID( page.getHttpGetParams().getParameter("ID"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID'" );
            }
//End AMV_CATEGORIE1 Record: method update body

//AMV_CATEGORIE1 Record: ds.update @11-6E956EDC
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
//End AMV_CATEGORIE1 Record: ds.update

} //AMV_CATEGORIE1 Record: method update tail @11-FCB6E20C

void DeleteAction() { //AMV_CATEGORIE1 Record: method delete @11-11FC2E1E

//AMV_CATEGORIE1 Record: method delete head @11-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End AMV_CATEGORIE1 Record: method delete head

//AMV_CATEGORIE1 Record: method delete body @11-7541E6A7
            if (!model.isAllowDelete()) return;
            boolean isErrors = false;
            AMV_CATEGORIE1DataObject ds = new AMV_CATEGORIE1DataObject(page);
            ds.setComponent( model );
            AMV_CATEGORIE1Row row = new AMV_CATEGORIE1Row();
            ds.setRow(row);
            try {
                ds.setUrlID( page.getHttpGetParams().getParameter("ID"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID'" );
            }
//End AMV_CATEGORIE1 Record: method delete body

//AMV_CATEGORIE1 Record: ds.delete @11-3584344F
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
//End AMV_CATEGORIE1 Record: ds.delete

} //AMV_CATEGORIE1 Record: method delete tail @11-FCB6E20C

//AMV_CATEGORIE1 Record: method validate @11-EE87E7CC
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.TextBox NOME = (com.codecharge.components.TextBox) model.getChild( "NOME" );
            if (! NOME.validate()) { isControlError = true; }

            com.codecharge.components.TextArea DESCRIZIONE = (com.codecharge.components.TextArea) model.getChild( "DESCRIZIONE" );
            if (! DESCRIZIONE.validate()) { isControlError = true; }

            com.codecharge.components.Hidden ID_CATEGORIA = (com.codecharge.components.Hidden) model.getChild( "ID_CATEGORIA" );
            if (! ID_CATEGORIA.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AMV_CATEGORIE1 Record: method validate

//AMV_CATEGORIE1 Record Tail @11-FCB6E20C
    }
//End AMV_CATEGORIE1 Record Tail

//AdmCategorie Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AdmCategorie Page: method validate

//AdmCategorieAction Tail @1-FCB6E20C
}
//End AdmCategorieAction Tail

