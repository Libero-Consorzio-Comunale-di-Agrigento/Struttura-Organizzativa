//AmvLogoutHandler imports @1-18C2C9C9
package common.AmvLogout;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import javax.servlet.http.*;

//End AmvLogoutHandler imports

//AmvLogoutHandler Head @1-A6C6603C
public class AmvLogoutPageHandler implements PageListener {
//End AmvLogoutHandler Head

//AfterInitialize Head @1-89E84600
    public void afterInitialize(Event e) {
//End AfterInitialize Head

//Event AfterInitialize Action Custom Code @3-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
  HttpSession s = e.getPage().getRequest().getSession();

  Cookie[] cookies = e.getPage().getRequest().getCookies();
  String cookies_str = "";
  int i;
  for(i=0; i < cookies.length; i++) {
  	Cookie thisCookie = cookies[i];
	thisCookie.setMaxAge(0);
	//cookies_str = cookies_str + " " + thisCookie.getName() + " = " + thisCookie.getValue() + "\n";
  }
  //e.getPage().getControl("cookies").setValue("Fatto!!");
  s.invalidate();

  //Principal pr = e.getPage().getRequest().getUserPrincipal();
  //pr = null;
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

//Event BeforeShow Action Custom Code @2-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
 
 try {
 	e.getPage().getResponse().sendRedirect("../common/Main.do"); 
 } catch (Exception ex)  {
	ex.printStackTrace();
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

//AmvLogoutHandler Tail @1-FCB6E20C
}
//End AmvLogoutHandler Tail

