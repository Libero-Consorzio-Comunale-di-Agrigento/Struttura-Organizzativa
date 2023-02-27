//FooterAction imports @1-D1934A5F
package common.Footer;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End FooterAction imports

//FooterAction class @1-E5DD2391
public class FooterAction extends Action {

//End FooterAction class

//FooterAction: method perform @1-B185F6D3
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new FooterModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "FooterModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End FooterAction: method perform

//FooterAction: call children actions @1-DA5D3363
        if ( page.getChild( "AmvFooter" ).isVisible() ) {
            page.getRequest().setAttribute("AmvFooterParent",page);
            common.AmvFooter.AmvFooterAction AmvFooter = new common.AmvFooter.AmvFooterAction();
            result = result != null ? result : AmvFooter.perform( req, resp,  context );
            page.setCookies();
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End FooterAction: call children actions

//Footer Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End Footer Page: method validate

//FooterAction Tail @1-FCB6E20C
}
//End FooterAction Tail

