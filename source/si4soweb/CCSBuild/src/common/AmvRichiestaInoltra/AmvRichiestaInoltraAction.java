//AmvRichiestaInoltraAction imports @1-CDDE06B4
package common.AmvRichiestaInoltra;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvRichiestaInoltraAction imports

//AmvRichiestaInoltraAction class @1-A04CCE68
public class AmvRichiestaInoltraAction extends Action {

//End AmvRichiestaInoltraAction class

//AmvRichiestaInoltraAction: method perform @1-84318E0E
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvRichiestaInoltraModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvRichiestaInoltraModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvRichiestaInoltraAction: method perform

//AmvRichiestaInoltraAction: call children actions @1-88A0C3C0
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
            RICHIESTA_INOLTRAClass RICHIESTA_INOLTRA = new RICHIESTA_INOLTRAClass();
            if ( ( redirect = RICHIESTA_INOLTRA.perform( page.getRecord("RICHIESTA_INOLTRA")) ) != null ) result = redirect;
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
//End AmvRichiestaInoltraAction: call children actions

//RICHIESTA_INOLTRA Record @6-9C060495
    final class RICHIESTA_INOLTRAClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End RICHIESTA_INOLTRA Record

//RICHIESTA_INOLTRA Record: method perform @6-07F7F23F
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "../restrict/AmvRichiesteAutore" + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowUpdate() ) model.getChild( "Update" ).setVisible( false );
//End RICHIESTA_INOLTRA Record: method perform

