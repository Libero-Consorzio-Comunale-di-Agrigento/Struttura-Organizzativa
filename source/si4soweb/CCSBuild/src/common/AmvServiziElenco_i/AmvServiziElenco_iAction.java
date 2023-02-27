



//AmvServiziElenco_iAction imports @1-52D319A1
package common.AmvServiziElenco_i;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvServiziElenco_iAction imports

//AmvServiziElenco_iAction class @1-B16F4BBA
public class AmvServiziElenco_iAction extends Action {

//End AmvServiziElenco_iAction class

//AmvServiziElenco_iAction: method perform @1-BF3AE6F2
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvServiziElenco_iModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvServiziElenco_iModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvServiziElenco_iAction: method perform

//AmvServiziElenco_iAction: call children actions @1-B981481F
        if ( page.getChild( "AmvServiziRichiestiElenco_i" ).isVisible() ) {
            page.getRequest().setAttribute("AmvServiziRichiestiElenco_iParent",page);
            common.AmvServiziRichiestiElenco_i.AmvServiziRichiestiElenco_iAction AmvServiziRichiestiElenco_i = new common.AmvServiziRichiestiElenco_i.AmvServiziRichiestiElenco_iAction();
            result = result != null ? result : AmvServiziRichiestiElenco_i.perform( req, resp,  context );
            page.setCookies();
        }
        if ( page.getChild( "AmvServiziAbilitatiElenco_i" ).isVisible() ) {
            page.getRequest().setAttribute("AmvServiziAbilitatiElenco_iParent",page);
            common.AmvServiziAbilitatiElenco_i.AmvServiziAbilitatiElenco_iAction AmvServiziAbilitatiElenco_i = new common.AmvServiziAbilitatiElenco_i.AmvServiziAbilitatiElenco_iAction();
            result = result != null ? result : AmvServiziAbilitatiElenco_i.perform( req, resp,  context );
            page.setCookies();
        }
        if ( page.getChild( "AmvServiziDisponibiliElenco_i" ).isVisible() ) {
            page.getRequest().setAttribute("AmvServiziDisponibiliElenco_iParent",page);
            common.AmvServiziDisponibiliElenco_i.AmvServiziDisponibiliElenco_iAction AmvServiziDisponibiliElenco_i = new common.AmvServiziDisponibiliElenco_i.AmvServiziDisponibiliElenco_iAction();
            result = result != null ? result : AmvServiziDisponibiliElenco_i.perform( req, resp,  context );
            page.setCookies();
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvServiziElenco_iAction: call children actions

//AmvServiziElenco_i Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvServiziElenco_i Page: method validate

//AmvServiziElenco_iAction Tail @1-FCB6E20C
}
//End AmvServiziElenco_iAction Tail


