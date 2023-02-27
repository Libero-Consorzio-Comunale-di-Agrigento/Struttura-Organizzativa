//AmvSezioneAction imports @1-62E714B6
package common.AmvSezione;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvSezioneAction imports

//AmvSezioneAction class @1-F1B791C8
public class AmvSezioneAction extends Action {

//End AmvSezioneAction class

//AmvSezioneAction: method perform @1-EA8F026C
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvSezioneModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvSezioneModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvSezioneAction: method perform

//AmvSezioneAction: call children actions @1-A0D2CB13
        if ( page.getChild( "Header" ).isVisible() ) {
            page.getRequest().setAttribute("HeaderParent",page);
            common.Header.HeaderAction Header = new common.Header.HeaderAction();
            result = result != null ? result : Header.perform( req, resp,  context );
            page.setCookies();
        }
        if ( page.getChild( "LeftSezione" ).isVisible() ) {
            page.getRequest().setAttribute("LeftSezioneParent",page);
            common.LeftSezione.LeftSezioneAction LeftSezione = new common.LeftSezione.LeftSezioneAction();
            result = result != null ? result : LeftSezione.perform( req, resp,  context );
            page.setCookies();
        }
        if ( page.getChild( "AmvNavigatore" ).isVisible() ) {
            page.getRequest().setAttribute("AmvNavigatoreParent",page);
            common.AmvNavigatore.AmvNavigatoreAction AmvNavigatore = new common.AmvNavigatore.AmvNavigatoreAction();
            result = result != null ? result : AmvNavigatore.perform( req, resp,  context );
            page.setCookies();
        }
        if ( page.getChild( "AmvCenterMenuSezioni" ).isVisible() ) {
            page.getRequest().setAttribute("AmvCenterMenuSezioniParent",page);
            common.AmvCenterMenuSezioni.AmvCenterMenuSezioniAction AmvCenterMenuSezioni = new common.AmvCenterMenuSezioni.AmvCenterMenuSezioniAction();
            result = result != null ? result : AmvCenterMenuSezioni.perform( req, resp,  context );
            page.setCookies();
        }
        if ( page.getChild( "RightSezione" ).isVisible() ) {
            page.getRequest().setAttribute("RightSezioneParent",page);
            common.RightSezione.RightSezioneAction RightSezione = new common.RightSezione.RightSezioneAction();
            result = result != null ? result : RightSezione.perform( req, resp,  context );
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
//End AmvSezioneAction: call children actions

//AmvSezione Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvSezione Page: method validate

//AmvSezioneAction Tail @1-FCB6E20C
}
//End AmvSezioneAction Tail
