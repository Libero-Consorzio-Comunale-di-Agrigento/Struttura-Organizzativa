//SERVIZI_ABILITATILabel1Handler Head @40-9B96686D
package common.AmvServiziAbilitatiElenco_i;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class SERVIZI_ABILITATILabel1Handler implements ControlListener {
//End SERVIZI_ABILITATILabel1Handler Head

//BeforeShow Head @40-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Custom Code @41-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
 			
            com.codecharge.components.Sorter Sorter2 = new com.codecharge.components.Sorter("Sorter2", e.getPage().getGrid("SERVIZI_ABILITATI"), e.getPage());
            Sorter2.setColumn("NOTIFICA");
            e.getPage().getGrid("SERVIZI_ABILITATI").add(Sorter2);
//End Event BeforeShow Action Custom Code

//BeforeShow Tail @40-FCB6E20C
    }
//End BeforeShow Tail

//SERVIZI_ABILITATILabel1Handler Tail @40-FCB6E20C
}
//End SERVIZI_ABILITATILabel1Handler Tail

