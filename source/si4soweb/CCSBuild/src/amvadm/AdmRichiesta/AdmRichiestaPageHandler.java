//AdmRichiestaHandler imports @1-EFDC9690
package amvadm.AdmRichiesta;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmRichiestaHandler imports

//AdmRichiestaHandler Head @1-C3891BDB
public class AdmRichiestaPageHandler implements PageListener {
//End AdmRichiestaHandler Head

//AfterInitialize Head @1-89E84600
    public void afterInitialize(Event e) {
//End AfterInitialize Head

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

//Event BeforeShow Action Custom Code @6-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
if (e.getPage().getRequest().getParameter("STATO") != null) {
   if (e.getPage().getRequest().getParameter("STATO").equals("F")) {
      //e.getPage().getButton("Button_Delete").setVisible( false );
   }
}
//End Event BeforeShow Action Custom Code

//BeforeShow Tail @1-FCB6E20C
    }
//End BeforeShow Tail

//BeforeUnload Head @1-1DDBA584
    public void beforeUnload(Event e) {
//End BeforeUnload Head

//BeforeUnload Tail @1-FCB6E20C
    }
//End BeforeUnload Tail

//AdmRichiestaHandler Tail @1-FCB6E20C
}
//End AdmRichiestaHandler Tail

