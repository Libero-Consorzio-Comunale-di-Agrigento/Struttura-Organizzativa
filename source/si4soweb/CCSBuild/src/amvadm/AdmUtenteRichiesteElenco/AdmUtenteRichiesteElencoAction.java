//AdmUtenteRichiesteElencoAction imports @1-36BA3949
package amvadm.AdmUtenteRichiesteElenco;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmUtenteRichiesteElencoAction imports

//AdmUtenteRichiesteElencoAction class @1-A4A723D0
public class AdmUtenteRichiesteElencoAction extends Action {

//End AdmUtenteRichiesteElencoAction class

//AdmUtenteRichiesteElencoAction: method perform @1-7804D091
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AdmUtenteRichiesteElencoModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AdmUtenteRichiesteElencoModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AdmUtenteRichiesteElencoAction: method perform

//AdmUtenteRichiesteElencoAction: call children actions @1-4445C869
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
        if ( page.getChild( "AmvServiziElenco_i" ).isVisible() ) {
            page.getRequest().setAttribute("AmvServiziElenco_iParent",page);
            common.AmvServiziElenco_i.AmvServiziElenco_iAction AmvServiziElenco_i = new common.AmvServiziElenco_i.AmvServiziElenco_iAction();
            result = result != null ? result : AmvServiziElenco_i.perform( req, resp,  context );
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
//End AdmUtenteRichiesteElencoAction: call children actions

//AdmUtenteRichiesteElenco Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AdmUtenteRichiesteElenco Page: method validate

//AdmUtenteRichiesteElencoAction Tail @1-FCB6E20C
}
//End AdmUtenteRichiesteElencoAction Tail


