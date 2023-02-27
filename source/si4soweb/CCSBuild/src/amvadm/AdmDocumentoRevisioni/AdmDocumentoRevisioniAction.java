//AdmDocumentoRevisioniAction imports @1-3209443F
package amvadm.AdmDocumentoRevisioni;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmDocumentoRevisioniAction imports

//AdmDocumentoRevisioniAction class @1-355E70FF
public class AdmDocumentoRevisioniAction extends Action {

//End AdmDocumentoRevisioniAction class

//AdmDocumentoRevisioniAction: method perform @1-BDF6BC50
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AdmDocumentoRevisioniModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AdmDocumentoRevisioniModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AdmDocumentoRevisioniAction: method perform

//AdmDocumentoRevisioniAction: call children actions @1-70F9A0F8
        if (result == null) {
            AD4_DOCUMENTO_SELClass AD4_DOCUMENTO_SEL = new AD4_DOCUMENTO_SELClass();
            AD4_DOCUMENTO_SEL.perform(page.getGrid("AD4_DOCUMENTO_SEL"));
        }
        if (result == null) {
            ELENCO_REVISIONIClass ELENCO_REVISIONI = new ELENCO_REVISIONIClass();
            ELENCO_REVISIONI.perform(page.getGrid("ELENCO_REVISIONI"));
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AdmDocumentoRevisioniAction: call children actions

//AD4_DOCUMENTO_SEL Grid @10-A9DC431F
    final class AD4_DOCUMENTO_SELClass {
        com.codecharge.components.Grid model;
        Event e;
//End AD4_DOCUMENTO_SEL Grid

//AD4_DOCUMENTO_SEL Grid: method perform @10-B48879D3
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
//End AD4_DOCUMENTO_SEL Grid: method perform

//AD4_DOCUMENTO_SEL Grid: method read: head @10-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End AD4_DOCUMENTO_SEL Grid: method read: head

//AD4_DOCUMENTO_SEL Grid: method read: init @10-C698F536
            if ( ! model.allowRead ) return true;
            AD4_DOCUMENTO_SELDataObject ds = new AD4_DOCUMENTO_SELDataObject(page);
            ds.setComponent( model );
//End AD4_DOCUMENTO_SEL Grid: method read: init

//AD4_DOCUMENTO_SEL Grid: set where parameters @10-77BCD3B7
            try {
                ds.setUrlREV( page.getHttpGetParams().getParameter("REV"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'REV'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'REV'" );
                return false;
            }
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            try {
                ds.setUrlID( page.getHttpGetParams().getParameter("ID"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID'" );
                return false;
            }
//End AD4_DOCUMENTO_SEL Grid: set where parameters

//AD4_DOCUMENTO_SEL Grid: set grid properties @10-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End AD4_DOCUMENTO_SEL Grid: set grid properties

//AD4_DOCUMENTO_SEL Grid: retrieve data @10-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End AD4_DOCUMENTO_SEL Grid: retrieve data

//AD4_DOCUMENTO_SEL Grid: check errors @10-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End AD4_DOCUMENTO_SEL Grid: check errors

//AD4_DOCUMENTO_SEL Grid: method read: tail @10-F575E732
            return ( ! isErrors );
        }
//End AD4_DOCUMENTO_SEL Grid: method read: tail

//AD4_DOCUMENTO_SEL Grid: method bind @10-73E2A6EC
        public void bind(com.codecharge.components.Component model, AD4_DOCUMENTO_SELRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            AD4_DOCUMENTO_SELRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("NOME_DOCUMENTO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("NOME_DOCUMENTO").clone();
                    c.setValue(row.getNOME_DOCUMENTO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("NUOVA_REV");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("NUOVA_REV").clone();
                    c.setValue(row.getNUOVA_REV());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End AD4_DOCUMENTO_SEL Grid: method bind

//AD4_DOCUMENTO_SEL Directory: getRowFieldByName @10-3F6A1170
        public Object getRowFieldByName( String name, AD4_DOCUMENTO_SELRow row ) {
            Object value = null;
            if ( "NOME_DOCUMENTO".equals(name) ) {
                value = row.getNOME_DOCUMENTO();
            } else if ( "NUOVA_REV".equals(name) ) {
                value = row.getNUOVA_REV();
            }
            return value;
        }
//End AD4_DOCUMENTO_SEL Directory: getRowFieldByName

//AD4_DOCUMENTO_SEL Grid: method validate @10-104025BA
        boolean validate() {
            return true;
        }
//End AD4_DOCUMENTO_SEL Grid: method validate

//AD4_DOCUMENTO_SEL Grid Tail @10-FCB6E20C
    }
//End AD4_DOCUMENTO_SEL Grid Tail

//ELENCO_REVISIONI Grid @2-557C4B77
    final class ELENCO_REVISIONIClass {
        com.codecharge.components.Grid model;
        Event e;
//End ELENCO_REVISIONI Grid

//ELENCO_REVISIONI Grid: method perform @2-B48879D3
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
//End ELENCO_REVISIONI Grid: method perform

//ELENCO_REVISIONI Grid: method read: head @2-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End ELENCO_REVISIONI Grid: method read: head

//ELENCO_REVISIONI Grid: method read: init @2-B91F2D24
            if ( ! model.allowRead ) return true;
            ELENCO_REVISIONIDataObject ds = new ELENCO_REVISIONIDataObject(page);
            ds.setComponent( model );
//End ELENCO_REVISIONI Grid: method read: init

//ELENCO_REVISIONI Grid: set where parameters @2-7C571D16
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            try {
                ds.setUrlID( page.getHttpGetParams().getParameter("ID"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID'" );
                return false;
            }
//End ELENCO_REVISIONI Grid: set where parameters

//ELENCO_REVISIONI Grid: set grid properties @2-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End ELENCO_REVISIONI Grid: set grid properties

//ELENCO_REVISIONI Grid: retrieve data @2-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End ELENCO_REVISIONI Grid: retrieve data

//ELENCO_REVISIONI Grid: check errors @2-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End ELENCO_REVISIONI Grid: check errors

//ELENCO_REVISIONI Grid: method read: tail @2-F575E732
            return ( ! isErrors );
        }
//End ELENCO_REVISIONI Grid: method read: tail

//ELENCO_REVISIONI Grid: method bind @2-82C1234B
        public void bind(com.codecharge.components.Component model, ELENCO_REVISIONIRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            ELENCO_REVISIONIRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("REVISIONE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("REVISIONE").clone();
                    c.setValue(row.getREVISIONE());
                    hashRow.put( c.getName(), c );
                }
                ((com.codecharge.components.Link) c).setHrefSourceValue( getRowFieldByName(((com.codecharge.components.Link) c).getHrefSource(), row ));
                ((com.codecharge.components.Link) c).getParameter("ID").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("ID").getSourceName(), row ));
                ((com.codecharge.components.Link) c).getParameter("REV").setValue( getRowFieldByName(((com.codecharge.components.Link) c).getParameter("REV").getSourceName(), row ));

                c = (com.codecharge.components.Control) hashRow.get("STATO_DOCUMENTO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("STATO_DOCUMENTO").clone();
                    c.setValue(row.getSTATO_DOCUMENTO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("TITOLO_DOC");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("TITOLO_DOC").clone();
                    c.setValue(row.getTITOLO_DOC());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("MODIFICA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("MODIFICA").clone();
                    c.setValue(row.getMODIFICA());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End ELENCO_REVISIONI Grid: method bind

//ELENCO_REVISIONI Directory: getRowFieldByName @2-BCD05052
        public Object getRowFieldByName( String name, ELENCO_REVISIONIRow row ) {
            Object value = null;
            if ( "REVISIONE".equals(name) ) {
                value = row.getREVISIONE();
            } else if ( "STATO_DOCUMENTO".equals(name) ) {
                value = row.getSTATO_DOCUMENTO();
            } else if ( "TITOLO_DOC".equals(name) ) {
                value = row.getTITOLO_DOC();
            } else if ( "MODIFICA".equals(name) ) {
                value = row.getMODIFICA();
            } else if ( "ID".equals(name) ) {
                value = row.getID();
            } else if ( "ID_DOCUMENTO".equals(name) ) {
                value = row.getID_DOCUMENTO();
            } else if ( "REV".equals(name) ) {
                value = row.getREV();
            } else if ( "HREF_SRC".equals(name) ) {
                value = row.getHREF_SRC();
            } else if ( "MOD_HREF".equals(name) ) {
                value = row.getMOD_HREF();
            }
            return value;
        }
//End ELENCO_REVISIONI Directory: getRowFieldByName

//ELENCO_REVISIONI Grid: method validate @2-104025BA
        boolean validate() {
            return true;
        }
//End ELENCO_REVISIONI Grid: method validate

//ELENCO_REVISIONI Grid Tail @2-FCB6E20C
    }
//End ELENCO_REVISIONI Grid Tail

//AdmDocumentoRevisioni Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AdmDocumentoRevisioni Page: method validate

//AdmDocumentoRevisioniAction Tail @1-FCB6E20C
}
//End AdmDocumentoRevisioniAction Tail
