//AD4_UTENTEGridGridHandler @67-F215C14F
package common.AmvServiziRichiesta;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class AD4_UTENTEGridGridHandler implements GridListener {
//End AD4_UTENTEGridGridHandler

// //beforeShow @67-F81417CB

//BeforeShow Head @67-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//BeforeShow Tail @67-FCB6E20C
    }
//End BeforeShow Tail

// //beforeShowRow @67-F81417CB

//beforeShowRow Head @67-BDFD38FC
    public void beforeShowRow(Event e) {
//End beforeShowRow Head

//Set values for static controls @67-86EE1422
        e.getGrid().getLink("MODIFICA_RESIDENZA").getParameter("MVPAGES").setValue(( "AmvServiziRichiesta.do" ));
        e.getGrid().getLink("MODIFICA_RECAPITO").getParameter("MVPAGES").setValue(( "AmvServiziRichiesta.do" ));
//End Set values for static controls

//beforeShowRow Tail @67-FCB6E20C
    }
//End beforeShowRow Tail

// //beforeSelect @67-F81417CB

//BeforeSelect Head @67-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//BeforeSelect Tail @67-FCB6E20C
    }
//End BeforeSelect Tail

//AD4_UTENTEGridHandler Tail @67-FCB6E20C
}
//End AD4_UTENTEGridHandler Tail

