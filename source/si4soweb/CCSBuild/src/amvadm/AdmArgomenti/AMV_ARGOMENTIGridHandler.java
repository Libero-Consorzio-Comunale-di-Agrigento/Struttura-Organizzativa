//AMV_ARGOMENTIGridHandler @5-28192C28
package amvadm.AdmArgomenti;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class AMV_ARGOMENTIGridHandler implements GridListener {
//End AMV_ARGOMENTIGridHandler

// //beforeShow @5-F81417CB

//BeforeShow Head @5-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Set values for static controls @5-A2BDC118
        e.getGrid().getControl("AFCNavigator").setValue(it.finmatica.jfc.ccs.view.Navigator.show(e.getPage(),e.getGrid()));
//End Set values for static controls

//BeforeShow Tail @5-FCB6E20C
    }
//End BeforeShow Tail

// //beforeShowRow @5-F81417CB

//beforeShowRow Head @5-BDFD38FC
    public void beforeShowRow(Event e) {
//End beforeShowRow Head

//beforeShowRow Tail @5-FCB6E20C
    }
//End beforeShowRow Tail

// //beforeSelect @5-F81417CB

//BeforeSelect Head @5-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//BeforeSelect Tail @5-FCB6E20C
    }
//End BeforeSelect Tail

//AMV_ARGOMENTIHandler Tail @5-FCB6E20C
}
//End AMV_ARGOMENTIHandler Tail

