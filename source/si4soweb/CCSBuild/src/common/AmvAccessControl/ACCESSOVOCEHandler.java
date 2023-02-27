//ACCESSOVOCEHandler Head @4-6854B3CF
package common.AmvAccessControl;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class ACCESSOVOCEHandler implements ControlListener {
//End ACCESSOVOCEHandler Head

//BeforeShow Head @4-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Custom Code @11-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
 e.getControl().setVisible(false);
//End Event BeforeShow Action Custom Code

//BeforeShow Tail @4-FCB6E20C
    }
//End BeforeShow Tail

//ACCESSOVOCEHandler Tail @4-FCB6E20C
}
//End ACCESSOVOCEHandler Tail

