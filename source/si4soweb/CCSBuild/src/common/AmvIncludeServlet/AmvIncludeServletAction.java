//AmvIncludeServletAction imports @1-B1A91B7C
package common.AmvIncludeServlet;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvIncludeServletAction imports

//AmvIncludeServletAction class @1-A2537980
public class AmvIncludeServletAction extends Action {

//End AmvIncludeServletAction class

//AmvIncludeServletAction: method perform @1-BDCBD18F
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvIncludeServletModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvIncludeServletModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvIncludeServletAction: method perform

//AmvIncludeServletAction: call children actions @1-8FA02E15
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvIncludeServletAction: call children actions

//AmvIncludeServlet Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvIncludeServlet Page: method validate

//AmvIncludeServletAction Tail @1-FCB6E20C
}
//End AmvIncludeServletAction Tail

