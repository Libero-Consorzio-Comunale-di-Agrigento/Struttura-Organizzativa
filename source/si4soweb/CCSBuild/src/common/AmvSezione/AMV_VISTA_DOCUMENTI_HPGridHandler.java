//AMV_VISTA_DOCUMENTI_HPGridHandler @30-345248B9
package common.AmvSezione;
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

// //beforeShow @30-F81417CB

//BeforeShow Head @30-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Custom Code @37-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
//End Event BeforeShow Action Custom Code

//BeforeShow Tail @30-FCB6E20C
    }
//End BeforeShow Tail

// //beforeShowRow @30-F81417CB

//beforeShowRow Head @30-BDFD38FC
    public void beforeShowRow(Event e) {
//End beforeShowRow Head

//Set values for static controls @30-A71B84A3
        e.getGrid().getLink("TITOLO").getParameter("MVVC").setValue(( "mvdocui" ));
//End Set values for static controls

//beforeShowRow Tail @30-FCB6E20C
    }
//End beforeShowRow Tail

// //beforeSelect @30-F81417CB

//BeforeSelect Head @30-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//BeforeSelect Tail @30-FCB6E20C
    }
//End BeforeSelect Tail

//AMV_VISTA_DOCUMENTI_HPHandler Tail @30-FCB6E20C
}
//End AMV_VISTA_DOCUMENTI_HPHandler Tail

