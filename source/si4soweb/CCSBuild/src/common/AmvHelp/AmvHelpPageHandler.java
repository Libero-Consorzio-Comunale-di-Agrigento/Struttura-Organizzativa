//AmvHelpHandler imports @1-45308DA2
package common.AmvHelp;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import java.io.*;
//End AmvHelpHandler imports

//AmvHelpHandler Head @1-F77A1B8A
public class AmvHelpPageHandler implements PageListener {
//End AmvHelpHandler Head

//AfterInitialize Head @1-89E84600
    public void afterInitialize(Event e) {
//End AfterInitialize Head

//DEL  /* -------------------------- *
//DEL   *  write your own code here  *
//DEL   * -------------------------- */
//DEL   	System.out.println("After initialize ID= " + e.getPage().getHttpGetParameter("ID"));
//DEL  


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

//Event BeforeShow Action Custom Code @14-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
	String helpDir = SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVCONTEXT").toString();
	String helpFileD;
	String helpFile;
  	String helpFileI;
	String currentPageD = SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVPC").toString();
	if (currentPageD.lastIndexOf(".") > 0) {
		currentPageD = "/help/"+currentPageD.substring(1,currentPageD.lastIndexOf("."));
	} else {
		currentPageD = "/help/"+currentPageD;
	}
	String currentPage = "/help"+currentPageD.substring(currentPageD.lastIndexOf('/'));
	helpFileD = helpDir + currentPageD;
	helpFile = helpDir + currentPage;
	String realFileD = currentPageD.replace('/',File.separatorChar);
	String realFile = currentPage.replace('/',File.separatorChar);
	String realFileI = "/help/index";
    helpFileI = helpDir + realFileI;
	realFileI = realFileI.replace('/',File.separatorChar);
	String path = "/";
    String realPath = e.getPage().getRequest().getRealPath(path);
	String realFileNameD = realPath + realFileD;
	String realFileName = realPath + realFile;
	String realFileNameI = realPath + realFileI;

	File fd = new File(realFileNameD + ".html");
	File fd1 = new File(realFileNameD + ".htm");
    File f = new File(realFileName + ".html");
    File f1 = new File(realFileName + ".htm");
    File fi = new File(realFileNameI + ".html");
    File fi1 = new File(realFileNameI + ".htm");


	String helpAnchor = "";
    if (e.getPage().getRequest().getParameter("ID") != null) { 
		helpAnchor = "#" + e.getPage().getRequest().getParameter("ID");
	}

    if (fd.exists()) {
		try {
			e.getPage().getResponse().sendRedirect(helpFileD + ".html" + helpAnchor);
		} catch (Exception ex)  {
			ex.printStackTrace();
		  }
	} else { 
	    if (fd1.exists()) {
		    try {
			    e.getPage().getResponse().sendRedirect(helpFileD + ".htm" + helpAnchor);
		    } catch (Exception ex)  {
			    ex.printStackTrace();
		      }
		 } 
      else { 
	    if (f.exists()) {
		    try {
			    e.getPage().getResponse().sendRedirect(helpFile + ".html" + helpAnchor);
		    } catch (Exception ex)  {
			    ex.printStackTrace();
		      }
        }
      else { 
	    if (f1.exists()) {
		    try {
			    e.getPage().getResponse().sendRedirect(helpFile + ".htm" + helpAnchor);
		    } catch (Exception ex)  {
			    ex.printStackTrace();
		      }
        }
       else {
		   if (fi.exists()) {
		    try {
			    e.getPage().getResponse().sendRedirect(helpFileI + ".html" + helpAnchor);
		    } catch (Exception ex)  {
			    ex.printStackTrace();
		      }
           }
       else {
		   if (fi1.exists()) {
		    try {
			    e.getPage().getResponse().sendRedirect(helpFileI + ".htm" + helpAnchor);
		    } catch (Exception ex)  {
			    ex.printStackTrace();
		      }
           }
	    }
}
}
}
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

//AmvHelpHandler Tail @1-FCB6E20C
}
//End AmvHelpHandler Tail

