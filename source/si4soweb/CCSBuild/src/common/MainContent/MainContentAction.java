//MainContentAction imports @1-B1D90AAD
package common.MainContent;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End MainContentAction imports

//MainContentAction class @1-AACC0F5B
public class MainContentAction extends Action {

//End MainContentAction class

//MainContentAction: method perform @1-B16904F5
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new MainContentModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "MainContentModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End MainContentAction: method perform

//MainContentAction: call children actions @1-8FA02E15
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End MainContentAction: call children actions

//MainContent Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End MainContent Page: method validate

//MainContentAction Tail @1-FCB6E20C
}
//End MainContentAction Tail

