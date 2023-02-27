//AD4_RICHIESTE_ABILITAZIONEGridCOD_NOTIFICATAHandler Head @66-33920CB2
package amvadm.AdmRichiesta;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class AD4_RICHIESTE_ABILITAZIONEGridCOD_NOTIFICATAHandler implements ValidationListener {
//End AD4_RICHIESTE_ABILITAZIONEGridCOD_NOTIFICATAHandler Head

//OnValidate Head @66-5F430F8E
    public void onValidate(Event e) {
//End OnValidate Head

//OnValidate Tail @66-FCB6E20C
    }
//End OnValidate Tail

//BeforeShow Head @66-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Custom Code @68-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
  e.getPage().getRequest().setAttribute("notificata", e.getControl().getValue());

//End Event BeforeShow Action Custom Code

//BeforeShow Tail @66-FCB6E20C
    }
//End BeforeShow Tail

//AD4_RICHIESTE_ABILITAZIONEGridCOD_NOTIFICATAHandler Tail @66-FCB6E20C
}
//End AD4_RICHIESTE_ABILITAZIONEGridCOD_NOTIFICATAHandler Tail

