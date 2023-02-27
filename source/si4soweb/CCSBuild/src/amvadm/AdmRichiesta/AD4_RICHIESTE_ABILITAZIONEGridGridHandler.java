//AD4_RICHIESTE_ABILITAZIONEGridGridHandler @30-B5B2B92A
package amvadm.AdmRichiesta;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class AD4_RICHIESTE_ABILITAZIONEGridGridHandler implements GridListener {
//End AD4_RICHIESTE_ABILITAZIONEGridGridHandler

// //beforeShow @30-F81417CB

//BeforeShow Head @30-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//BeforeShow Tail @30-FCB6E20C
    }
//End BeforeShow Tail

// //beforeShowRow @30-F81417CB

//beforeShowRow Head @30-BDFD38FC
    public void beforeShowRow(Event e) {
//End beforeShowRow Head

//Set values for static controls @30-BAEE67B6
        e.getGrid().getLink("RICHIEDENTE").getParameter("MVVC").setValue(( "admuteni" ));
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

//AD4_RICHIESTE_ABILITAZIONEGridHandler Tail @30-FCB6E20C
}
//End AD4_RICHIESTE_ABILITAZIONEGridHandler Tail

