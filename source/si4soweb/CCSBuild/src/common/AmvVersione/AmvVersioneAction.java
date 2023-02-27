//AmvVersioneAction imports @1-6F51BFF8
package common.AmvVersione;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvVersioneAction imports

//AmvVersioneAction class @1-B19839BE
public class AmvVersioneAction extends Action {

//End AmvVersioneAction class

//AmvVersioneAction: method perform @1-7C44BB5C
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvVersioneModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvVersioneModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvVersioneAction: method perform

//AmvVersioneAction: call children actions @1-8FA02E15
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvVersioneAction: call children actions

//AmvVersione Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvVersione Page: method validate

//AmvVersioneAction Tail @1-FCB6E20C
}
//End AmvVersioneAction Tail

