//DocGridHandler @3-ACB87B61
package common.AmvIncludeDoc;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;


public class DocGridHandler implements GridListener {
//End DocGridHandler

// //beforeShow @3-F81417CB

//BeforeShow Head @3-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//BeforeShow Tail @3-FCB6E20C
    }
//End BeforeShow Tail

// //beforeShowRow @3-F81417CB

//beforeShowRow Head @3-BDFD38FC
    public void beforeShowRow(Event e) {
//End beforeShowRow Head

//Set values for static controls @3-49BAF709
        e.getGrid().getControl("DOC_LINK").setValue(getLinkDoc(e.getGrid().currentRow().get("LINK").toString(),e));
//End Set values for static controls

//beforeShowRow Tail @3-FCB6E20C
    }
//End beforeShowRow Tail

// //beforeSelect @3-F81417CB

//BeforeSelect Head @3-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//BeforeSelect Tail @3-FCB6E20C
    }
//End BeforeSelect Tail
public String getLinkDoc(String Pagina, Event e) {
// custom AFC
   String path = "/";
   String mvDirUpload = "";
   		mvDirUpload = SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVDIRUPLOAD").toString();
/*
   if (SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVDIRUPLOAD") != null) {
   } else {
   		mvDirUpload = "common";
   }*/
   mvDirUpload = mvDirUpload.replace('/',File.separatorChar);
      String realPath = e.getPage().getRequest().getRealPath(path);
      //String dirName = realPath   + File.separator + "common" + File.separator + "docs" + File.separator +page.getRequest().getParameter("MVPG");
      String dirName = realPath   + File.separator + mvDirUpload + File.separator + "docs" + File.separator + Pagina;
	  //System.out.println("Documento da visualizzare " + dirName);
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
	                return "Documento non presente";
	            }
	         }
	       }
	   } else {
		   //return "Pagine ammesse : html, htm";
		   // Ritorno stringa vuota, serve in visualizzazione del documento AmvDocumentoInfo
		   return "";
	   }
	   return "Documento non presente";
}

//DocHandler Tail @3-FCB6E20C
}
//End DocHandler Tail

