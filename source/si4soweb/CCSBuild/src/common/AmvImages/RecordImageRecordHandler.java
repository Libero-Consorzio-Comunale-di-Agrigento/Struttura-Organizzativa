//RecordImageHandler Head @2-9356D0D8
package common.AmvImages;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import java.io.*;
import it.finmatica.jfc.io.*;
import javax.servlet.http.*;


public class RecordImageRecordHandler implements RecordListener {
//End RecordImageHandler Head

//BeforeShow Head @2-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Set values @2-291D65F0
        e.getRecord().getControl("FILE_LIST_BOX").setValue(fileListBox(e));
//End Set values

//BeforeShow Tail @2-FCB6E20C
    }
//End BeforeShow Tail

//OnValidate Head @2-5F430F8E
    public void onValidate(Event e) {
//End OnValidate Head

//OnValidate Tail @2-FCB6E20C
    }
//End OnValidate Tail

//BeforeSelect Head @2-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//BeforeSelect Tail @2-FCB6E20C
    }
//End BeforeSelect Tail

//BeforeInsert Head @2-75B62B83
    public void beforeInsert(Event e) {
//End BeforeInsert Head

//Event BeforeInsert Action Custom Code @6-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
		String fileName = "";
		if (e.getPage().getFile("campo_image") != null) {

          byte[] b = e.getPage().getFile("campo_image").getContent();
		  ByteArrayInputStream bais = new ByteArrayInputStream(b);

		  String path = "/";
 	   	  String realPath = e.getPage().getRequest().getRealPath(path);
  	      String dirName = realPath;
		  String workingFolder = "common" + File.separator + "docs";
  		  
		  dirName = dirName + workingFolder;
		  fileName = e.getPage().getFile("campo_image").getName();
		  
		  /* FILE EXTENSION CONTROL */
		  String tipiFile = "gif|jpg|jpeg|png";
		  String espr_reg = ".*\\.(" + tipiFile + ")";

		  String nomeEPathFile = dirName + File.separator + fileName;
		
		  if(nomeEPathFile.matches(espr_reg)){
			  
			  File fdir = new File(dirName);
			  
			  if (!fdir.exists()) {
			    fdir.mkdir();
			  }
			
			  File f = new File(nomeEPathFile);

			  LetturaScritturaFileFS writer = null;
		
		 	  try {
					writer = new LetturaScritturaFileFS(nomeEPathFile);
					writer.scriviFile(bais);
			  } catch (Exception exc) {
					System.out.println("Errore nell'upload del file"+exc.toString());
			  }
	      	  
			  //Serve per riportare un valore dentro una text box di codecharge
			  //((com.codecharge.components.TextBox) ((com.codecharge.components.Record) (e.getPage().getChild( "RecordImage" ))).getChild( "nomeImmagine")).setValue( fileName );
			  
			  SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("varImm", fileName);
		  
		  } else {
       			e.getRecord().addError("Tipo file non ammesso");
		  }


		  
		  

		}

//End Event BeforeInsert Action Custom Code

//BeforeInsert Tail @2-FCB6E20C
    }
//End BeforeInsert Tail

//AfterInsert Head @2-767A9165
    public void afterInsert(Event e) {
//End AfterInsert Head

//AfterInsert Tail @2-FCB6E20C
    }
//End AfterInsert Tail

//BeforeUpdate Head @2-33A3CFAC
    public void beforeUpdate(Event e) {
//End BeforeUpdate Head

//BeforeUpdate Tail @2-FCB6E20C
    }
//End BeforeUpdate Tail

//AfterUpdate Head @2-306F754A
    public void afterUpdate(Event e) {
//End AfterUpdate Head

//AfterUpdate Tail @2-FCB6E20C
    }
//End AfterUpdate Tail

//BeforeDelete Head @2-752E3118
    public void beforeDelete(Event e) {
//End BeforeDelete Head

//BeforeDelete Tail @2-FCB6E20C
    }
//End BeforeDelete Tail

//AfterDelete Head @2-76E28BFE
    public void afterDelete(Event e) {
//End AfterDelete Head

//AfterDelete Tail @2-FCB6E20C
    }
//End AfterDelete Tail
// Funzione chiamata come control source della label FILE_LIST_BOX
public String fileListBox(Event e) {
// custom AFC
    String viewDir = "";
	String workingFolder = null;
	String workingFolderView = null;
	String tipiFile = "gif|jpg|jpeg|png";

	String dirUpload = SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVDIRUPLOAD").toString();
	// Impostazione directory documenti
	workingFolder = "docs";

	String selected_file = null;
    if (e.getPage().getRequest().getParameter("MVFILE")  != null) {
		selected_file = e.getPage().getRequest().getParameter("MVFILE").toString();
	}
    else {
		selected_file = "\\\\";  // valore non ammesso per nome di file
	}
    String path = "";
    String realPath = e.getPage().getRequest().getRealPath(path);
// Elaboro il path corrente in base alla directory di upload
// impostata a livello di variabile di sessione

	if (dirUpload.indexOf("../") == 0) {
		int k = dirUpload.indexOf("../");
		realPath = realPath.substring(0,realPath.lastIndexOf("/"));
		realPath = realPath + "/" + dirUpload.substring(k+3, dirUpload.length());	
		workingFolderView = "../" + dirUpload;
	} else {
		realPath = realPath + "/" + dirUpload;
		workingFolderView = dirUpload;
	}

    if (workingFolder != null) {
		workingFolderView = workingFolderView  + "/" + workingFolder;
	    workingFolder = workingFolder.replace('/',File.separatorChar);
        workingFolder = workingFolder.replace('\\',File.separatorChar);
	}
	String dirName = realPath  + "/"  + workingFolder;
	StringBuffer labelContents = new StringBuffer();
	String espr_reg = ".*\\.(" + tipiFile + ")";
	File f = new File(dirName);
    if (f.exists()) {
        if (f.isDirectory()) {
        String[] list = f.list();
		java.util.Arrays.sort(list);
		labelContents.append("<select style=\"width:98%;height:100%\" size=\"30\" name=\"VALORE\" class=\"AFCSelect\" onclick=\"mostra(this.value,'../"+workingFolderView+"')\">");
        for (int i = 0; i < list.length; i++) {
			if (list[i].matches(espr_reg)) {
		    	if (list[i].matches(selected_file)) {
	  		  		labelContents.append("<option value=\"" + list[i] + "\" selected>" + list[i] + "</option>");
				}
				else {
	  		  	labelContents.append("<option value=\"" + list[i] + "\" >" + list[i] + "</option>");
				}
          	}
     	}
			labelContents.append("</select>");

        }
    }

    return (labelContents.toString());
}
//RecordImageHandler Tail @2-FCB6E20C
}
//End RecordImageHandler Tail

