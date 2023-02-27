//AMV_CATEGORIEGridHandler @2-A93E792B
package amvadm.AdmCategorie;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class AMV_CATEGORIEGridHandler implements GridListener {
//End AMV_CATEGORIEGridHandler

// //beforeShow @2-F81417CB

//BeforeShow Head @2-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Set values for static controls @2-A2BDC118
        e.getGrid().getControl("AFCNavigator").setValue(it.finmatica.jfc.ccs.view.Navigator.show(e.getPage(),e.getGrid()));
//End Set values for static controls

//BeforeShow Tail @2-FCB6E20C
    }
//End BeforeShow Tail

// //beforeShowRow @2-F81417CB

//beforeShowRow Head @2-BDFD38FC
    public void beforeShowRow(Event e) {
//End beforeShowRow Head

//beforeShowRow Tail @2-FCB6E20C
    }
//End beforeShowRow Tail

// //beforeSelect @2-F81417CB

//BeforeSelect Head @2-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//BeforeSelect Tail @2-FCB6E20C
    }
//End BeforeSelect Tail

//AMV_CATEGORIEHandler Tail @2-FCB6E20C
}
//End AMV_CATEGORIEHandler Tail

