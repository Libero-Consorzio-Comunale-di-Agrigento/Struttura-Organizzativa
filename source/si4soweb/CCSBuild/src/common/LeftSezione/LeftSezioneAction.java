//LeftSezioneAction imports @1-4A514CB0
package common.LeftSezione;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End LeftSezioneAction imports

//LeftSezioneAction class @1-DD607DE2
public class LeftSezioneAction extends Action {

//End LeftSezioneAction class

//LeftSezioneAction: method perform @1-99B6E68F
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new LeftSezioneModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "LeftSezioneModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End LeftSezioneAction: method perform

//LeftSezioneAction: call children actions @1-1EA1DFAC
        if ( page.getChild( "AmvLeftMenu" ).isVisible() ) {
            page.getRequest().setAttribute("AmvLeftMenuParent",page);
            common.AmvLeftMenu.AmvLeftMenuAction AmvLeftMenu = new common.AmvLeftMenu.AmvLeftMenuAction();
            result = result != null ? result : AmvLeftMenu.perform( req, resp,  context );
            page.setCookies();
        }
        if ( page.getChild( "AmvLeftMenuSezioni" ).isVisible() ) {
            page.getRequest().setAttribute("AmvLeftMenuSezioniParent",page);
            common.AmvLeftMenuSezioni.AmvLeftMenuSezioniAction AmvLeftMenuSezioni = new common.AmvLeftMenuSezioni.AmvLeftMenuSezioniAction();
            result = result != null ? result : AmvLeftMenuSezioni.perform( req, resp,  context );
            page.setCookies();
        }
        if ( page.getChild( "AmvLeftDoc" ).isVisible() ) {
            page.getRequest().setAttribute("AmvLeftDocParent",page);
            common.AmvLeftDoc.AmvLeftDocAction AmvLeftDoc = new common.AmvLeftDoc.AmvLeftDocAction();
            result = result != null ? result : AmvLeftDoc.perform( req, resp,  context );
            page.setCookies();
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End LeftSezioneAction: call children actions

//LeftSezione Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End LeftSezione Page: method validate

//LeftSezioneAction Tail @1-FCB6E20C
}
//End LeftSezioneAction Tail
