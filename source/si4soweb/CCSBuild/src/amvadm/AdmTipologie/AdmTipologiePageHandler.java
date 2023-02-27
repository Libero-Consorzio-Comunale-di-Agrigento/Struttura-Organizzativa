//AdmTipologieHandler imports @1-7174147D
package amvadm.AdmTipologie;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmTipologieHandler imports

//AdmTipologieHandler Head @1-A9FC75E2
public class AdmTipologiePageHandler implements PageListener {
//End AdmTipologieHandler Head

//AfterInitialize Head @1-89E84600
    public void afterInitialize(Event e) {
//End AfterInitialize Head

//AfterInitialize Tail @1-FCB6E20C
    }
//End AfterInitialize Tail

//OnInitializeView Head @1-E3C15E0F
    public void onInitializeView(Event e) {
//End OnInitializeView Head

//Event OnInitializeView Action Custom Code @44-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
  //SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVIF","common/images");
  SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVOPT","UPLOAD");

//End Event OnInitializeView Action Custom Code

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

//AdmTipologieHandler Tail @1-FCB6E20C
}
//End AdmTipologieHandler Tail

