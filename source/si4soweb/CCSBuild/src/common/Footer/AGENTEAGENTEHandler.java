//AGENTEAGENTEHandler Head @4-DCCBE1EE
package common.Footer;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class AGENTEAGENTEHandler implements ControlListener {
//End AGENTEAGENTEHandler Head

//BeforeShow Head @4-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Save Control Value @7-9BFA4892
        SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("Agente", ((com.codecharge.components.Label) ((com.codecharge.components.Grid) (e.getPage().getChild( "AGENTE" ))).getChild( "AGENTE" )).getValue() );
//End Event BeforeShow Action Save Control Value

//BeforeShow Tail @4-FCB6E20C
    }
//End BeforeShow Tail

//AGENTEAGENTEHandler Tail @4-FCB6E20C
}
//End AGENTEAGENTEHandler Tail

