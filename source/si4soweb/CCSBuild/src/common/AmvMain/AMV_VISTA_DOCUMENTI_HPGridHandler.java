//AMV_VISTA_DOCUMENTI_HPGridHandler @10-C103627A
package common.AmvMain;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class AMV_VISTA_DOCUMENTI_HPGridHandler implements GridListener {
//End AMV_VISTA_DOCUMENTI_HPGridHandler

// //beforeShow @10-F81417CB

//BeforeShow Head @10-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Custom Code @39-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
  if (e.getGrid().getAmountOfRows() == 0) {
  e.getGrid().setVisible(false);

 }
//End Event BeforeShow Action Custom Code

//BeforeShow Tail @10-FCB6E20C
    }
//End BeforeShow Tail

// //beforeShowRow @10-F81417CB

//beforeShowRow Head @10-BDFD38FC
    public void beforeShowRow(Event e) {
//End beforeShowRow Head

//Set values for static controls @10-A71B84A3
        e.getGrid().getLink("TITOLO").getParameter("MVVC").setValue(( "mvdocui" ));
//End Set values for static controls

//beforeShowRow Tail @10-FCB6E20C
    }
//End beforeShowRow Tail

// //beforeSelect @10-F81417CB

//BeforeSelect Head @10-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//BeforeSelect Tail @10-FCB6E20C
    }
//End BeforeSelect Tail

//AMV_VISTA_DOCUMENTI_HPHandler Tail @10-FCB6E20C
}
//End AMV_VISTA_DOCUMENTI_HPHandler Tail

