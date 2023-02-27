//AD4_MODULIHELPHandler Head @50-3027677E
package common.AmvHeader;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
import java.io.*;

public class AD4_MODULIHELPHandler implements ControlListener {
//End AD4_MODULIHELPHandler Head

//BeforeShow Head @50-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Custom Code @51-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
	//String helpDir = SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVCONTEXT").toString() + "/help/";
	//String helpFile;
	//String currentPage = SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVPC").toString();
	//String currentContext = SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVCONTEXT").toString() + "/";
	//helpFile = helpDir + currentPage;
	//int j = helpDir.indexOf(currentContext);
	//String realFile = helpFile.substring(j + currentContext.length());
	//realFile = realFile.replace('/',File.separatorChar);
	//String path = "/";
    //String realPath = e.getPage().getRequest().getRealPath(path);
	//String realFileName = realPath + realFile;

	//String helpDir = SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVCONTEXT").toString() + "/help/";
	//String helpFile;
	String currentPageD = SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVPC").toString();
	if (currentPageD.lastIndexOf(".") > 0) {
		currentPageD = "/help/"+currentPageD.substring(1,currentPageD.lastIndexOf("."));
	} else {
		currentPageD = "/help/"+currentPageD;
	}
	String currentPage = "/help"+currentPageD.substring(currentPageD.lastIndexOf('/'));
	String realFileD = currentPageD.replace('/',File.separatorChar);
	String realFile = currentPage.replace('/',File.separatorChar);
	String realFileI = "/help/index";
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

    if (!(fd.exists() || fd1.exists() || f.exists() || f1.exists() || fi.exists() || fi1.exists() )) {
		e.getControl().setValue("<img border=0 src=\"../common/images/AMV/help_blank.gif\" align=\"absmiddle\">&nbsp;&nbsp;&nbsp;");
	}

//End Event BeforeShow Action Custom Code

//BeforeShow Tail @50-FCB6E20C
    }
//End BeforeShow Tail

//AD4_MODULIHELPHandler Tail @50-FCB6E20C
}
//End AD4_MODULIHELPHandler Tail

