//AD4_RICHIESTE_ABILITAZIONEGridHandler @30-A420366B
package amvadm.AdmRichieste;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class AD4_RICHIESTE_ABILITAZIONEGridHandler implements GridListener {
//End AD4_RICHIESTE_ABILITAZIONEGridHandler

// //beforeShow @30-F81417CB

//BeforeShow Head @30-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Set values for static controls @30-A2BDC118
        e.getGrid().getControl("AFCNavigator").setValue(it.finmatica.jfc.ccs.view.Navigator.show(e.getPage(),e.getGrid()));
//End Set values for static controls

//BeforeShow Tail @30-FCB6E20C
    }
//End BeforeShow Tail

// //beforeShowRow @30-F81417CB

//beforeShowRow Head @30-BDFD38FC
    public void beforeShowRow(Event e) {
//End beforeShowRow Head

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

//AD4_RICHIESTE_ABILITAZIONEHandler Tail @30-FCB6E20C
}
//End AD4_RICHIESTE_ABILITAZIONEHandler Tail

