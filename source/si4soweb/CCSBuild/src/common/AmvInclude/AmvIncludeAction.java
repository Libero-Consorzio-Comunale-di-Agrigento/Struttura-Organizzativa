//AmvIncludeAction imports @1-A959155E
package common.AmvInclude;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvIncludeAction imports

//AmvIncludeAction class @1-55DD3C7D
public class AmvIncludeAction extends Action {

//End AmvIncludeAction class

//AmvIncludeAction: method perform @1-B81727C4
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvIncludeModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvIncludeModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvIncludeAction: method perform

//AmvIncludeAction: call children actions @1-5AD4E951
		try {
			String pageToBeIncluded = req.getParameter("MVPG");
        	if ( page.getChild( "Pagina" ).isVisible() ) {
            //page.getRequest().setAttribute("PaginaParent",page);
            //common.AmvLeftDoc.AmvLeftDocAction Pagina = new common.AmvLeftDoc.AmvLeftDocAction();
            //result = result != null ? result : Pagina.perform( req, resp,  context );
// custom AFC
				page.getRequest().setAttribute(pageToBeIncluded + "Parent",page);
		        Action PaginaInclusa = (com.codecharge.Action)
				    Class.forName(req.getServletPath().substring(1, req.getServletPath().indexOf('/',1)) + "." + pageToBeIncluded + "." + pageToBeIncluded + "Action").newInstance();
		    		result = result != null ? result : PaginaInclusa.perform( req, resp,  context );
            }
			page.setCookies();
		} 
		catch (ClassNotFoundException e) {
			System.out.println(e.toString());
			return req.getContextPath() + "/common/Denied.do";
		}
		catch (Exception e) {
			System.out.println(e.toString());
		}
// fine custom AFC
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AmvIncludeAction: call children actions

//AmvInclude Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvInclude Page: method validate

//AmvIncludeAction Tail @1-FCB6E20C
}
//End AmvIncludeAction Tail
