//AmvLoginHandler imports @1-1DB5B012
package common.AmvLogin;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvLoginHandler imports

//AmvLoginHandler Head @1-2DF5CC59
public class AmvLoginPageHandler implements PageListener {
//End AmvLoginHandler Head

//AfterInitialize Head @1-89E84600
    public void afterInitialize(Event e) {
//End AfterInitialize Head

//Event AfterInitialize Action Custom Code @9-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
    SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVUTE", null);
	SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVPWD", null);

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

//AmvLoginHandler Tail @1-FCB6E20C
}
//End AmvLoginHandler Tail

