//AD4_RICHIESTE_ABILITAZIONEGridRICHIEDENTEHandler Head @35-144CD73E
package amvadm.AdmRichiesta;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class AD4_RICHIESTE_ABILITAZIONEGridRICHIEDENTEHandler implements ControlListener {
//End AD4_RICHIESTE_ABILITAZIONEGridRICHIEDENTEHandler Head

//BeforeShow Head @35-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Save Control Value @54-FE9753E8
        SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVUTE", ((com.codecharge.components.Hidden) ((com.codecharge.components.Grid) (e.getPage().getChild( "AD4_RICHIESTE_ABILITAZIONEGrid" ))).getChild( "UTENTE" )).getValue() );
//End Event BeforeShow Action Save Control Value

//BeforeShow Tail @35-FCB6E20C
    }
//End BeforeShow Tail

//AD4_RICHIESTE_ABILITAZIONEGridRICHIEDENTEHandler Tail @35-FCB6E20C
}
//End AD4_RICHIESTE_ABILITAZIONEGridRICHIEDENTEHandler Tail

