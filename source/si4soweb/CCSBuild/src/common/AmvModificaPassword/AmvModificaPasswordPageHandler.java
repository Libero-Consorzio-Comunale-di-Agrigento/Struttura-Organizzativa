//AmvModificaPasswordHandler imports @1-AF4C3E0E
package common.AmvModificaPassword;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvModificaPasswordHandler imports

//AmvModificaPasswordHandler Head @1-4F4B540C
public class AmvModificaPasswordPageHandler implements PageListener {
//End AmvModificaPasswordHandler Head

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

//Event BeforeShow Action Custom Code @37-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
    String s = "Pagina non più valida.";
	if (!(e.getPage().getRecord("AD4_UTENTI").isEditMode())) {
		try {
			e.getPage().getRecord("AD4_UTENTI").setVisible(false);
			e.getPage().getControl("MSG").setValue(s);
			} catch (Exception ex)  {
			ex.printStackTrace();
		}
	} else {
	       e.getPage().getControl("MSG").setVisible(false);
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

//AmvModificaPasswordHandler Tail @1-FCB6E20C
}
//End AmvModificaPasswordHandler Tail

