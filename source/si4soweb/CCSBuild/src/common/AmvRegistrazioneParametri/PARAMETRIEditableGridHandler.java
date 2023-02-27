//PARAMETRIGridHandler @6-D8D3F058
package common.AmvRegistrazioneParametri;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class PARAMETRIEditableGridHandler implements EditableGridListener {
//End PARAMETRIGridHandler

// //beforeSelect @6-F81417CB

//BeforeSelect Head @6-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//BeforeSelect Tail @6-FCB6E20C
    }
//End BeforeSelect Tail

// //beforeShow @6-F81417CB

//BeforeShow Head @6-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//BeforeShow Tail @6-FCB6E20C
    }
//End BeforeShow Tail

// //beforeShowRow @6-F81417CB

//beforeShowRow Head @6-BDFD38FC
    public void beforeShowRow(Event e) {
//End beforeShowRow Head

//beforeShowRow Tail @6-FCB6E20C
    }
//End beforeShowRow Tail

//OnValidate Head @6-5F430F8E
    public void onValidate(Event e) {
//End OnValidate Head

//OnValidate Tail @6-FCB6E20C
    }
//End OnValidate Tail

//BeforeUpdate Head @6-9D1B8475
    public void beforeSubmit(Event e) {
//End BeforeUpdate Head

//BeforeUpdate Tail @6-FCB6E20C
    }
//End BeforeUpdate Tail

//AfterUpdate Head @6-9ED73E93
    public void afterSubmit(Event e) {
//End AfterUpdate Head

//Event AfterSubmit Action Custom Code @25-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
  String url = "../common/AmvValidaAbilitazione.do?ccsForm=GESTISCI_RICHIESTA:Edit&Update=Aggiorna";
  e.getPage().setRedirectString(url);
  System.out.println("Pagina di ridirezione da after submit" + e.getPage().getRedirectString());

//End Event AfterSubmit Action Custom Code

//AfterUpdate Tail @6-FCB6E20C
    }
//End AfterUpdate Tail

//PARAMETRIHandler Tail @6-FCB6E20C
}
//End PARAMETRIHandler Tail

