//PARAMETRIButton_SubmitHandler Head @10-A0A1EA1B
package common.AmvRegistrazioneParametri;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class PARAMETRIButton_SubmitHandler implements ButtonListener {
//End PARAMETRIButton_SubmitHandler Head

//onClick Head @10-A9885EEC
    public void onClick(Event e) {
//End onClick Head

//Event OnClick Action Custom Code @22-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */

//End Event OnClick Action Custom Code

//onClick Tail @10-FCB6E20C
}
//End onClick Tail

//beforeShow Head @10-46046458
    public void beforeShow(Event e) {
//End beforeShow Head

//Event BeforeShow Action Custom Code @23-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
  String url = "../common/AmvValidaAbilitazione.do?ccsForm=GESTISCI_RICHIESTA:Edit&Update=Aggiorna";
  e.getPage().setRedirectString(url);


//End Event BeforeShow Action Custom Code

//PARAMETRIButton_SubmitHandler Tail @10-F5FC18C5
    }
}
//End PARAMETRIButton_SubmitHandler Tail

