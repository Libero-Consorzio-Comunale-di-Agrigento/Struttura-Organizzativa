//HeaderAction imports @1-CF77B1EE
package common.Header;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End HeaderAction imports

//HeaderAction class @1-50058ED4
public class HeaderAction extends Action {

//End HeaderAction class

//HeaderAction: method perform @1-BB98FD68
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new HeaderModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "HeaderModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End HeaderAction: method perform

//HeaderAction: call children actions @1-A4FFE879
        if ( page.getChild( "AmvHeader" ).isVisible() ) {
            page.getRequest().setAttribute("AmvHeaderParent",page);
            common.AmvHeader.AmvHeaderAction AmvHeader = new common.AmvHeader.AmvHeaderAction();
            result = result != null ? result : AmvHeader.perform( req, resp,  context );
            page.setCookies();
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End HeaderAction: call children actions

//Header Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End Header Page: method validate

//HeaderAction Tail @1-FCB6E20C
}
//End HeaderAction Tail

