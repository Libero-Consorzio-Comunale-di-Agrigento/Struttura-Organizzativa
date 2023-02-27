//AMV_DOCUMENTO_RESPINGIUpdateHandler Head @11-DF5FEED6
package common.AmvRichiestaAnnulla;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class AMV_DOCUMENTO_RESPINGIUpdateHandler implements ButtonListener {
//End AMV_DOCUMENTO_RESPINGIUpdateHandler Head

//onClick Head @11-A9885EEC
    public void onClick(Event e) {
//End onClick Head

//onClick Tail @11-FCB6E20C
}
//End onClick Tail

//beforeShow Head @11-46046458
    public void beforeShow(Event e) {
//End beforeShow Head

//Event BeforeShow Action Custom Code @44-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
 if (e.getRecord().getControl("TIPO_TESTO").getValue() != null) {
    if (e.getRecord().getControl("TIPO_TESTO").getValue().toString().equals("Richiesta")) {
       if (e.getRecord().getControl("INOLTRO").getValue() != null) {
          if (!(e.getRecord().getControl("INOLTRO").getValue().toString().equals("P"))) {
	      e.getButton().setVisible(false);
		  }
       }
	}
 }
//End Event BeforeShow Action Custom Code

//AMV_DOCUMENTO_RESPINGIUpdateHandler Tail @11-F5FC18C5
    }
}
//End AMV_DOCUMENTO_RESPINGIUpdateHandler Tail

