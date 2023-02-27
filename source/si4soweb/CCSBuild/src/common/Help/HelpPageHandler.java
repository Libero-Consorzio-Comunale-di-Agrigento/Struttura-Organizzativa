//HelpHandler imports @1-8C9D9FE8
package common.Help;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End HelpHandler imports

//HelpHandler Head @1-41235ABC
public class HelpPageHandler implements PageListener {
//End HelpHandler Head

//AfterInitialize Head @1-89E84600
    public void afterInitialize(Event e) {
//End AfterInitialize Head

//AfterInitialize Tail @1-FCB6E20C
    }
//End AfterInitialize Tail

//OnInitializeView Head @1-E3C15E0F
    public void onInitializeView(Event e) {
//End OnInitializeView Head

//OnInitializeView Tail @1-FCB6E20C
    }
//End OnInitializeView Tail

//BeforeShow Head @1-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Custom Code @2-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
 	String helpParam = "";
    if (e.getPage().getRequest().getParameter("ID") != null) { 
		helpParam = "?ID=" + e.getPage().getRequest().getParameter("ID");
	}
 	try {
		e.getPage().getResponse().sendRedirect("AmvHelp.do" + helpParam);
	} catch (Exception ex)  {
		ex.printStackTrace();
	}

//End Event BeforeShow Action Custom Code

//BeforeShow Tail @1-FCB6E20C
    }
//End BeforeShow Tail

//BeforeUnload Head @1-1DDBA584
    public void beforeUnload(Event e) {
//End BeforeUnload Head

//BeforeUnload Tail @1-FCB6E20C
    }
//End BeforeUnload Tail

//HelpHandler Tail @1-FCB6E20C
}
//End HelpHandler Tail

