//AdmUtenteDatiInfoAction imports @1-979CC26D
package amvadm.AdmUtenteDatiInfo;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmUtenteDatiInfoAction imports

//AdmUtenteDatiInfoAction class @1-75604D21
public class AdmUtenteDatiInfoAction extends Action {

//End AdmUtenteDatiInfoAction class

//AdmUtenteDatiInfoAction: method perform @1-2A4F3EB0
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AdmUtenteDatiInfoModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AdmUtenteDatiInfoModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AdmUtenteDatiInfoAction: method perform

//AdmUtenteDatiInfoAction: call children actions @1-E655A31B
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
            AD4_UTENTIClass AD4_UTENTI = new AD4_UTENTIClass();
            if ( ( redirect = AD4_UTENTI.perform( page.getRecord("AD4_UTENTI")) ) != null ) result = redirect;
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
//End AdmUtenteDatiInfoAction: call children actions

//AD4_UTENTI Record @59-2850471E
    final class AD4_UTENTIClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AD4_UTENTI Record

//AD4_UTENTI Record: method perform @59-65A7DEFC
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( page.getActionPageName() + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
//End AD4_UTENTI Record: method perform

//AD4_UTENTI Record: children actions @59-8EC3EBE6
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("AD4_UTENTI".equals(formName)) {
                setProperties(model, Action.POST);
                if (mode != -1) { // Update mode
                    model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                } else { // Insert mode
                    model.setMode(com.codecharge.components.Record.INSERT_MODE);
                }
            }
            setProperties(model, Action.GET, true );
            read();
//End AD4_UTENTI Record: children actions

//AD4_UTENTI Record: method perform tail @59-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AD4_UTENTI Record: method perform tail

void read() { //AD4_UTENTI Record: method read @59-7F8AAE5A

//AD4_UTENTI Record: method read head @59-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AD4_UTENTI Record: method read head

//AD4_UTENTI Record: init DataSource @59-2AB68DC8
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AD4_UTENTIDataObject ds = new AD4_UTENTIDataObject(page);
            ds.setComponent( model );
            ds.setSesMVUTE( SessionStorage.getInstance(req).getAttribute("MVUTE") );
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End AD4_UTENTI Record: init DataSource

//AD4_UTENTI Record: check errors @59-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End AD4_UTENTI Record: check errors

} //AD4_UTENTI Record: method read tail @59-FCB6E20C

//AD4_UTENTI Record: bind @59-27042F8E
            public void bind(com.codecharge.components.Component model, AD4_UTENTIRow row ) {
                if ( model == null || row == null ) return;
                model.getControl("NOME").setValue(row.getNOME());
                model.getControl("SESSO").setValue(row.getSESSO());
                model.getControl("CODICE_FISCALE").setValue(row.getCODICE_FISCALE());
                model.getControl("DATA_NASCITA").setValue(row.getDATA_NASCITA());
                model.getControl("DES_COMUNE_NAS").setValue(row.getDES_COMUNE_NAS());
                model.getControl("DES_PROVINCIA_NAS").setValue(row.getDES_PROVINCIA_NAS());
                model.getControl("INDIRIZZO_COMPLETO").setValue(row.getINDIRIZZO_COMPLETO());
                model.getControl("INDIRIZZO_WEB").setValue(row.getINDIRIZZO_WEB());
                model.getControl("TELEFONO").setValue(row.getTELEFONO());
                model.getControl("FAX").setValue(row.getFAX());
                model.getControl("DATA_PASSWORD").setValue(row.getDATA_PASSWORD());
                model.getControl("RINNOVO_PASSWORD").setValue(row.getRINNOVO_PASSWORD());
                model.getControl("ULTIMO_TENTATIVO").setValue(row.getULTIMO_TENTATIVO());
                model.getControl("STATO").setValue(row.getSTATO());
                model.getControl("DATA_INSERIMENTO").setValue(row.getDATA_INSERIMENTO());
                model.getControl("DATA_AGGIORNAMENTO").setValue(row.getDATA_AGGIORNAMENTO());
                if ( this.valid ) {
                }
            }
//End AD4_UTENTI Record: bind

//AD4_UTENTI Record: getRowFieldByName @59-FC3C4271
            public Object getRowFieldByName( String name, AD4_UTENTIRow row ) {
                Object value = null;
                if ( "NOME".equals(name) ) {
                    value = row.getNOME();
                } else if ( "SESSO".equals(name) ) {
                    value = row.getSESSO();
                } else if ( "CODICE_FISCALE".equals(name) ) {
                    value = row.getCODICE_FISCALE();
                } else if ( "DATA_NASCITA".equals(name) ) {
                    value = row.getDATA_NASCITA();
                } else if ( "DES_COMUNE_NAS".equals(name) ) {
                    value = row.getDES_COMUNE_NAS();
                } else if ( "DES_PROVINCIA_NAS".equals(name) ) {
                    value = row.getDES_PROVINCIA_NAS();
                } else if ( "INDIRIZZO_COMPLETO".equals(name) ) {
                    value = row.getINDIRIZZO_COMPLETO();
                } else if ( "INDIRIZZO_WEB".equals(name) ) {
                    value = row.getINDIRIZZO_WEB();
                } else if ( "TELEFONO".equals(name) ) {
                    value = row.getTELEFONO();
                } else if ( "FAX".equals(name) ) {
                    value = row.getFAX();
                } else if ( "DATA_PASSWORD".equals(name) ) {
                    value = row.getDATA_PASSWORD();
                } else if ( "RINNOVO_PASSWORD".equals(name) ) {
                    value = row.getRINNOVO_PASSWORD();
                } else if ( "ULTIMO_TENTATIVO".equals(name) ) {
                    value = row.getULTIMO_TENTATIVO();
                } else if ( "STATO".equals(name) ) {
                    value = row.getSTATO();
                } else if ( "DATA_INSERIMENTO".equals(name) ) {
                    value = row.getDATA_INSERIMENTO();
                } else if ( "DATA_AGGIORNAMENTO".equals(name) ) {
                    value = row.getDATA_AGGIORNAMENTO();
                }
                return value;
            }
//End AD4_UTENTI Record: getRowFieldByName

void InsertAction() { //AD4_UTENTI Record: method insert @59-11643485

//AD4_UTENTI Record: method insert head @59-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End AD4_UTENTI Record: method insert head

//AD4_UTENTI Record: components insert actions @59-68525650
            if (! model.hasErrors()) {
            }
//End AD4_UTENTI Record: components insert actions

} //AD4_UTENTI Record: method insert tail @59-FCB6E20C

void UpdateAction() { //AD4_UTENTI Record: method update @59-5771D0AA

//AD4_UTENTI Record: method update head @59-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End AD4_UTENTI Record: method update head

//AD4_UTENTI Record: components update actions @59-68525650
            if (! model.hasErrors()) {
            }
//End AD4_UTENTI Record: components update actions

} //AD4_UTENTI Record: method update tail @59-FCB6E20C

void DeleteAction() { //AD4_UTENTI Record: method delete @59-11FC2E1E

//AD4_UTENTI Record: method delete head @59-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End AD4_UTENTI Record: method delete head

//AD4_UTENTI Record: components delete actions @59-68525650
            if (! model.hasErrors()) {
            }
//End AD4_UTENTI Record: components delete actions

} //AD4_UTENTI Record: method delete tail @59-FCB6E20C

//AD4_UTENTI Record: method validate @59-A8FFD717
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AD4_UTENTI Record: method validate

//AD4_UTENTI Record Tail @59-FCB6E20C
    }
//End AD4_UTENTI Record Tail

//AdmUtenteDatiInfo Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AdmUtenteDatiInfo Page: method validate

//AdmUtenteDatiInfoAction Tail @1-FCB6E20C
}
//End AdmUtenteDatiInfoAction Tail




