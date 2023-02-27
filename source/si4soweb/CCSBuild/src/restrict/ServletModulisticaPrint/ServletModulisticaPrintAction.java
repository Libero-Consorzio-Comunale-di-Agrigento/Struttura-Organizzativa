//ServletModulisticaPrintAction imports @1-678B6591
package restrict.ServletModulisticaPrint;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End ServletModulisticaPrintAction imports

//ServletModulisticaPrintAction class @1-A3872569
public class ServletModulisticaPrintAction extends Action {

//End ServletModulisticaPrintAction class

//ServletModulisticaPrintAction: method perform @1-BEB91C63
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new ServletModulisticaPrintModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "ServletModulisticaPrintModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End ServletModulisticaPrintAction: method perform

//ServletModulisticaPrintAction: call children actions @1-8FA02E15
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End ServletModulisticaPrintAction: call children actions

//ServletModulisticaPrint Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End ServletModulisticaPrint Page: method validate

//ServletModulisticaPrintAction Tail @1-FCB6E20C
}
//End ServletModulisticaPrintAction Tail
