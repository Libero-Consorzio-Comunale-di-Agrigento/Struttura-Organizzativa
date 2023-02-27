//AmvIncludeLinkHandler imports @1-B929C107
package common.AmvIncludeLink;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvIncludeLinkHandler imports
import java.io.*;
//AmvIncludeLinkHandler Head @1-55AF69DF
public class AmvIncludeLinkPageHandler implements PageListener {
//End AmvIncludeLinkHandler Head

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

//Set values @1-78B8F88E
        e.getPage().getControl("PAGINA_LINK").setValue(getLinkPage(e));
//End Set values

//BeforeShow Tail @1-FCB6E20C
    }
//End BeforeShow Tail

//BeforeUnload Head @1-1DDBA584
    public void beforeUnload(Event e) {
//End BeforeUnload Head

//BeforeUnload Tail @1-FCB6E20C
    }
//End BeforeUnload Tail
public String getLinkPage(Event e) {
// custom AFC
   String path = "/";
   if (e.getPage().getRequest().getParameter("MVPG")  != null) {
      String realPath = e.getPage().getRequest().getRealPath(path);
      //String dirName = realPath   + File.separator + page.getRequest().getParameter("MVPG");
      String dirName = realPath   + File.separator + "common" + File.separator + "pages" + File.separator + e.getPage().getRequest().getParameter("MVPG");
	  // Filtro sul tipo di file ammessi in lettura
	  String espr_reg = ".*\\.(html|htm)";
	  if (dirName.matches(espr_reg)) {
	      File f = new File(dirName);
	      if (f.exists()) {
	         if (!f.isDirectory()) {
	            char[] cbuf = new char [ (int) f.length() ];
	            try {
				   FileReader fr = new FileReader(f);
	               fr.read(cbuf);
	               return new String(cbuf);
			    }
				catch (Exception ioe) {
	                return "Pagina non presente";
	            }
	         }
	       }
	   } else {
		   return "Pagine ammesse : html, htm";
	   }
     }
	return "Pagina non presente";
}

//AmvIncludeLinkHandler Tail @1-FCB6E20C
}
//End AmvIncludeLinkHandler Tail

