//AD4_RICHIESTE_ABILITAZIONERecordConvalidaHandler Head @59-816F5E9A
package amvadm.AdmRichiesta;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class AD4_RICHIESTE_ABILITAZIONERecordConvalidaHandler implements ButtonListener {
//End AD4_RICHIESTE_ABILITAZIONERecordConvalidaHandler Head

//onClick Head @59-A9885EEC
    public void onClick(Event e) {
//End onClick Head

//onClick Tail @59-FCB6E20C
}
//End onClick Tail

//beforeShow Head @59-46046458
    public void beforeShow(Event e) {
//End beforeShow Head

//Event BeforeShow Action Custom Code @60-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */

e.getButton().setVisible( false );
if (e.getPage().getRequest().getParameter("TC") != null) {
	if (e.getPage().getRequest().getParameter("TC").equals("A")){
		if (e.getPage().getRequest().getAttribute("stato").toString().equals("F")) {
			e.getButton().setVisible( true );
		}
	}
}

//End Event BeforeShow Action Custom Code

//AD4_RICHIESTE_ABILITAZIONERecordConvalidaHandler Tail @59-F5FC18C5
    }
}
//End AD4_RICHIESTE_ABILITAZIONERecordConvalidaHandler Tail

