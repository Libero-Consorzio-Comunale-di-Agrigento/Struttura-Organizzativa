//AGENTEAGENTE_IDHandler Head @4-03EB57E6
package common.Footer;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class AGENTEAGENTE_IDHandler implements ControlListener {
//End AGENTEAGENTE_IDHandler Head

//BeforeShow Head @4-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Save Control Value @7-B8061F42
        SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("IDAgente", ((com.codecharge.components.Label) ((com.codecharge.components.Grid) (e.getPage().getChild( "AGENTE" ))).getChild( "AGENTE_ID" )).getValue() );
//End Event BeforeShow Action Save Control Value

//BeforeShow Tail @4-FCB6E20C
    }
//End BeforeShow Tail

//AGENTEAGENTE_IDHandler Tail @4-FCB6E20C
}
//End AGENTEAGENTE_IDHandler Tail

