//RightSezioneAction imports @1-C96D8006
package common.RightSezione;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End RightSezioneAction imports

//RightSezioneAction class @1-42B69CF1
public class RightSezioneAction extends Action {

//End RightSezioneAction class

//RightSezioneAction: method perform @1-7AB8889E
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new RightSezioneModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "RightSezioneModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End RightSezioneAction: method perform

//RightSezioneAction: call children actions @1-CB423A7E
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
//End RightSezioneAction: call children actions

//RightSezione Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End RightSezione Page: method validate

//RightSezioneAction Tail @1-FCB6E20C
}
//End RightSezioneAction Tail
