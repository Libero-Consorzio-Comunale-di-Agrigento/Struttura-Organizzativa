//AccessiDettaglioGridHandler @14-B54ED80E
package amvadm.AdmUtenteUltimiAccessi;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class AccessiDettaglioGridHandler implements GridListener {
//End AccessiDettaglioGridHandler

// //beforeShow @14-F81417CB

//BeforeShow Head @14-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Set values for static controls @14-A2BDC118
        e.getGrid().getControl("AFCNavigator").setValue(it.finmatica.jfc.ccs.view.Navigator.show(e.getPage(),e.getGrid()));
//End Set values for static controls

//Event BeforeShow Action Custom Code @22-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
  if (e.getGrid().getAmountOfRows() == 0) {
  e.getGrid().setVisible(false);

 }
//End Event BeforeShow Action Custom Code

//BeforeShow Tail @14-FCB6E20C
    }
//End BeforeShow Tail

// //beforeShowRow @14-F81417CB

//beforeShowRow Head @14-BDFD38FC
    public void beforeShowRow(Event e) {
//End beforeShowRow Head

//beforeShowRow Tail @14-FCB6E20C
    }
//End beforeShowRow Tail

// //beforeSelect @14-F81417CB

//BeforeSelect Head @14-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//BeforeSelect Tail @14-FCB6E20C
    }
//End BeforeSelect Tail

//AccessiDettaglioHandler Tail @14-FCB6E20C
}
//End AccessiDettaglioHandler Tail

