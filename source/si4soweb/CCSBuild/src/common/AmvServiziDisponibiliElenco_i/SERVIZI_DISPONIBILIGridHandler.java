//SERVIZI_DISPONIBILIGridHandler @16-BB984F60
package common.AmvServiziDisponibiliElenco_i;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class SERVIZI_DISPONIBILIGridHandler implements GridListener {
//End SERVIZI_DISPONIBILIGridHandler

// //beforeShow @16-F81417CB

//BeforeShow Head @16-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Set values for static controls @16-A2BDC118
        e.getGrid().getControl("AFCNavigator").setValue(it.finmatica.jfc.ccs.view.Navigator.show(e.getPage(),e.getGrid()));
//End Set values for static controls

//BeforeShow Tail @16-FCB6E20C
    }
//End BeforeShow Tail

// //beforeShowRow @16-F81417CB

//beforeShowRow Head @16-BDFD38FC
    public void beforeShowRow(Event e) {
//End beforeShowRow Head

//Set values for static controls @16-56F57B21
        e.getGrid().getLink("RICHIESTA").getParameter("RR").setValue(( "1" ));
//End Set values for static controls

//beforeShowRow Tail @16-FCB6E20C
    }
//End beforeShowRow Tail

// //beforeSelect @16-F81417CB

//BeforeSelect Head @16-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//BeforeSelect Tail @16-FCB6E20C
    }
//End BeforeSelect Tail

//SERVIZI_DISPONIBILIHandler Tail @16-FCB6E20C
}
//End SERVIZI_DISPONIBILIHandler Tail

