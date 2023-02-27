//AdmDocumentoHandler imports @1-05521534
package amvadm.AdmDocumento;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmDocumentoHandler imports

//AdmDocumentoHandler Head @1-16515739
public class AdmDocumentoPageHandler implements PageListener {
//End AdmDocumentoHandler Head

//AfterInitialize Head @1-89E84600
    public void afterInitialize(Event e) {
//End AfterInitialize Head

//AfterInitialize Tail @1-FCB6E20C
    }
//End AfterInitialize Tail

//OnInitializeView Head @1-E3C15E0F
    public void onInitializeView(Event e) {
//End OnInitializeView Head

//Event OnInitializeView Action Custom Code @117-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
 // Settaggio della variabile MVOPT per consentire upload di file nella selezione pagina del campo link
 String mvDirUpload;
 mvDirUpload = SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVDIRUPLOAD").toString();
 //SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVIF", mvDirUpload+"/docs");
 SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVWF", mvDirUpload+"/docs");
 SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVOPT", "UPLOAD");

 //Parametri per la gestione degli allegati a un documento, sono usati nella pagina AmvAttachSelect per determinare 
 //i soli allegati disponibili per una revisione di un certo documento
 SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MV_ATTACH_IDDOC", e.getPage().getHttpGetParameter("ID"));
 SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MV_ATTACH_REV", e.getPage().getHttpGetParameter("REV"));
//End Event OnInitializeView Action Custom Code

//OnInitializeView Tail @1-FCB6E20C
    }
//End OnInitializeView Tail

//BeforeShow Head @1-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//BeforeShow Tail @1-FCB6E20C
    }
//End BeforeShow Tail

//BeforeUnload Head @1-1DDBA584
    public void beforeUnload(Event e) {
//End BeforeUnload Head

//BeforeUnload Tail @1-FCB6E20C
    }
//End BeforeUnload Tail

//AdmDocumentoHandler Tail @1-FCB6E20C
}
//End AdmDocumentoHandler Tail

