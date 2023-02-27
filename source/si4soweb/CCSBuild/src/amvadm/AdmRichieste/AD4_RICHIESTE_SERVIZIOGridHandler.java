//AD4_RICHIESTE_SERVIZIOGridHandler @123-9278C2E4
package amvadm.AdmRichieste;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class AD4_RICHIESTE_SERVIZIOGridHandler implements GridListener {
//End AD4_RICHIESTE_SERVIZIOGridHandler

// //beforeShow @123-F81417CB

//BeforeShow Head @123-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Set values for static controls @123-A2BDC118
        e.getGrid().getControl("AFCNavigator").setValue(it.finmatica.jfc.ccs.view.Navigator.show(e.getPage(),e.getGrid()));
//End Set values for static controls

//Event BeforeShow Action Custom Code @152-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
 if (e.getGrid().getAmountOfRows() == 0) {
  e.getGrid().setVisible(false);

 }
//End Event BeforeShow Action Custom Code

//BeforeShow Tail @123-FCB6E20C
    }
//End BeforeShow Tail

// //beforeShowRow @123-F81417CB

//beforeShowRow Head @123-BDFD38FC
    public void beforeShowRow(Event e) {
//End beforeShowRow Head

//Set values for static controls @123-A24D31B1
        e.getGrid().getLink("APPROVA").getParameter("TC").setValue(( "A" ));
        e.getGrid().getLink("RESPINGI").getParameter("TC").setValue(( "R" ));
        e.getGrid().getLink("NOTIFICA").getParameter("TC").setValue(( "N" ));
//End Set values for static controls

//beforeShowRow Tail @123-FCB6E20C
    }
//End beforeShowRow Tail

// //beforeSelect @123-F81417CB

//BeforeSelect Head @123-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//BeforeSelect Tail @123-FCB6E20C
    }
//End BeforeSelect Tail

//AD4_RICHIESTE_SERVIZIOHandler Tail @123-FCB6E20C
}
//End AD4_RICHIESTE_SERVIZIOHandler Tail

