//IncludeLinkAction imports @1-5DCA0EC0
package common.IncludeLink;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End IncludeLinkAction imports

//IncludeLinkAction class @1-C34711E0
public class IncludeLinkAction extends Action {

//End IncludeLinkAction class

//IncludeLinkAction: method perform @1-853E0FEC
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new IncludeLinkModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "IncludeLinkModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End IncludeLinkAction: method perform

//IncludeLinkAction: call children actions @1-B8A522AB
        if ( page.getChild( "AmvIncludeLink" ).isVisible() ) {
            page.getRequest().setAttribute("AmvIncludeLinkParent",page);
            common.AmvIncludeLink.AmvIncludeLinkAction AmvIncludeLink = new common.AmvIncludeLink.AmvIncludeLinkAction();
            result = result != null ? result : AmvIncludeLink.perform( req, resp,  context );
            page.setCookies();
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End IncludeLinkAction: call children actions

//IncludeLink Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End IncludeLink Page: method validate

//IncludeLinkAction Tail @1-FCB6E20C
}
//End IncludeLinkAction Tail

