//AmvMainAction imports @1-60002A49
package common.AmvMain;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvMainAction imports

//AmvMainAction class @1-0D9E252E
public class AmvMainAction extends Action {

//End AmvMainAction class

//AmvMainAction: method perform @1-459E3215
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvMainModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvMainModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvMainAction: method perform

//AmvMainAction: call children actions @1-F429F166
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
        if ( page.getChild( "AmvNavigatore" ).isVisible() ) {
            page.getRequest().setAttribute("AmvNavigatoreParent",page);
            common.AmvNavigatore.AmvNavigatoreAction AmvNavigatore = new common.AmvNavigatore.AmvNavigatoreAction();
            result = result != null ? result : AmvNavigatore.perform( req, resp,  context );
            page.setCookies();
        }
        if ( page.getChild( "AmvRegistrazioneLink" ).isVisible() ) {
            page.getRequest().setAttribute("AmvRegistrazioneLinkParent",page);
            common.AmvRegistrazioneLink.AmvRegistrazioneLinkAction AmvRegistrazioneLink = new common.AmvRegistrazioneLink.AmvRegistrazioneLinkAction();
            result = result != null ? result : AmvRegistrazioneLink.perform( req, resp,  context );
            page.setCookies();
        }
        if ( page.getChild( "MainContent" ).isVisible() ) {
            page.getRequest().setAttribute("MainContentParent",page);
            common.MainContent.MainContentAction MainContent = new common.MainContent.MainContentAction();
            result = result != null ? result : MainContent.perform( req, resp,  context );
            page.setCookies();
        }
        if ( page.getChild( "AmvCenterMenuSezioni" ).isVisible() ) {
            page.getRequest().setAttribute("AmvCenterMenuSezioniParent",page);
            common.AmvCenterMenuSezioni.AmvCenterMenuSezioniAction AmvCenterMenuSezioni = new common.AmvCenterMenuSezioni.AmvCenterMenuSezioniAction();
            result = result != null ? result : AmvCenterMenuSezioni.perform( req, resp,  context );
            page.setCookies();
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
//End AmvMainAction: call children actions

//AmvMain Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvMain Page: method validate

//AmvMainAction Tail @1-FCB6E20C
}
//End AmvMainAction Tail
