//AmvRegistrazioneParametriAction imports @1-188577EA
package common.AmvRegistrazioneParametri;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvRegistrazioneParametriAction imports

//AmvRegistrazioneParametriAction class @1-54670742
public class AmvRegistrazioneParametriAction extends Action {

//End AmvRegistrazioneParametriAction class

//AmvRegistrazioneParametriAction: method perform @1-F67E5745
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvRegistrazioneParametriModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvRegistrazioneParametriModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvRegistrazioneParametriAction: method perform

//AmvRegistrazioneParametriAction: call children actions @1-DE2F5231
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
            PARAMETRIClass PARAMETRI = new PARAMETRIClass();
            if ( ( redirect = PARAMETRI.perform( page.getEditableGrid("PARAMETRI")) ) != null ) result = redirect;
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
//End AmvRegistrazioneParametriAction: call children actions

//PARAMETRI EditGrid @6-F059386A
    final class PARAMETRIClass {
        boolean valid = false;
        com.codecharge.components.EditableGrid model;
//End PARAMETRI EditGrid

//PARAMETRI EditGrid: method read: head @6-F8937F65
        boolean read() {
            boolean isErrors = false;
            if ( ! model.isAllowRead() ) return true;
            model.fireBeforeSelectEvent();
//End PARAMETRI EditGrid: method read: head

//PARAMETRI EditGrid: method read: init @6-BC9082A4
            if ( ! model.isAllowRead() ) return true;
            PARAMETRIDataObject ds = new PARAMETRIDataObject(page);
            ds.setComponent( model );
//End PARAMETRI EditGrid: method read: init

//PARAMETRI EditGrid: set where parameters @6-9CB26746
            try {
                ds.setSesMVRIC( SessionStorage.getInstance(req).getAttribute("MVRIC"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVRIC'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVRIC'" );
                return false;
            }
//End PARAMETRI EditGrid: set where parameters

//PARAMETRI EditGrid: set EditGrid properties @6-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End PARAMETRI EditGrid: set EditGrid properties

//PARAMETRI EditGrid: retrieve data @6-012A0CD3
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind(model, ds.getRows());
            }
            model.setCount( (int) ds.getAmountOfRows() );
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End PARAMETRI EditGrid: retrieve data

//PARAMETRI EditGrid: method read: tail @6-F575E732
            return ( ! isErrors );
        }
//End PARAMETRI EditGrid: method read: tail

//PARAMETRI EditGrid: method perform @6-19D6CAF6
        protected String perform(com.codecharge.components.EditableGrid model) {
            this.model = model;
            setProperties( model, Action.GET );
            setProperties( model, Action.POST );
            setActivePermissions( model );
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( page.getActionPageName() + Names.ACTION_SUFFIX );
            String queryStr = page.getHttpGetParams().toString( model.getExcludeParams() );
            performReturnPage.append( "?" + queryStr.toString() );
            page.setRedirectString( performReturnPage.toString() );
            model.processRows();
            if ( model.getName().equals(page.getHttpGetParams().getParameter("ccsForm")) ) {
                if (page.getParameter("Button_Submit") != null) {
                    if (validate()) {
                        Button_SubmitAction();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                }
            }
            read();
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End PARAMETRI EditGrid: method perform

//Button_Submit Button @10-0C060684
        void Button_SubmitAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Button_Submit");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( page.getActionPageName() + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            SubmitAction();
        }
//End Button_Submit Button

//PARAMETRI EditGrid: method SubmitAction head @6-3336ADCE
        void SubmitAction() {
            if ( !( model.isAllowInsert() || model.isAllowUpdate() || model.isAllowDelete() ) ) return;
            model.fireBeforeSubmitEvent();
            if ( !( model.isAllowInsert() || model.isAllowUpdate() || model.isAllowDelete() ) ) return;
            Iterator rows = model.getChildRows().iterator();
            ArrayList dsRows = new ArrayList();
            while ( rows.hasNext() ) {
                HashMap row = (HashMap) rows.next();
                PARAMETRIRow dsRow = new PARAMETRIRow();
                if (row.get(Names.CCS_ROW_IS_NOT_APPLY_KEY) == null) {
                    com.codecharge.components.Model m = null;
                    m = (com.codecharge.components.Model) row.get("NOME");
                    if ( m != null && m instanceof com.codecharge.components.Control) {
                        dsRow.setNOME(Utils.convertToString(((com.codecharge.components.Control) m).getValue()));
                    }
                    m = (com.codecharge.components.Model) row.get("VALORE");
                    if ( m != null && m instanceof com.codecharge.components.Control) {
                        dsRow.setVALORE(Utils.convertToString(((com.codecharge.components.Control) m).getValue()));
                    }
                    m = (com.codecharge.components.Model) row.get("NOME_PAR");
                    if ( m != null && m instanceof com.codecharge.components.Control) {
                        dsRow.setNOME_PAR(Utils.convertToString(((com.codecharge.components.Control) m).getValue()));
                    }
                    m = (com.codecharge.components.Model) row.get("ID_RIC");
                    if ( m != null && m instanceof com.codecharge.components.Control) {
                        dsRow.setID_RIC(Utils.convertToString(((com.codecharge.components.Control) m).getValue()));
                    }
                    if (row.get(Names.CCS_CACHED_COLUMNS) != null) {
                        dsRow.setCCSCachedColumns((ArrayList) row.get(Names.CCS_CACHED_COLUMNS));
                    }
                    if (row.get(Names.CCS_ROW_IS_NEW_KEY) != null) {
                        dsRow.setNew(true);
                        if (!model.isAllowInsert()) dsRow = null;
                    } else if (row.get(Names.CCS_ROW_IS_DELETE_KEY) != null) {
                        dsRow.setDeleted(true);
                        if (!model.isAllowDelete()) dsRow = null;
                    } else {
                        if (!model.isAllowUpdate()) dsRow = null;
                    }
                    if ( dsRow != null ) dsRows.add(dsRow);
                } else {
                    dsRow.setApply(false);
                }
            }
            PARAMETRIRow[] ds_Rows = new PARAMETRIRow[dsRows.size()];
            ds_Rows = (PARAMETRIRow[]) dsRows.toArray(ds_Rows);
            PARAMETRIDataObject ds = new PARAMETRIDataObject(page);
            ds.setComponent( model );
            ds.setRows(ds_Rows);
            try {
                ds.setUrlP_UTENTE( Utils.convertToString(page.getHttpGetParams().getParameter("P_UTENTE")) );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter" );
            }
            if ( ds_Rows.length > 0 ) ds.updateGrid();
            boolean[] rowResults = ds.getRowResults();
            Collection[] rowErrors = ds.getRowErrors();
            model.initializeRows();
            int i = 0;
            while ( model.hasNextRow() ) {
                HashMap row = model.nextRow();
                if ( i >= ds_Rows.length ) break;
                if (rowResults[i]) {
                    if (ds_Rows[i].isDeleted()) {
                    } else {
                    }
                } else {
                    ErrorCollection errCollection = (ErrorCollection) row.get(Names.CCS_ROW_ERROR_KEY);
                    if ( errCollection == null ) {
                        errCollection = new ErrorCollection();
                        row.put(Names.CCS_ROW_ERROR_KEY, errCollection);
                    }
                    errCollection.addErrors(rowErrors[i]);
                    page.setRedirectString(null);
                }
                i++;
            }
            model.fireAfterSubmitEvent();
//End PARAMETRI EditGrid: method SubmitAction head

//PARAMETRI EditGrid: method SubmitAction tail @6-6221662A
            return;
        }
//End PARAMETRI EditGrid: method SubmitAction tail

//PARAMETRI EditGrid: method validate @6-4D70B217
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isValid = true;
            model.checkUnique();
            Iterator rows = model.getChildRows().iterator();
            while ( rows.hasNext() ) {
                HashMap row = (HashMap) rows.next();
                if (row.get(Names.CCS_ROW_IS_NOT_APPLY_KEY) == null && row.get(Names.CCS_ROW_IS_DELETE_KEY) == null) {
                    ErrorCollection rowErrors = (ErrorCollection) row.get(Names.CCS_ROW_ERROR_KEY);
                    if ( rowErrors == null ) {
                        rowErrors = new ErrorCollection();
                        row.put(Names.CCS_ROW_ERROR_KEY, rowErrors);
                    }
                    boolean isControlError = false;

                    com.codecharge.components.TextBox VALORE = (com.codecharge.components.TextBox) row.get( "VALORE" );
                    if (! VALORE.validate()) { isControlError = true; }

                    com.codecharge.components.Hidden NOME_PAR = (com.codecharge.components.Hidden) row.get( "NOME_PAR" );
                    if (! NOME_PAR.validate()) { isControlError = true; }

                    com.codecharge.components.Hidden ID_RIC = (com.codecharge.components.Hidden) row.get( "ID_RIC" );
                    if (! ID_RIC.validate()) { isControlError = true; }
                    if (isControlError || rowErrors.hasErrors()) {
                        isValid = false;
                    }
                } // end if row is applied and is not deleted
            }
            this.valid = isValid;
            return isValid;
        }
//End PARAMETRI EditGrid: method validate

//PARAMETRI EditGrid: bind @6-2C4473C7
        public void bind(com.codecharge.components.Component model, PARAMETRIRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            PARAMETRIRow row = null;
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

                com.codecharge.components.Model m = (com.codecharge.components.Model) hashRow.get("CheckBox_Delete");
                if ( m == null ) { 
                    m = model.getChild("CheckBox_Delete");
                    if ( m instanceof com.codecharge.components.Control ) { 
                        c = (com.codecharge.components.Control) ((com.codecharge.components.Control) m).clone(); 
                        c.setValue(null);
                        hashRow.put( c.getName(), c );
                    }
                }

                c = (com.codecharge.components.Control) hashRow.get("NOME");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("NOME").clone();
                    c.setValue(row.getNOME());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("VALORE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("VALORE").clone();
                    c.setValue(row.getVALORE());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("NOME_PAR");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("NOME_PAR").clone();
                    c.setValue(row.getNOME_PAR());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("ID_RIC");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("ID_RIC").clone();
                    c.setValue(row.getID_RIC());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End PARAMETRI EditGrid: bind

//PARAMETRI EditGrid: getRowFieldByName @6-95E64FD3
        public Object getRowFieldByName( String name, PARAMETRIRow row ) {
            Object value = null;
            if ( "NOME".equals(name) ) {
                value = row.getNOME();
            } else if ( "VALORE".equals(name) ) {
                value = row.getVALORE();
            } else if ( "NOME_PAR".equals(name) ) {
                value = row.getNOME_PAR();
            } else if ( "ID_RIC".equals(name) ) {
                value = row.getID_RIC();
            } else if ( "CheckBox_Delete".equals(name) ) {
                value = row.getCheckBox_Delete();
            }
            return value;
        }
//End PARAMETRI EditGrid: getRowFieldByName

//PARAMETRI EditGrid Tail @6-FCB6E20C
    }
//End PARAMETRI EditGrid Tail

//AmvRegistrazioneParametri Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvRegistrazioneParametri Page: method validate

//AmvRegistrazioneParametriAction Tail @1-FCB6E20C
}
//End AmvRegistrazioneParametriAction Tail
