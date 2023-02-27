/******************************************************************************
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
  1   05/02/2003   AO   Gestione parametri di output della procedure
******************************************************************************/

//AmvServiziRichiestaAction imports @1-BD62E7E0
package common.AmvServiziRichiesta;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvServiziRichiestaAction imports

//AmvServiziRichiestaAction class @1-1E434D0A
public class AmvServiziRichiestaAction extends Action {

//End AmvServiziRichiestaAction class

//AmvServiziRichiestaAction: method perform @1-9147E7FB
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvServiziRichiestaModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvServiziRichiestaModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvServiziRichiestaAction: method perform

//AmvServiziRichiestaAction: call children actions @1-EF27342F
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
            AD4_UTENTEGridClass AD4_UTENTEGrid = new AD4_UTENTEGridClass();
            AD4_UTENTEGrid.perform(page.getGrid("AD4_UTENTEGrid"));
        }
        if (result == null) {
            AD4_UTENTEClass AD4_UTENTE = new AD4_UTENTEClass();
            if ( ( redirect = AD4_UTENTE.perform( page.getRecord("AD4_UTENTE")) ) != null ) result = redirect;
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
//End AmvServiziRichiestaAction: call children actions

//AD4_UTENTEGrid Grid @67-455F991D
    final class AD4_UTENTEGridClass {
        com.codecharge.components.Grid model;
        Event e;
//End AD4_UTENTEGrid Grid

//AD4_UTENTEGrid Grid: method perform @67-B48879D3
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
//End AD4_UTENTEGrid Grid: method perform

//AD4_UTENTEGrid Grid: method read: head @67-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End AD4_UTENTEGrid Grid: method read: head

//AD4_UTENTEGrid Grid: method read: init @67-1FDBBADE
            if ( ! model.allowRead ) return true;
            AD4_UTENTEGridDataObject ds = new AD4_UTENTEGridDataObject(page);
            ds.setComponent( model );
//End AD4_UTENTEGrid Grid: method read: init

//AD4_UTENTEGrid Grid: set where parameters @67-8DDC3665
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setSesMVUTE( SessionStorage.getInstance(req).getAttribute("MVUTE") );
            ds.setSesModulo( SessionStorage.getInstance(req).getAttribute("Modulo") );
            ds.setUrlMODULO( page.getHttpGetParams().getParameter("MODULO") );
            ds.setSesIstanza( SessionStorage.getInstance(req).getAttribute("Istanza") );
            ds.setUrlISTANZA( page.getHttpGetParams().getParameter("ISTANZA") );
            ds.setSesMVPWD( SessionStorage.getInstance(req).getAttribute("MVPWD") );
//End AD4_UTENTEGrid Grid: set where parameters

//AD4_UTENTEGrid Grid: set grid properties @67-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End AD4_UTENTEGrid Grid: set grid properties

//AD4_UTENTEGrid Grid: retrieve data @67-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End AD4_UTENTEGrid Grid: retrieve data

//AD4_UTENTEGrid Grid: check errors @67-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End AD4_UTENTEGrid Grid: check errors

//AD4_UTENTEGrid Grid: method read: tail @67-F575E732
            return ( ! isErrors );
        }
//End AD4_UTENTEGrid Grid: method read: tail

//AD4_UTENTEGrid Grid: method bind @67-AB3FAA57
        public void bind(com.codecharge.components.Component model, AD4_UTENTEGridRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            AD4_UTENTEGridRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("PASSWORD");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("PASSWORD").clone();
                    c.setValue(row.getPASSWORD());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("NOTIFICA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("NOTIFICA").clone();
                    c.setValue(row.getNOTIFICA());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("INDIRIZZO_COMPLETO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("INDIRIZZO_COMPLETO").clone();
                    c.setValue(row.getINDIRIZZO_COMPLETO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("INDIRIZZO_WEB");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("INDIRIZZO_WEB").clone();
                    c.setValue(row.getINDIRIZZO_WEB());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("TELEFONO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("TELEFONO").clone();
                    c.setValue(row.getTELEFONO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("FAX");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("FAX").clone();
                    c.setValue(row.getFAX());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("SERVIZIO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("SERVIZIO").clone();
                    c.setValue(row.getSERVIZIO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("MODIFICA_RESIDENZA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("MODIFICA_RESIDENZA").clone();
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("MODIFICA_RECAPITO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("MODIFICA_RECAPITO").clone();
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End AD4_UTENTEGrid Grid: method bind

//AD4_UTENTEGrid Directory: getRowFieldByName @67-699FD142
        public Object getRowFieldByName( String name, AD4_UTENTEGridRow row ) {
            Object value = null;
            if ( "NOMINATIVO".equals(name) ) {
                value = row.getNOMINATIVO();
            } else if ( "PASSWORD".equals(name) ) {
                value = row.getPASSWORD();
            } else if ( "NOTIFICA".equals(name) ) {
                value = row.getNOTIFICA();
            } else if ( "INDIRIZZO_COMPLETO".equals(name) ) {
                value = row.getINDIRIZZO_COMPLETO();
            } else if ( "MODIFICA_RESIDENZA".equals(name) ) {
                value = row.getMODIFICA_RESIDENZA();
            } else if ( "INDIRIZZO_WEB".equals(name) ) {
                value = row.getINDIRIZZO_WEB();
            } else if ( "MODIFICA_RECAPITO".equals(name) ) {
                value = row.getMODIFICA_RECAPITO();
            } else if ( "TELEFONO".equals(name) ) {
                value = row.getTELEFONO();
            } else if ( "FAX".equals(name) ) {
                value = row.getFAX();
            } else if ( "SERVIZIO".equals(name) ) {
                value = row.getSERVIZIO();
            }
            return value;
        }
//End AD4_UTENTEGrid Directory: getRowFieldByName

//AD4_UTENTEGrid Grid: method validate @67-104025BA
        boolean validate() {
            return true;
        }
//End AD4_UTENTEGrid Grid: method validate

//AD4_UTENTEGrid Grid Tail @67-FCB6E20C
    }
//End AD4_UTENTEGrid Grid Tail

//AD4_UTENTE Record @2-20741C0E
    final class AD4_UTENTEClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AD4_UTENTE Record

//AD4_UTENTE Record: method perform @2-DAD7B3FA
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( page.getActionPageName() + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowUpdate() ) model.getChild( "Update" ).setVisible( false );
//End AD4_UTENTE Record: method perform

//AD4_UTENTE Record: children actions @2-501C0AB1
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("AD4_UTENTE".equals(formName)) {
                setProperties(model, Action.POST);
                    if (validate()) {
                        Update25Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
            }
            setProperties(model, Action.GET, true );
            read();
//End AD4_UTENTE Record: children actions

//AD4_UTENTE Record: method perform tail @2-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AD4_UTENTE Record: method perform tail

//Update Button @25-37E8135D
        void Update25Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Update");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AmvRedirect" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Update Button

void read() { //AD4_UTENTE Record: method read @2-7F8AAE5A

//AD4_UTENTE Record: method read head @2-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AD4_UTENTE Record: method read head

//AD4_UTENTE Record: init DataSource @2-917F8917
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AD4_UTENTEDataObject ds = new AD4_UTENTEDataObject(page);
            ds.setComponent( model );
            ds.setSesMVPWD( SessionStorage.getInstance(req).getAttribute("MVPWD") );
            ds.setSesModulo( SessionStorage.getInstance(req).getAttribute("Modulo") );
            ds.setSesMVUTE( SessionStorage.getInstance(req).getAttribute("MVUTE") );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setUrlMODULO( page.getHttpGetParams().getParameter("MODULO") );
            ds.setUrlISTANZA( page.getHttpGetParams().getParameter("ISTANZA") );
            ds.setSesIstanza( SessionStorage.getInstance(req).getAttribute("Istanza") );
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End AD4_UTENTE Record: init DataSource

//AD4_UTENTE Record: check errors @2-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End AD4_UTENTE Record: check errors

} //AD4_UTENTE Record: method read tail @2-FCB6E20C

//AD4_UTENTE Record: bind @2-A3C36F26
            public void bind(com.codecharge.components.Component model, AD4_UTENTERow row ) {
                if ( model == null || row == null ) return;
                if ( this.valid ) {
                    model.getControl("ISTANZA").setValue(row.getISTANZA());
                    model.getControl("MODULO").setValue(row.getMODULO());
                    model.getControl("MVPAGES").setValue(row.getMVPAGES());
                }
            }
//End AD4_UTENTE Record: bind

//AD4_UTENTE Record: getRowFieldByName @2-5D827552
            public Object getRowFieldByName( String name, AD4_UTENTERow row ) {
                Object value = null;
                if ( "ISTANZA".equals(name) ) {
                    value = row.getISTANZA();
                } else if ( "MODULO".equals(name) ) {
                    value = row.getMODULO();
                } else if ( "MVPAGES".equals(name) ) {
                    value = row.getMVPAGES();
                }
                return value;
            }
//End AD4_UTENTE Record: getRowFieldByName

void InsertAction() { //AD4_UTENTE Record: method insert @2-11643485

//AD4_UTENTE Record: method insert head @2-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End AD4_UTENTE Record: method insert head

//AD4_UTENTE Record: components insert actions @2-68525650
            if (! model.hasErrors()) {
            }
//End AD4_UTENTE Record: components insert actions

} //AD4_UTENTE Record: method insert tail @2-FCB6E20C

void UpdateAction() { //AD4_UTENTE Record: method update @2-5771D0AA

//AD4_UTENTE Record: method update head @2-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End AD4_UTENTE Record: method update head

//AD4_UTENTE Record: method update body @2-ED7789D7
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            AD4_UTENTEDataObject ds = new AD4_UTENTEDataObject(page);
            ds.setComponent( model );
            AD4_UTENTERow row = new AD4_UTENTERow();
            ds.setRow(row);
            try {
                ds.setSesMVRIC( SessionStorage.getInstance(req).getAttribute("MVRIC"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVRIC'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVRIC'" );
            }
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setSesMVUTE( SessionStorage.getInstance(req).getAttribute("MVUTE") );
            ds.setPostMODULO( page.getHttpPostParams().getParameter("MODULO") );
            ds.setPostISTANZA( page.getHttpPostParams().getParameter("ISTANZA") );
//End AD4_UTENTE Record: method update body

//AD4_UTENTE Record: ds.update @2-9C35538C
//Rev.1 : gestione parametri output della procedure custom AFC 
			Collection cParam = null;		
            cParam = ds.update();	
            //ds.update();
      		isErrors = ds.hasErrors();
	  		if ( ! isErrors ) {
	  			Object params[] = cParam.toArray();
        		//ID Richiesta
				if ( params[0] != null ) {
           			SessionStorage.getInstance(req).setAttribute("MVRIC", ((Parameter)params[0]).getObjectValue());

        		}        
	  		}
//Rev.1 : fine 
            model.fireAfterUpdateEvent();
            action = true;
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End AD4_UTENTE Record: ds.update

} //AD4_UTENTE Record: method update tail @2-FCB6E20C

void DeleteAction() { //AD4_UTENTE Record: method delete @2-11FC2E1E

//AD4_UTENTE Record: method delete head @2-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End AD4_UTENTE Record: method delete head

//AD4_UTENTE Record: components delete actions @2-68525650
            if (! model.hasErrors()) {
            }
//End AD4_UTENTE Record: components delete actions

} //AD4_UTENTE Record: method delete tail @2-FCB6E20C

//AD4_UTENTE Record: method validate @2-2ED7A852
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.Hidden ISTANZA = (com.codecharge.components.Hidden) model.getChild( "ISTANZA" );
            if (! ISTANZA.validate()) { isControlError = true; }

            com.codecharge.components.Hidden MODULO = (com.codecharge.components.Hidden) model.getChild( "MODULO" );
            if (! MODULO.validate()) { isControlError = true; }

            com.codecharge.components.Hidden MVPAGES = (com.codecharge.components.Hidden) model.getChild( "MVPAGES" );
            if (! MVPAGES.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AD4_UTENTE Record: method validate

//AD4_UTENTE Record Tail @2-FCB6E20C
    }
//End AD4_UTENTE Record Tail

//AmvServiziRichiesta Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvServiziRichiesta Page: method validate

//AmvServiziRichiestaAction Tail @1-FCB6E20C
}
//End AmvServiziRichiestaAction Tail

