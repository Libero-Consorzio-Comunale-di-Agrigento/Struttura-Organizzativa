//AmvAccessNoControlHandler imports @1-41ADC1A4
package common.AmvAccessNoControl;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvAccessNoControlHandler imports

//AmvAccessNoControlHandler Head @1-504BB2F9
public class AmvAccessNoControlPageHandler implements PageListener {
//End AmvAccessNoControlHandler Head

//AfterInitialize Head @1-89E84600
    public void afterInitialize(Event e) {
//End AfterInitialize Head

//Event AfterInitialize Action Custom Code @2-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
 e.getPage().getRequest().setAttribute("ACCESSO", "SI");

//End Event AfterInitialize Action Custom Code

//AfterInitialize Tail @1-FCB6E20C
    }
//End AfterInitialize Tail

//OnInitializeView Head @1-E3C15E0F
    public void onInitializeView(Event e) {
//End OnInitializeView Head

//OnInitializeView Tail @1-FCB6E20C
    }
//End OnInitializeView Tail

//BeforeShow Head @1-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//BeforeShow Tail @1-FCB6E20C
    }
//End BeforeShow Tail

//BeforeUnload Head @1-1DDBA584
    public void beforeUnload(Event e) {
//End BeforeUnload Head

//BeforeUnload Tail @1-FCB6E20C
    }
//End BeforeUnload Tail

//AmvAccessNoControlHandler Tail @1-FCB6E20C
}
//End AmvAccessNoControlHandler Tail

