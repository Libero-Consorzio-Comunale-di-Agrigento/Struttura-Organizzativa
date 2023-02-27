//RightAction imports @1-571E60A8
package common.Right;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End RightAction imports

//RightAction class @1-13E87948
public class RightAction extends Action {

//End RightAction class

//RightAction: method perform @1-8D6962D0
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new RightModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "RightModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End RightAction: method perform

//RightAction: call children actions @1-CB423A7E
        if ( page.getChild( "AmvRightMenuSezioni" ).isVisible() ) {
            page.getRequest().setAttribute("AmvRightMenuSezioniParent",page);
            common.AmvRightMenuSezioni.AmvRightMenuSezioniAction AmvRightMenuSezioni = new common.AmvRightMenuSezioni.AmvRightMenuSezioniAction();
            result = result != null ? result : AmvRightMenuSezioni.perform( req, resp,  context );
            page.setCookies();
        }
        if ( page.getChild( "AmvRightDoc" ).isVisible() ) {
            page.getRequest().setAttribute("AmvRightDocParent",page);
            common.AmvRightDoc.AmvRightDocAction AmvRightDoc = new common.AmvRightDoc.AmvRightDocAction();
            result = result != null ? result : AmvRightDoc.perform( req, resp,  context );
            page.setCookies();
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End RightAction: call children actions

//Right Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End Right Page: method validate

//RightAction Tail @1-FCB6E20C
}
//End RightAction Tail


