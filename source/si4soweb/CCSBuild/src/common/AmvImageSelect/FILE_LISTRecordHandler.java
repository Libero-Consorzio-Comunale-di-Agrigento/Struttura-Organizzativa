//FILE_LISTHandler Head @2-47D40433
package common.AmvImageSelect;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import java.io.*;
import it.finmatica.jfc.io.*;

public class FILE_LISTRecordHandler implements RecordListener {
//End FILE_LISTHandler Head

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

//Event BeforeSelect Action Custom Code @24-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
if (e.getPage().getFile("FILE_UPLOAD") != null) {
   if (e.getPage().getFile("FILE_UPLOAD").getSize() == 0) {
      e.getRecord().addError("File selezionato vuoto o inesistente");
    } else {
	String workingFolder = null;
	String tipiFile = "gif|jpg|jpeg|png";
	String dirUpload = SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVDIRUPLOAD").toString();
	byte[] b = e.getPage().getFile("FILE_UPLOAD").getContent();
	ByteArrayInputStream bais = new ByteArrayInputStream(b);
    if (e.getPage().getRequest().getParameter("MVTYPE")  != null) {
		String tipo = e.getPage().getRequest().getParameter("MVTYPE").toString();
	    if (tipo.equals("img")) {
			workingFolder = "images";
		} else if (tipo.equals("docimg")) {
			workingFolder = "docs";
		} else if (tipo.equals("icn")) {
			workingFolder = "images/icone";
		} else {
			workingFolder = "images";
		}
	}
    String path = "";
    String realPath = e.getPage().getRequest().getRealPath(path);
	// Elaboro il path corrente in base alla directory di upload
	// impostata a livello di variabile di sessione

	if (dirUpload.indexOf("../") == 0) {
		int k = dirUpload.indexOf("../");
		realPath = realPath.substring(0,realPath.lastIndexOf("/"));
		realPath = realPath + "/" + dirUpload.substring(k+3, dirUpload.length());	
	} else {
		realPath = realPath + "/" + dirUpload;
	}
    if (workingFolder != null) {
	    workingFolder = workingFolder.replace('/',File.separatorChar);
        workingFolder = workingFolder.replace('\\',File.separatorChar);
	}
	String dirName = realPath  + "/"  + workingFolder;
	String nomeFile = dirName + File.separator + e.getPage().getFile("FILE_UPLOAD").getName();
	String tipoFile = nomeFile.substring(nomeFile.lastIndexOf(".")+1);
	String espr_reg = ".*\\.(" + tipiFile + ")";
	File f = new File(nomeFile);

// Controllo i tipi di file caricabili	
    if (nomeFile.matches(espr_reg)) {
		if (f.exists()) {
			e.getRecord().addError("File già esistente.");
		} else {
			try {
				LetturaScritturaFileFS writer = new LetturaScritturaFileFS(nomeFile);
				writer.scriviFile(bais);
			} catch (Exception exc) {
				System.out.println("Exception in scrittura file (AmvImageSelect)");
			}
		}
	} else {
       e.getRecord().addError("Tipo file non ammesso");
	}
}
}

//End Event BeforeSelect Action Custom Code

//BeforeSelect Tail @2-FCB6E20C
    }
//End BeforeSelect Tail

//BeforeInsert Head @2-75B62B83
    public void beforeInsert(Event e) {
//End BeforeInsert Head

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

	// Impostazione directory e tipi di file in base a parametro MVTYPE
    if (e.getPage().getRequest().getParameter("MVTYPE")  != null) {
		String tipo = e.getPage().getRequest().getParameter("MVTYPE").toString();
	    if (tipo.equals("img")) {
			workingFolder = "images";
		} else if (tipo.equals("docimg")) {
			workingFolder = "docs";
		} else if (tipo.equals("icn")) {
			workingFolder = "images/icone";
		} else {
			workingFolder = "images";
		}
	}

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
		labelContents.append("<select style=\"width:98%;height:100%\" size=\"10\" name=\"VALORE\" class=\"AFCSelect\" onclick=\"mostra(this.value,'../"+workingFolderView+"')\">");
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

//FILE_LISTHandler Tail @2-FCB6E20C
}
//End FILE_LISTHandler Tail

