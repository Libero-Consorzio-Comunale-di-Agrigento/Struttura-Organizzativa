//RICHIESTA_GRIDSTATO_FUTUROHandler Head @69-B5E3CA2C
package common.AmvRichiestaConferma;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class RICHIESTA_GRIDSTATO_FUTUROHandler implements ControlListener {
//End RICHIESTA_GRIDSTATO_FUTUROHandler Head

//BeforeShow Head @69-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Custom Code @70-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
 SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVSF",e.getControl().getValue().toString());
 e.getControl().setVisible(false);
//End Event BeforeShow Action Custom Code

//BeforeShow Tail @69-FCB6E20C
    }
//End BeforeShow Tail

//RICHIESTA_GRIDSTATO_FUTUROHandler Tail @69-FCB6E20C
}
//End RICHIESTA_GRIDSTATO_FUTUROHandler Tail

