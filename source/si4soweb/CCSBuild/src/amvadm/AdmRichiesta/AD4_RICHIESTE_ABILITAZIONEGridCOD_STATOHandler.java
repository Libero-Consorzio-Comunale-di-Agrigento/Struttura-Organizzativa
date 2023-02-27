//AD4_RICHIESTE_ABILITAZIONEGridCOD_STATOHandler Head @63-22AE1423
package amvadm.AdmRichiesta;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class AD4_RICHIESTE_ABILITAZIONEGridCOD_STATOHandler implements ValidationListener {
//End AD4_RICHIESTE_ABILITAZIONEGridCOD_STATOHandler Head

//OnValidate Head @63-5F430F8E
    public void onValidate(Event e) {
//End OnValidate Head

//OnValidate Tail @63-FCB6E20C
    }
//End OnValidate Tail

//BeforeShow Head @63-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Custom Code @67-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
 e.getPage().getRequest().setAttribute("stato", e.getControl().getValue());
//End Event BeforeShow Action Custom Code

//BeforeShow Tail @63-FCB6E20C
    }
//End BeforeShow Tail

//AD4_RICHIESTE_ABILITAZIONEGridCOD_STATOHandler Tail @63-FCB6E20C
}
//End AD4_RICHIESTE_ABILITAZIONEGridCOD_STATOHandler Tail