//RICHIESTA_INOLTRA Record: children actions @6-C53228E4
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("RICHIESTA_INOLTRA".equals(formName)) {
                setProperties(model, Action.POST);
                if (mode != -1) { // Update mode
                    model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                    if (page.getParameter("Update") != null) {
                        if (validate()) {
                            Update41Action();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Cancel") != null) {
                        Cancel13Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                } else { // Insert mode
                    model.setMode(com.codecharge.components.Record.INSERT_MODE);
                    if (page.getParameter("Cancel") != null) {
                        Cancel13Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                }
            }
            setProperties(model, Action.GET, true );
            read();
//End RICHIESTA_INOLTRA Record: children actions

//RICHIESTA_INOLTRA Record: method perform tail @6-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End RICHIESTA_INOLTRA Record: method perform tail

//Update Button @41-328A2CD6
        void Update41Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Update");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "../restrict/AmvRichiesteAutore" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Update Button

//Cancel Button @13-B49DF67C
        void Cancel13Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Cancel");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "../restrict/AmvRichiesteAutore" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
        }
//End Cancel Button

void read() { //RICHIESTA_INOLTRA Record: method read @6-7F8AAE5A

//RICHIESTA_INOLTRA Record: method read head @6-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End RICHIESTA_INOLTRA Record: method read head

//RICHIESTA_INOLTRA Record: init DataSource @6-23302671
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            RICHIESTA_INOLTRADataObject ds = new RICHIESTA_INOLTRADataObject(page);
            ds.setComponent( model );
            try {
                ds.setSesMVIDRIC( SessionStorage.getInstance(req).getAttribute("MVIDRIC"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVIDRIC'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVIDRIC'" );
            }
            try {
                ds.setSesMVREVRIC( SessionStorage.getInstance(req).getAttribute("MVREVRIC"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVREVRIC'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVREVRIC'" );
            }
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End RICHIESTA_INOLTRA Record: init DataSource

//RICHIESTA_INOLTRA Record: check errors @6-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End RICHIESTA_INOLTRA Record: check errors

} //RICHIESTA_INOLTRA Record: method read tail @6-FCB6E20C

//RICHIESTA_INOLTRA Record: bind @6-31651C44
            public void bind(com.codecharge.components.Component model, RICHIESTA_INOLTRARow row ) {
                if ( model == null || row == null ) return;
                model.getControl("TITOLO").setValue(row.getTITOLO());
                model.getControl("DATA_INSERIMENTO").setValue(row.getDATA_INSERIMENTO());
                model.getControl("NOMINATIVO_AUTORE").setValue(row.getNOMINATIVO_AUTORE());
                model.getControl("DATA_AGGIORNAMENTO").setValue(row.getDATA_AGGIORNAMENTO());
                model.getControl("NOMINATIVO_AGGIORNAMENTO").setValue(row.getNOMINATIVO_AGGIORNAMENTO());
                model.getControl("CRONOLOGIA").setValue(row.getCRONOLOGIA());
                model.getControl("NOTE_LABEL").setValue(row.getNOTE_LABEL());
                if ( this.valid ) {
                    model.getControl("NOTE").setValue(row.getNOTE());
                    model.getControl("REVISIONE").setValue(row.getREVISIONE());
                    model.getControl("ID_DOCUMENTO").setValue(row.getID_DOCUMENTO());
                    model.getControl("STATO_FUTURO").setValue(row.getSTATO_FUTURO());
                }
            }
//End RICHIESTA_INOLTRA Record: bind

//RICHIESTA_INOLTRA Record: getRowFieldByName @6-06D4C49D
            public Object getRowFieldByName( String name, RICHIESTA_INOLTRARow row ) {
                Object value = null;
                if ( "TITOLO".equals(name) ) {
                    value = row.getTITOLO();
                } else if ( "DATA_INSERIMENTO".equals(name) ) {
                    value = row.getDATA_INSERIMENTO();
                } else if ( "NOMINATIVO_AUTORE".equals(name) ) {
                    value = row.getNOMINATIVO_AUTORE();
                } else if ( "DATA_AGGIORNAMENTO".equals(name) ) {
                    value = row.getDATA_AGGIORNAMENTO();
                } else if ( "NOMINATIVO_AGGIORNAMENTO".equals(name) ) {
                    value = row.getNOMINATIVO_AGGIORNAMENTO();
                } else if ( "NOTE".equals(name) ) {
                    value = row.getNOTE();
                } else if ( "CRONOLOGIA".equals(name) ) {
                    value = row.getCRONOLOGIA();
                } else if ( "NOTE_LABEL".equals(name) ) {
                    value = row.getNOTE_LABEL();
                } else if ( "REVISIONE".equals(name) ) {
                    value = row.getREVISIONE();
                } else if ( "ID_DOCUMENTO".equals(name) ) {
                    value = row.getID_DOCUMENTO();
                } else if ( "STATO_FUTURO".equals(name) ) {
                    value = row.getSTATO_FUTURO();
                }
                return value;
            }
//End RICHIESTA_INOLTRA Record: getRowFieldByName

void InsertAction() { //RICHIESTA_INOLTRA Record: method insert @6-11643485

//RICHIESTA_INOLTRA Record: components insert actions @6-68525650
            if (! model.hasErrors()) {
            }
//End RICHIESTA_INOLTRA Record: components insert actions

} //RICHIESTA_INOLTRA Record: method insert tail @6-FCB6E20C

void UpdateAction() { //RICHIESTA_INOLTRA Record: method update @6-5771D0AA

//RICHIESTA_INOLTRA Record: method update head @6-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End RICHIESTA_INOLTRA Record: method update head

//RICHIESTA_INOLTRA Record: method update body @6-7E89AEBD
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            RICHIESTA_INOLTRADataObject ds = new RICHIESTA_INOLTRADataObject(page);
            ds.setComponent( model );
            RICHIESTA_INOLTRARow row = new RICHIESTA_INOLTRARow();
            ds.setRow(row);
            try {
                ds.setSesMVIDRIC( SessionStorage.getInstance(req).getAttribute("MVIDRIC"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVIDRIC'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVIDRIC'" );
            }
            try {
                ds.setSesMVREVRIC( SessionStorage.getInstance(req).getAttribute("MVREVRIC"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVREVRIC'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVREVRIC'" );
            }
            ds.setSesMVSF( SessionStorage.getInstance(req).getAttribute("MVSF") );
            ds.setUrlP_NOTE( page.getHttpGetParams().getParameter("P_NOTE") );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setUrlP_DESTINATARIO( page.getHttpGetParams().getParameter("P_DESTINATARIO") );
//End RICHIESTA_INOLTRA Record: method update body

//RICHIESTA_INOLTRA Record: ds.update @6-6E956EDC
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
//End RICHIESTA_INOLTRA Record: ds.update

} //RICHIESTA_INOLTRA Record: method update tail @6-FCB6E20C

void DeleteAction() { //RICHIESTA_INOLTRA Record: method delete @6-11FC2E1E

//RICHIESTA_INOLTRA Record: method delete head @6-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End RICHIESTA_INOLTRA Record: method delete head

//RICHIESTA_INOLTRA Record: method delete body @6-E894F3D0
            if (!model.isAllowDelete()) return;
            boolean isErrors = false;
            RICHIESTA_INOLTRADataObject ds = new RICHIESTA_INOLTRADataObject(page);
            ds.setComponent( model );
            RICHIESTA_INOLTRARow row = new RICHIESTA_INOLTRARow();
            ds.setRow(row);
            try {
                ds.setSesMVIDRIC( SessionStorage.getInstance(req).getAttribute("MVIDRIC"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVIDRIC'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVIDRIC'" );
            }
            try {
                ds.setSesMVREVRIC( SessionStorage.getInstance(req).getAttribute("MVREVRIC"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVREVRIC'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVREVRIC'" );
            }
            ds.setSesMVSF( SessionStorage.getInstance(req).getAttribute("MVSF") );
            ds.setPostNOTE( page.getHttpPostParams().getParameter("NOTE") );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setPostUTENTE_REDAZIONE( page.getHttpPostParams().getParameter("UTENTE_REDAZIONE") );
//End RICHIESTA_INOLTRA Record: method delete body

//RICHIESTA_INOLTRA Record: ds.delete @6-3584344F
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
//End RICHIESTA_INOLTRA Record: ds.delete

} //RICHIESTA_INOLTRA Record: method delete tail @6-FCB6E20C

//RICHIESTA_INOLTRA Record: method validate @6-4C1F317C
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.TextArea NOTE = (com.codecharge.components.TextArea) model.getChild( "NOTE" );
            if (! NOTE.validate()) { isControlError = true; }

            com.codecharge.components.Hidden REVISIONE = (com.codecharge.components.Hidden) model.getChild( "REVISIONE" );
            if (! REVISIONE.validate()) { isControlError = true; }

            com.codecharge.components.Hidden ID_DOCUMENTO = (com.codecharge.components.Hidden) model.getChild( "ID_DOCUMENTO" );
            if (! ID_DOCUMENTO.validate()) { isControlError = true; }

            com.codecharge.components.Hidden STATO_FUTURO = (com.codecharge.components.Hidden) model.getChild( "STATO_FUTURO" );
            if (! STATO_FUTURO.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End RICHIESTA_INOLTRA Record: method validate

//RICHIESTA_INOLTRA Record Tail @6-FCB6E20C
    }
//End RICHIESTA_INOLTRA Record Tail

//AmvRichiestaInoltra Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvRichiestaInoltra Page: method validate

//AmvRichiestaInoltraAction Tail @1-FCB6E20C
}
//End AmvRichiestaInoltraAction Tail
