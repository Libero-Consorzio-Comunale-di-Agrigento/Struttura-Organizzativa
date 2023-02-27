//AD4_RICHIESTE_ABILITAZIONERecordRespingiHandler Head @26-58D26272
package amvadm.AdmRichiesta;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class AD4_RICHIESTE_ABILITAZIONERecordRespingiHandler implements ButtonListener {
//End AD4_RICHIESTE_ABILITAZIONERecordRespingiHandler Head

//onClick Head @26-A9885EEC
    public void onClick(Event e) {
//End onClick Head

//onClick Tail @26-FCB6E20C
}
//End onClick Tail

//beforeShow Head @26-46046458
    public void beforeShow(Event e) {
//End beforeShow Head

//Event BeforeShow Action Custom Code @27-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
 e.getButton().setVisible( false );

 if (e.getPage().getRequest().getParameter("TC") != null) {
   if (e.getPage().getRequest().getParameter("TC").equals("R")){
      e.getButton().setVisible( true );
   }
}

//End Event BeforeShow Action Custom Code

//AD4_RICHIESTE_ABILITAZIONERecordRespingiHandler Tail @26-F5FC18C5
    }
}
//End AD4_RICHIESTE_ABILITAZIONERecordRespingiHandler Tail

