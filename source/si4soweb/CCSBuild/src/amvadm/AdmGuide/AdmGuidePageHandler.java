//AdmGuideHandler imports @1-0602DDF9
package amvadm.AdmGuide;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmGuideHandler imports

//AdmGuideHandler Head @1-B0333CFD
public class AdmGuidePageHandler implements PageListener {
//End AdmGuideHandler Head

//AfterInitialize Head @1-89E84600
    public void afterInitialize(Event e) {
//End AfterInitialize Head

//Event AfterInitialize Action Custom Code @40-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
if (e.getPage().getRequest().getParameter("ID")  != null) {
   SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("Id",  e.getPage().getRequest().getParameter("ID") );
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

//AdmGuideHandler Tail @1-FCB6E20C
}
//End AdmGuideHandler Tail

