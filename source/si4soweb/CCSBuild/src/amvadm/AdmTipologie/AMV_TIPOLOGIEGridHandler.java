//AMV_TIPOLOGIEGridHandler @7-B3702873
package amvadm.AdmTipologie;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class AMV_TIPOLOGIEGridHandler implements GridListener {
//End AMV_TIPOLOGIEGridHandler

// //beforeShow @7-F81417CB

//BeforeShow Head @7-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Set values for static controls @7-A2BDC118
        e.getGrid().getControl("AFCNavigator").setValue(it.finmatica.jfc.ccs.view.Navigator.show(e.getPage(),e.getGrid()));
//End Set values for static controls

//BeforeShow Tail @7-FCB6E20C
    }
//End BeforeShow Tail

// //beforeShowRow @7-F81417CB

//beforeShowRow Head @7-BDFD38FC
    public void beforeShowRow(Event e) {
//End beforeShowRow Head

//beforeShowRow Tail @7-FCB6E20C
    }
//End beforeShowRow Tail

// //beforeSelect @7-F81417CB

//BeforeSelect Head @7-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//BeforeSelect Tail @7-FCB6E20C
    }
//End BeforeSelect Tail

//AMV_TIPOLOGIEHandler Tail @7-FCB6E20C
}
//End AMV_TIPOLOGIEHandler Tail

