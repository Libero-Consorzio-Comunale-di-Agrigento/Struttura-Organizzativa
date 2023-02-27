//LogoutAction imports @1-4C9396C8
package common.Logout;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End LogoutAction imports

//LogoutAction class @1-5F57CA2C
public class LogoutAction extends Action {

//End LogoutAction class

//LogoutAction: method perform @1-243A9C38
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new LogoutModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "LogoutModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End LogoutAction: method perform

//LogoutAction: call children actions @1-8FA02E15
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End LogoutAction: call children actions

//Logout Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End Logout Page: method validate

//LogoutAction Tail @1-FCB6E20C
}
//End LogoutAction Tail

