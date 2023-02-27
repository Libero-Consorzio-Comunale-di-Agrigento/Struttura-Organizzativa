//HelpAction imports @1-EAABC874
package common.Help;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End HelpAction imports

//HelpAction class @1-0A27897B
public class HelpAction extends Action {

//End HelpAction class

//HelpAction: method perform @1-C6F6BC3B
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new HelpModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "HelpModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End HelpAction: method perform

//HelpAction: call children actions @1-8FA02E15
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End HelpAction: call children actions

//Help Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End Help Page: method validate

//HelpAction Tail @1-FCB6E20C
}
//End HelpAction Tail

