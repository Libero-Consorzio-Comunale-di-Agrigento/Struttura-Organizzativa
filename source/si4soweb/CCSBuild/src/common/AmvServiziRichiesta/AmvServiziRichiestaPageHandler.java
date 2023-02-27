//AmvServiziRichiestaHandler imports @1-4B8F2ABB
package common.AmvServiziRichiesta;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvServiziRichiestaHandler imports

//AmvServiziRichiestaHandler Head @1-DE66369B
public class AmvServiziRichiestaPageHandler implements PageListener {
//End AmvServiziRichiestaHandler Head

//AfterInitialize Head @1-89E84600
    public void afterInitialize(Event e) {
//End AfterInitialize Head

//Event AfterInitialize Action Custom Code @87-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
if (e.getPage().getRequest().getParameter("RR")  != null) {
   SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVRIC", null);
}

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

//AmvServiziRichiestaHandler Tail @1-FCB6E20C
}
//End AmvServiziRichiestaHandler Tail

