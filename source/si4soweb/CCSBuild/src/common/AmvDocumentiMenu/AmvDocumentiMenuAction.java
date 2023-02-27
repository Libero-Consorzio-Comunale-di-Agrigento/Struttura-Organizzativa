//AmvDocumentiMenuAction imports @1-5DAA1986
package common.AmvDocumentiMenu;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvDocumentiMenuAction imports

//AmvDocumentiMenuAction class @1-8C3ABC5F
public class AmvDocumentiMenuAction extends Action {

//End AmvDocumentiMenuAction class

//AmvDocumentiMenuAction: method perform @1-38C79404
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvDocumentiMenuModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvDocumentiMenuModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvDocumentiMenuAction: method perform

//AmvDocumentiMenuAction: call children actions @1-8FA02E15
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvDocumentiMenuAction: call children actions

//AmvDocumentiMenu Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvDocumentiMenu Page: method validate

//AmvDocumentiMenuAction Tail @1-FCB6E20C
}
//End AmvDocumentiMenuAction Tail

