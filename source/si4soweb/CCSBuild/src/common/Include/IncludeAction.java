//IncludeAction imports @1-BBD80ED9
package common.Include;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End IncludeAction imports

//IncludeAction class @1-E9910510
public class IncludeAction extends Action {

//End IncludeAction class

//IncludeAction: method perform @1-3EC6CBFA
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new IncludeModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "IncludeModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End IncludeAction: method perform

//IncludeAction: call children actions @1-A6882EC6
        if ( page.getChild( "AmvInclude" ).isVisible() ) {
            page.getRequest().setAttribute("AmvIncludeParent",page);
            common.AmvInclude.AmvIncludeAction AmvInclude = new common.AmvInclude.AmvIncludeAction();
            result = result != null ? result : AmvInclude.perform( req, resp,  context );
            page.setCookies();
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End IncludeAction: call children actions

//Include Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End Include Page: method validate

//IncludeAction Tail @1-FCB6E20C
}
//End IncludeAction Tail

