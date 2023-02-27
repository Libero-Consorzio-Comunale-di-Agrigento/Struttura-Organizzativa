//AmvHeaderAction imports @1-F98566B7
package common.AmvHeader;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvHeaderAction imports

//AmvHeaderAction class @1-7ABFF965
public class AmvHeaderAction extends Action {

//End AmvHeaderAction class

//AmvHeaderAction: method perform @1-8A8827D8
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvHeaderModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvHeaderModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvHeaderAction: method perform

//AmvHeaderAction: call children actions @1-EB6F4C3D
        if ( page.getChild( "AmvControl" ).isVisible() ) {
            page.getRequest().setAttribute("AmvControlParent",page);
            common.AmvControl.AmvControlAction AmvControl = new common.AmvControl.AmvControlAction();
            result = result != null ? result : AmvControl.perform( req, resp,  context );
            page.setCookies();
        }
        if ( page.getChild( "AmvAccessControl" ).isVisible() ) {
            page.getRequest().setAttribute("AmvAccessControlParent",page);
            common.AmvAccessControl.AmvAccessControlAction AmvAccessControl = new common.AmvAccessControl.AmvAccessControlAction();
            result = result != null ? result : AmvAccessControl.perform( req, resp,  context );
            page.setCookies();
        }
        if (result == null) {
            LOGOClass LOGO = new LOGOClass();
            LOGO.perform(page.getGrid("LOGO"));
        }
        if (result == null) {
            welcomeClass welcome = new welcomeClass();
            welcome.perform(page.getGrid("welcome"));
        }
        if (result == null) {
            LOGO_PORTALEClass LOGO_PORTALE = new LOGO_PORTALEClass();
            LOGO_PORTALE.perform(page.getGrid("LOGO_PORTALE"));
        }
        if (result == null) {
            AD4_MODULIClass AD4_MODULI = new AD4_MODULIClass();
            AD4_MODULI.perform(page.getGrid("AD4_MODULI"));
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvHeaderAction: call children actions

//LOGO Grid @41-02092B4B
    final class LOGOClass {
        com.codecharge.components.Grid model;
        Event e;
//End LOGO Grid

//LOGO Grid: method perform @41-B48879D3
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
//End LOGO Grid: method perform

//LOGO Grid: method read: head @41-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End LOGO Grid: method read: head

//LOGO Grid: method read: init @41-5439B39E
            if ( ! model.allowRead ) return true;
            LOGODataObject ds = new LOGODataObject(page);
            ds.setComponent( model );
//End LOGO Grid: method read: init

//LOGO Grid: set where parameters @41-4F4AF1D7
            ds.setSesModulo( SessionStorage.getInstance(req).getAttribute("Modulo") );
            try {
                ds.setUrlMVSZ( page.getHttpGetParams().getParameter("MVSZ"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVSZ'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVSZ'" );
                return false;
            }
//End LOGO Grid: set where parameters

//LOGO Grid: set grid properties @41-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End LOGO Grid: set grid properties

//LOGO Grid: retrieve data @41-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End LOGO Grid: retrieve data

//LOGO Grid: check errors @41-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End LOGO Grid: check errors

//LOGO Grid: method read: tail @41-F575E732
            return ( ! isErrors );
        }
//End LOGO Grid: method read: tail

//LOGO Grid: method bind @41-D1FC13C7
        public void bind(com.codecharge.components.Component model, LOGORow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            LOGORow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("LOGO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("LOGO").clone();
                    c.setValue(row.getLOGO());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End LOGO Grid: method bind

//LOGO Directory: getRowFieldByName @41-E247BF15
        public Object getRowFieldByName( String name, LOGORow row ) {
            Object value = null;
            if ( "LOGO".equals(name) ) {
                value = row.getLOGO();
            } else if ( "LOGO_HREF".equals(name) ) {
                value = row.getLOGO_HREF();
            }
            return value;
        }
//End LOGO Directory: getRowFieldByName

//LOGO Grid: method validate @41-104025BA
        boolean validate() {
            return true;
        }
//End LOGO Grid: method validate

//LOGO Grid Tail @41-FCB6E20C
    }
//End LOGO Grid Tail

//welcome Grid @19-05E76F7C
    final class welcomeClass {
        com.codecharge.components.Grid model;
        Event e;
//End welcome Grid

//welcome Grid: method perform @19-B48879D3
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
//End welcome Grid: method perform

//welcome Grid: method read: head @19-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End welcome Grid: method read: head

//welcome Grid: method read: init @19-9EDCBE49
            if ( ! model.allowRead ) return true;
            welcomeDataObject ds = new welcomeDataObject(page);
            ds.setComponent( model );
//End welcome Grid: method read: init

//welcome Grid: set where parameters @19-DEFC5B7A
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setSesNote( SessionStorage.getInstance(req).getAttribute("Note") );
            ds.setSesUserLogin( SessionStorage.getInstance(req).getAttribute("UserLogin") );
            ds.setSesModulo( SessionStorage.getInstance(req).getAttribute("Modulo") );
            try {
                ds.setUrlMVSZ( page.getHttpGetParams().getParameter("MVSZ"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVSZ'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVSZ'" );
                return false;
            }
//End welcome Grid: set where parameters

//welcome Grid: set grid properties @19-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End welcome Grid: set grid properties

//welcome Grid: retrieve data @19-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End welcome Grid: retrieve data

//welcome Grid: check errors @19-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End welcome Grid: check errors

//welcome Grid: method read: tail @19-F575E732
            return ( ! isErrors );
        }
//End welcome Grid: method read: tail

//welcome Grid: method bind @19-DF119C7F
        public void bind(com.codecharge.components.Component model, welcomeRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            welcomeRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("INTESTAZIONE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("INTESTAZIONE").clone();
                    c.setValue(row.getINTESTAZIONE());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("MESSAGGIO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("MESSAGGIO").clone();
                    c.setValue(row.getMESSAGGIO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("OGGI");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("OGGI").clone();
                    c.setValue(row.getOGGI());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("NOTE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("NOTE").clone();
                    c.setValue(row.getNOTE());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("NEW_MSG");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("NEW_MSG").clone();
                    c.setValue(row.getNEW_MSG());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End welcome Grid: method bind

//welcome Directory: getRowFieldByName @19-9780AAE0
        public Object getRowFieldByName( String name, welcomeRow row ) {
            Object value = null;
            if ( "INTESTAZIONE".equals(name) ) {
                value = row.getINTESTAZIONE();
            } else if ( "MESSAGGIO".equals(name) ) {
                value = row.getMESSAGGIO();
            } else if ( "OGGI".equals(name) ) {
                value = row.getOGGI();
            } else if ( "NOTE".equals(name) ) {
                value = row.getNOTE();
            } else if ( "NEW_MSG".equals(name) ) {
                value = row.getNEW_MSG();
            }
            return value;
        }
//End welcome Directory: getRowFieldByName

//welcome Grid: method validate @19-104025BA
        boolean validate() {
            return true;
        }
//End welcome Grid: method validate

//welcome Grid Tail @19-FCB6E20C
    }
//End welcome Grid Tail

//LOGO_PORTALE Grid @43-9FB38016
    final class LOGO_PORTALEClass {
        com.codecharge.components.Grid model;
        Event e;
//End LOGO_PORTALE Grid

//LOGO_PORTALE Grid: method perform @43-B48879D3
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
//End LOGO_PORTALE Grid: method perform

//LOGO_PORTALE Grid: method read: head @43-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End LOGO_PORTALE Grid: method read: head

//LOGO_PORTALE Grid: method read: init @43-89AA7C33
            if ( ! model.allowRead ) return true;
            LOGO_PORTALEDataObject ds = new LOGO_PORTALEDataObject(page);
            ds.setComponent( model );
//End LOGO_PORTALE Grid: method read: init

//LOGO_PORTALE Grid: set where parameters @43-4F4AF1D7
            ds.setSesModulo( SessionStorage.getInstance(req).getAttribute("Modulo") );
            try {
                ds.setUrlMVSZ( page.getHttpGetParams().getParameter("MVSZ"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVSZ'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVSZ'" );
                return false;
            }
//End LOGO_PORTALE Grid: set where parameters

//LOGO_PORTALE Grid: set grid properties @43-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End LOGO_PORTALE Grid: set grid properties

//LOGO_PORTALE Grid: retrieve data @43-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End LOGO_PORTALE Grid: retrieve data

//LOGO_PORTALE Grid: check errors @43-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End LOGO_PORTALE Grid: check errors

//LOGO_PORTALE Grid: method read: tail @43-F575E732
            return ( ! isErrors );
        }
//End LOGO_PORTALE Grid: method read: tail

//LOGO_PORTALE Grid: method bind @43-966DC35C
        public void bind(com.codecharge.components.Component model, LOGO_PORTALERow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            LOGO_PORTALERow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("LOGO_PORTALE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("LOGO_PORTALE").clone();
                    c.setValue(row.getLOGO_PORTALE());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End LOGO_PORTALE Grid: method bind

//LOGO_PORTALE Directory: getRowFieldByName @43-55F9BB48
        public Object getRowFieldByName( String name, LOGO_PORTALERow row ) {
            Object value = null;
            if ( "LOGO_PORTALE".equals(name) ) {
                value = row.getLOGO_PORTALE();
            } else if ( "LOGO_PORTALE_HREF".equals(name) ) {
                value = row.getLOGO_PORTALE_HREF();
            }
            return value;
        }
//End LOGO_PORTALE Directory: getRowFieldByName

//LOGO_PORTALE Grid: method validate @43-104025BA
        boolean validate() {
            return true;
        }
//End LOGO_PORTALE Grid: method validate

//LOGO_PORTALE Grid Tail @43-FCB6E20C
    }
//End LOGO_PORTALE Grid Tail

//AD4_MODULI Grid @28-77C54FE6
    final class AD4_MODULIClass {
        com.codecharge.components.Grid model;
        Event e;
//End AD4_MODULI Grid

//AD4_MODULI Grid: method perform @28-B48879D3
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
//End AD4_MODULI Grid: method perform

//AD4_MODULI Grid: method read: head @28-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End AD4_MODULI Grid: method read: head

//AD4_MODULI Grid: method read: init @28-A2DACE28
            if ( ! model.allowRead ) return true;
            AD4_MODULIDataObject ds = new AD4_MODULIDataObject(page);
            ds.setComponent( model );
//End AD4_MODULI Grid: method read: init

//AD4_MODULI Grid: set where parameters @28-673CB582
            ds.setSesMVVC( SessionStorage.getInstance(req).getAttribute("MVVC") );
            ds.setSesMVPD( SessionStorage.getInstance(req).getAttribute("MVPD") );
            ds.setSesModulo( SessionStorage.getInstance(req).getAttribute("Modulo") );
            ds.setUrlMVTD( page.getHttpGetParams().getParameter("MVTD") );
            ds.setUrlMVNP( page.getHttpGetParams().getParameter("MVNP") );
            ds.setSesMVRP( SessionStorage.getInstance(req).getAttribute("MVRP") );
            ds.setSesMVCONTEXT( SessionStorage.getInstance(req).getAttribute("MVCONTEXT") );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setSesRuolo( SessionStorage.getInstance(req).getAttribute("Ruolo") );
            ds.setSesMVL1( SessionStorage.getInstance(req).getAttribute("MVL1") );
            ds.setSesMVL2( SessionStorage.getInstance(req).getAttribute("MVL2") );
            ds.setSesMVL3( SessionStorage.getInstance(req).getAttribute("MVL3") );
            ds.setSesIstanza( SessionStorage.getInstance(req).getAttribute("Istanza") );
            try {
                ds.setUrlMVSZ( page.getHttpGetParams().getParameter("MVSZ"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVSZ'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVSZ'" );
                return false;
            }
            ds.setSesMVPC( SessionStorage.getInstance(req).getAttribute("MVPC") );
//End AD4_MODULI Grid: set where parameters

//AD4_MODULI Grid: set grid properties @28-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End AD4_MODULI Grid: set grid properties

//AD4_MODULI Grid: retrieve data @28-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End AD4_MODULI Grid: retrieve data

//AD4_MODULI Grid: check errors @28-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End AD4_MODULI Grid: check errors

//AD4_MODULI Grid: method read: tail @28-F575E732
            return ( ! isErrors );
        }
//End AD4_MODULI Grid: method read: tail

//AD4_MODULI Grid: method bind @28-FC536E0B
        public void bind(com.codecharge.components.Component model, AD4_MODULIRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            AD4_MODULIRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("RETURN_PAGE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("RETURN_PAGE").clone();
                    c.setValue(row.getRETURN_PAGE());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("NAVIGATORE");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("NAVIGATORE").clone();
                    c.setValue(row.getNAVIGATORE());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("MENUBAR");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("MENUBAR").clone();
                    c.setValue(row.getMENUBAR());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("SECTIONBAR");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("SECTIONBAR").clone();
                    c.setValue(row.getSECTIONBAR());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("HELP");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("HELP").clone();
                    c.setValue(row.getHELP());
                    hashRow.put( c.getName(), c );
                }

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End AD4_MODULI Grid: method bind

//AD4_MODULI Directory: getRowFieldByName @28-AC0D0C43
        public Object getRowFieldByName( String name, AD4_MODULIRow row ) {
            Object value = null;
            if ( "RETURN_PAGE".equals(name) ) {
                value = row.getRETURN_PAGE();
            } else if ( "NAVIGATORE".equals(name) ) {
                value = row.getNAVIGATORE();
            } else if ( "MENUBAR".equals(name) ) {
                value = row.getMENUBAR();
            } else if ( "SECTIONBAR".equals(name) ) {
                value = row.getSECTIONBAR();
            } else if ( "HELP".equals(name) ) {
                value = row.getHELP();
            }
            return value;
        }
//End AD4_MODULI Directory: getRowFieldByName

//AD4_MODULI Grid: method validate @28-104025BA
        boolean validate() {
            return true;
        }
//End AD4_MODULI Grid: method validate

//AD4_MODULI Grid Tail @28-FCB6E20C
    }
//End AD4_MODULI Grid Tail

//AmvHeader Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvHeader Page: method validate

//AmvHeaderAction Tail @1-FCB6E20C
}
//End AmvHeaderAction Tail

