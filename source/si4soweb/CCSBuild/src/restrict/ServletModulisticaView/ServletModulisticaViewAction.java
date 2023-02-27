//ServletModulisticaViewAction imports @1-D6C072AF
package restrict.ServletModulisticaView;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End ServletModulisticaViewAction imports

//ServletModulisticaViewAction class @1-FC4BF4E1
public class ServletModulisticaViewAction extends Action {

//End ServletModulisticaViewAction class

//ServletModulisticaViewAction: method perform @1-39ECE9C2
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new ServletModulisticaViewModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "ServletModulisticaViewModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End ServletModulisticaViewAction: method perform

//ServletModulisticaViewAction: call children actions @1-8FA02E15
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End ServletModulisticaViewAction: call children actions

//ServletModulisticaView Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End ServletModulisticaView Page: method validate

//ServletModulisticaViewAction Tail @1-FCB6E20C
}
//End ServletModulisticaViewAction Tail
