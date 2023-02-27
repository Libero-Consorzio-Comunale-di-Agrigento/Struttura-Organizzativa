//indexAction imports @1-B6A9DF2C
package restrict.index;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End indexAction imports

//indexAction class @1-600BE759
public class indexAction extends Action {

//End indexAction class

//indexAction: method perform @1-D088F066
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new indexModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "indexModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End indexAction: method perform

//indexAction: call children actions @1-8FA02E15
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End indexAction: call children actions

//index Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End index Page: method validate

//indexAction Tail @1-FCB6E20C
}
//End indexAction Tail

