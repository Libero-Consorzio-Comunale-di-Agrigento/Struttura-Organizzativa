//AccessiDettaglioGridHandler @41-9A40C32C
package amvadm.AdmAccessi;
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

// //beforeShow @41-F81417CB

//BeforeShow Head @41-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Set values for static controls @41-A2BDC118
        e.getGrid().getControl("AFCNavigator").setValue(it.finmatica.jfc.ccs.view.Navigator.show(e.getPage(),e.getGrid()));
//End Set values for static controls

//Event BeforeShow Action Custom Code @46-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
//End Event BeforeShow Action Custom Code

//BeforeShow Tail @41-FCB6E20C
    }
//End BeforeShow Tail

// //beforeShowRow @41-F81417CB

//beforeShowRow Head @41-BDFD38FC
    public void beforeShowRow(Event e) {
//End beforeShowRow Head

//Set values for static controls @41-32260F7A
        e.getGrid().getLink("NOMINATIVO").getParameter("MVVC").setValue(( "admuteni" ));
//End Set values for static controls

//beforeShowRow Tail @41-FCB6E20C
    }
//End beforeShowRow Tail

// //beforeSelect @41-F81417CB

//BeforeSelect Head @41-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//BeforeSelect Tail @41-FCB6E20C
    }
//End BeforeSelect Tail

//AccessiDettaglioHandler Tail @41-FCB6E20C
}
//End AccessiDettaglioHandler Tail

