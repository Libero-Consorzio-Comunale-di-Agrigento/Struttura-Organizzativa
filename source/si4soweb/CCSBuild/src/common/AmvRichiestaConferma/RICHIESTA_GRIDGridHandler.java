//RICHIESTA_GRIDGridHandler @39-C9B18564
package common.AmvRichiestaConferma;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class RICHIESTA_GRIDGridHandler implements GridListener {
//End RICHIESTA_GRIDGridHandler

// //beforeShow @39-F81417CB

//BeforeShow Head @39-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//BeforeShow Tail @39-FCB6E20C
    }
//End BeforeShow Tail

// //beforeShowRow @39-F81417CB

//beforeShowRow Head @39-BDFD38FC
    public void beforeShowRow(Event e) {
//End beforeShowRow Head

//Set values for static controls @39-95DD6399
        e.getGrid().getControl("ID_RICHIESTA").setDefaultValue(null);
        e.getGrid().getLink("STAMPA_RICHIESTA").getParameter("rw").setValue(( "R" ));
        e.getGrid().getLink("MODIFICA_RICHIESTA_LINK").getParameter("rw").setValue(( "W" ));
//End Set values for static controls

//beforeShowRow Tail @39-FCB6E20C
    }
//End beforeShowRow Tail

// //beforeSelect @39-F81417CB

//BeforeSelect Head @39-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//BeforeSelect Tail @39-FCB6E20C
    }
//End BeforeSelect Tail

//RICHIESTA_GRIDHandler Tail @39-FCB6E20C
}
//End RICHIESTA_GRIDHandler Tail

