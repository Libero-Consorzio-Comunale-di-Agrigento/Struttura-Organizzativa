//MainAction imports @1-294DC298
package common.Main;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End MainAction imports

//MainAction class @1-31FA3A0C
public class MainAction extends Action {

//End MainAction class

//MainAction: method perform @1-7ADD91CE
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new MainModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "MainModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End MainAction: method perform

//MainAction: call children actions @1-61F176DF
        if ( page.getChild( "AmvStyle" ).isVisible() ) {
            page.getRequest().setAttribute("AmvStyleParent",page);
            common.AmvStyle.AmvStyleAction AmvStyle = new common.AmvStyle.AmvStyleAction();
            result = result != null ? result : AmvStyle.perform( req, resp,  context );
            page.setCookies();
        }
        if ( page.getChild( "AmvHome" ).isVisible() ) {
            page.getRequest().setAttribute("AmvHomeParent",page);
            common.AmvHome.AmvHomeAction AmvHome = new common.AmvHome.AmvHomeAction();
            result = result != null ? result : AmvHome.perform( req, resp,  context );
            page.setCookies();
        }
        if ( page.getChild( "AmvMain" ).isVisible() ) {
            page.getRequest().setAttribute("AmvMainParent",page);
            common.AmvMain.AmvMainAction AmvMain = new common.AmvMain.AmvMainAction();
            result = result != null ? result : AmvMain.perform( req, resp,  context );
            page.setCookies();
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End MainAction: call children actions

//Main Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End Main Page: method validate

//MainAction Tail @1-FCB6E20C
}
//End MainAction Tail

