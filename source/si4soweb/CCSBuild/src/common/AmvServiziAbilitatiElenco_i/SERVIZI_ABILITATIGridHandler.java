//SERVIZI_ABILITATIGridHandler @10-6F51F8F3
package common.AmvServiziAbilitatiElenco_i;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class SERVIZI_ABILITATIGridHandler implements GridListener {
//End SERVIZI_ABILITATIGridHandler

// //beforeShow @10-F81417CB

//BeforeShow Head @10-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Set values for static controls @10-A2BDC118
        e.getGrid().getControl("AFCNavigator").setValue(it.finmatica.jfc.ccs.view.Navigator.show(e.getPage(),e.getGrid()));
//End Set values for static controls

//BeforeShow Tail @10-FCB6E20C
    }
//End BeforeShow Tail

// //beforeShowRow @10-F81417CB

//beforeShowRow Head @10-BDFD38FC
    public void beforeShowRow(Event e) {
//End beforeShowRow Head

//beforeShowRow Tail @10-FCB6E20C
    }
//End beforeShowRow Tail

// //beforeSelect @10-F81417CB

//BeforeSelect Head @10-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//DEL  /* -------------------------- *
//DEL   *  write your own code here  *
//DEL   * -------------------------- */
//DEL              com.codecharge.components.Sorter Sorter2 = new com.codecharge.components.Sorter("Sorter2", e.getGrid(), e.getPage());
//DEL              Sorter2.setColumn("NOTIFICA");
//DEL              e.getGrid().add(Sorter2);
//DEL  


//BeforeSelect Tail @10-FCB6E20C
    }
//End BeforeSelect Tail

//SERVIZI_ABILITATIHandler Tail @10-FCB6E20C
}
//End SERVIZI_ABILITATIHandler Tail

