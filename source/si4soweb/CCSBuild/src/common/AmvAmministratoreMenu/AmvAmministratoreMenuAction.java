









//AmvAmministratoreMenuAction imports @1-F31A00F6
package common.AmvAmministratoreMenu;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvAmministratoreMenuAction imports

//AmvAmministratoreMenuAction class @1-A5FEE9DE
public class AmvAmministratoreMenuAction extends Action {

//End AmvAmministratoreMenuAction class

//AmvAmministratoreMenuAction: method perform @1-207E15D1
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvAmministratoreMenuModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvAmministratoreMenuModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvAmministratoreMenuAction: method perform

//AmvAmministratoreMenuAction: call children actions @1-8FA02E15
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvAmministratoreMenuAction: call children actions

//AmvAmministratoreMenu Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvAmministratoreMenu Page: method validate

//AmvAmministratoreMenuAction Tail @1-FCB6E20C
}
//End AmvAmministratoreMenuAction Tail


