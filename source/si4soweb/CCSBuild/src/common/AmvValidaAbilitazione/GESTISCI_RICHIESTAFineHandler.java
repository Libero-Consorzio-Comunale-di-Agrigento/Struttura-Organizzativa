//GESTISCI_RICHIESTAFineHandler Head @19-4C86CAA9
package common.AmvValidaAbilitazione;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class GESTISCI_RICHIESTAFineHandler implements ButtonListener {
//End GESTISCI_RICHIESTAFineHandler Head

//onClick Head @19-A9885EEC
    public void onClick(Event e) {
//End onClick Head

//Event OnClick Action Custom Code @21-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
try {
 e.getPage().getResponse().sendRedirect("../common/AmvRegistrazioneFine.do"); 
} catch (Exception ex)  {
		ex.printStackTrace();
		System.out.println("eccezione, guarda stderr!");
}
//End Event OnClick Action Custom Code

//onClick Tail @19-FCB6E20C
}
//End onClick Tail

//beforeShow Head @19-46046458
    public void beforeShow(Event e) {
//End beforeShow Head

//GESTISCI_RICHIESTAFineHandler Tail @19-F5FC18C5
    }
}
//End GESTISCI_RICHIESTAFineHandler Tail

