//AD4_RICHIESTE_ABILITAZIONERecordApprovaHandler Head @9-76C63948
package amvadm.AdmRichiesta;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class AD4_RICHIESTE_ABILITAZIONERecordApprovaHandler implements ButtonListener {
//End AD4_RICHIESTE_ABILITAZIONERecordApprovaHandler Head

//onClick Head @9-A9885EEC
    public void onClick(Event e) {
//End onClick Head

//onClick Tail @9-FCB6E20C
}
//End onClick Tail

//beforeShow Head @9-46046458
    public void beforeShow(Event e) {
//End beforeShow Head

//Event BeforeShow Action Custom Code @25-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */

e.getButton().setVisible( false );
if (e.getPage().getRequest().getParameter("TC") != null) {
	if (e.getPage().getRequest().getParameter("TC").equals("A")){
		if (e.getPage().getRequest().getAttribute("stato").toString().equals("C")) {
			e.getButton().setVisible( true );
		}
	}
}

//End Event BeforeShow Action Custom Code

//AD4_RICHIESTE_ABILITAZIONERecordApprovaHandler Tail @9-F5FC18C5
    }
}
//End AD4_RICHIESTE_ABILITAZIONERecordApprovaHandler Tail

