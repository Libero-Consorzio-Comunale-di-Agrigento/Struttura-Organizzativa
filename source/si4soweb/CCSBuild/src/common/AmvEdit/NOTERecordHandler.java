//NOTEHandler Head @2-9CDCDA2F
package common.AmvEdit;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
public class NOTERecordHandler implements RecordListener {
//End NOTEHandler Head

//BeforeShow Head @2-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Custom Code @31-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
 	if (e.getPage().getFile("FILE_UPLOAD") != null) {
		byte[] b = e.getPage().getFile("FILE_UPLOAD").getContent();
		String testo = new String(b);
		if (!(e.getRecord().hasErrors())) {
			e.getRecord().getControl("VALORE").setValue(testo);
		}
		else {
			e.getRecord().getControl("VALORE").setValue("");
		}
	}

//End Event BeforeShow Action Custom Code

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

//Event BeforeSelect Action Custom Code @32-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
  	if (e.getPage().getFile("FILE_UPLOAD") != null) {
		String nomeFile = e.getPage().getFile("FILE_UPLOAD").getName();
		// Elenco file caricabili nella text-area
		String espr_reg = ".*\\.(html|htm|txt)";
		if (nomeFile.matches(espr_reg)) {
			byte[] b = e.getPage().getFile("FILE_UPLOAD").getContent();
			String testo = new String(b);
			// Elenco tag non ammessi nel file che si sta caricando
			String tags = "(?s).*(<script|<SCRIPT|<object|<OBJECT|<applet|<APPLET|<embed|<EMBED).*";
			if (testo.matches(tags)) {
		         e.getRecord().addError("Il file selezionato contiene tag non ammessi (script, object, embed, applet).<br>");
			}
			if (testo.length() > 25000) {
		         e.getRecord().addError("File troppo esteso, utilizzare gestione allegati.");
			}
		}
		else {
		    e.getRecord().addError("Tipi di file ammessi : html, htm, txt");
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

//NOTEHandler Tail @2-FCB6E20C
}
//End NOTEHandler Tail

