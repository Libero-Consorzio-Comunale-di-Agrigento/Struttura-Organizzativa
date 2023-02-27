//AdmMenuHandler imports @1-D3FF72FA
package amvadm.AdmMenu;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmMenuHandler imports

//AdmMenuHandler Head @1-BB1707FC
public class AdmMenuPageHandler implements PageListener {
//End AdmMenuHandler Head

//AfterInitialize Head @1-89E84600
    public void afterInitialize(Event e) {
//End AfterInitialize Head

//Event AfterInitialize Action Custom Code @159-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
// Impostazione variabile di sessione MVSP = Progetto Selezionato
if (e.getPage().getHttpPostParameter("SP")  != null) {
	SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVSP", e.getPage().getHttpPostParameter("SP"));
}
else {
	if (SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVSP") == null) {
		SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVSP", SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("Progetto"));
	}
}

// Impostazione variabile di sessione MVSM = Modulo Selezionato
if (e.getPage().getHttpPostParameter("SM") != null) {
	SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVSM", e.getPage().getHttpPostParameter("SM"));
} else {
	if (SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVSP").toString().equals(SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("Progetto").toString())) {
		SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVSM", SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("Modulo"));
	} else {
		SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVSM", null);
	}
	
}

// Impostazione variabile di sessione MVSR = Ruolo Selezionato
if (e.getPage().getHttpPostParameter("SR")  != null) {
	SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVSR", e.getPage().getHttpPostParameter("SR"));
}
else {
	if (SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVSR") == null) {
		SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVSR", "*");
	}
}


//End Event AfterInitialize Action Custom Code

//AfterInitialize Tail @1-FCB6E20C
    }
//End AfterInitialize Tail

//OnInitializeView Head @1-E3C15E0F
    public void onInitializeView(Event e) {
//End OnInitializeView Head

//Event OnInitializeView Action Custom Code @147-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVOPT", "UPLOAD");
SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVWF", "");

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

//AdmMenuHandler Tail @1-FCB6E20C
}
//End AdmMenuHandler Tail

