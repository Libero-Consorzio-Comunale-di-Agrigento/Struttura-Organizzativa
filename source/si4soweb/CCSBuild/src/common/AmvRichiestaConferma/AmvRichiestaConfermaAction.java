//AmvRichiestaConfermaAction imports @1-26989C11
package common.AmvRichiestaConferma;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvRichiestaConfermaAction imports

//AmvRichiestaConfermaAction class @1-483655D3
public class AmvRichiestaConfermaAction extends Action {

//End AmvRichiestaConfermaAction class

//AmvRichiestaConfermaAction: method perform @1-C36D94D9
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvRichiestaConfermaModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvRichiestaConfermaModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvRichiestaConfermaAction: method perform

//AmvRichiestaConfermaAction: call children actions @1-BD3B1798
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
        if (result == null) {
            RICHIESTA_GRIDClass RICHIESTA_GRID = new RICHIESTA_GRIDClass();
            RICHIESTA_GRID.perform(page.getGrid("RICHIESTA_GRID"));
        }
        if ( page.getChild( "Right" ).isVisible() ) {
            page.getRequest().setAttribute("RightParent",page);
            common.Right.RightAction Right = new common.Right.RightAction();
            result = result != null ? result : Right.perform( req, resp,  context );
            page.setCookies();
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
//End AmvRichiestaConfermaAction: call children actions

//RICHIESTA_GRID Grid @39-9FF7CA65
    final class RICHIESTA_GRIDClass {
        com.codecharge.components.Grid model;
        Event e;
//End RICHIESTA_GRID Grid

//RICHIESTA_GRID Grid: method perform @39-B48879D3
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
//End RICHIESTA_GRID Grid: method perform

//RICHIESTA_GRID Grid: method read: head @39-A74AB037
        boolean read() {
            boolean isErrors = false;
            if ( ! model.allowRead ) return true;
            model.fireBeforeSelectEvent();
//End RICHIESTA_GRID Grid: method read: head

//RICHIESTA_GRID Grid: method read: init @39-D39D84C1
            if ( ! model.allowRead ) return true;
            RICHIESTA_GRIDDataObject ds = new RICHIESTA_GRIDDataObject(page);
            ds.setComponent( model );
//End RICHIESTA_GRID Grid: method read: init

//RICHIESTA_GRID Grid: set where parameters @39-65749078
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            try {
                ds.setSesMVIDRIC( SessionStorage.getInstance(req).getAttribute("MVIDRIC"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVIDRIC'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVIDRIC'" );
                return false;
            }
            try {
                ds.setSesMVREVRIC( SessionStorage.getInstance(req).getAttribute("MVREVRIC"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVREVRIC'" );
                return false;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVREVRIC'" );
                return false;
            }
//End RICHIESTA_GRID Grid: set where parameters

//RICHIESTA_GRID Grid: set grid properties @39-11C2D650
            
            ds.setPageNum( (model.getPage() < 1 ? 1 : model.getPage()) );
            ds.setPageSize( model.getFetchSize() );
//End RICHIESTA_GRID Grid: set grid properties

//RICHIESTA_GRID Grid: retrieve data @39-FE4E4327
            ds.load();
            if ( ! ds.isEmpty() ) {
                bind( model, ds.getRows());
            }
            model.setAmountOfRows( ds.getAmountOfRows() );
//End RICHIESTA_GRID Grid: retrieve data

//RICHIESTA_GRID Grid: check errors @39-B2B22DDA
            isErrors = ds.hasErrors();
            if ( isErrors ) model.addErrors( ds.getErrors() );
//End RICHIESTA_GRID Grid: check errors

//RICHIESTA_GRID Grid: method read: tail @39-F575E732
            return ( ! isErrors );
        }
//End RICHIESTA_GRID Grid: method read: tail

//RICHIESTA_GRID Grid: method bind @39-BFB568DF
        public void bind(com.codecharge.components.Component model, RICHIESTA_GRIDRow[] rows ) {
            if ( model == null || rows == null ) return;
            ArrayList listRows = (ArrayList) ((ArrayList) model.getChildRows()).clone();
            Iterator childRows = listRows.iterator();
            int counter = 0;
            RICHIESTA_GRIDRow row = null;
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

                c = (com.codecharge.components.Control) hashRow.get("TITOLO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("TITOLO").clone();
                    c.setValue(row.getTITOLO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("STATO_FUTURO");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("STATO_FUTURO").clone();
                    c.setValue(row.getSTATO_FUTURO());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("ID_RICHIESTA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("ID_RICHIESTA").clone();
                    c.setValue(row.getID_RICHIESTA());
                    hashRow.put( c.getName(), c );
                }

                c = (com.codecharge.components.Control) hashRow.get("ELENCO_RICHIESTE_LINK");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("ELENCO_RICHIESTE_LINK").clone();
                    c.setValue(row.getELENCO_RICHIESTE_LINK());
                    hashRow.put( c.getName(), c );
                }
                ((com.codecharge.components.Link) c).setHrefSourceValue( getRowFieldByName(((com.codecharge.components.Link) c).getHrefSource(), row ));

                c = (com.codecharge.components.Control) hashRow.get("STAMPA_RICHIESTA");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("STAMPA_RICHIESTA").clone();
                    c.setValue(row.getSTAMPA_RICHIESTA());
                    hashRow.put( c.getName(), c );
                }
                ((com.codecharge.components.Link) c).setHrefSourceValue( getRowFieldByName(((com.codecharge.components.Link) c).getHrefSource(), row ));

                c = (com.codecharge.components.Control) hashRow.get("MODIFICA_RICHIESTA_LINK");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("MODIFICA_RICHIESTA_LINK").clone();
                    c.setValue(row.getMODIFICA_RICHIESTA_LINK());
                    hashRow.put( c.getName(), c );
                }
                ((com.codecharge.components.Link) c).setHrefSourceValue( getRowFieldByName(((com.codecharge.components.Link) c).getHrefSource(), row ));

                c = (com.codecharge.components.Control) hashRow.get("CONFERMA_RICHIESTA_LINK");
                if ( c == null ) { 
                    c = (com.codecharge.components.Control) model.getControl("CONFERMA_RICHIESTA_LINK").clone();
                    c.setValue(row.getCONFERMA_RICHIESTA_LINK());
                    hashRow.put( c.getName(), c );
                }
                ((com.codecharge.components.Link) c).setHrefSourceValue( getRowFieldByName(((com.codecharge.components.Link) c).getHrefSource(), row ));

                if ( isNew ) {
                    model.addChildRow( hashRow );
                }
            } // end while
        }
//End RICHIESTA_GRID Grid: method bind

//RICHIESTA_GRID Directory: getRowFieldByName @39-0FAF083D
        public Object getRowFieldByName( String name, RICHIESTA_GRIDRow row ) {
            Object value = null;
            if ( "TITOLO".equals(name) ) {
                value = row.getTITOLO();
            } else if ( "STATO_FUTURO".equals(name) ) {
                value = row.getSTATO_FUTURO();
            } else if ( "ID_RICHIESTA".equals(name) ) {
                value = row.getID_RICHIESTA();
            } else if ( "ELENCO_RICHIESTE_LINK".equals(name) ) {
                value = row.getELENCO_RICHIESTE_LINK();
            } else if ( "STAMPA_RICHIESTA".equals(name) ) {
                value = row.getSTAMPA_RICHIESTA();
            } else if ( "MODIFICA_RICHIESTA_LINK".equals(name) ) {
                value = row.getMODIFICA_RICHIESTA_LINK();
            } else if ( "CONFERMA_RICHIESTA_LINK".equals(name) ) {
                value = row.getCONFERMA_RICHIESTA_LINK();
            } else if ( "ELENCO_RICHIESTE_HREF".equals(name) ) {
                value = row.getELENCO_RICHIESTE_HREF();
            } else if ( "STAMPA_RICHIESTA_HREF".equals(name) ) {
                value = row.getSTAMPA_RICHIESTA_HREF();
            } else if ( "MODIFICA_RICHIESTA_HREF".equals(name) ) {
                value = row.getMODIFICA_RICHIESTA_HREF();
            } else if ( "CONFERMA_RICHIESTA_HREF".equals(name) ) {
                value = row.getCONFERMA_RICHIESTA_HREF();
            }
            return value;
        }
//End RICHIESTA_GRID Directory: getRowFieldByName

//RICHIESTA_GRID Grid: method validate @39-104025BA
        boolean validate() {
            return true;
        }
//End RICHIESTA_GRID Grid: method validate

//RICHIESTA_GRID Grid Tail @39-FCB6E20C
    }
//End RICHIESTA_GRID Grid Tail

//AmvRichiestaConferma Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvRichiestaConferma Page: method validate

//AmvRichiestaConfermaAction Tail @1-FCB6E20C
}
//End AmvRichiestaConfermaAction Tail
