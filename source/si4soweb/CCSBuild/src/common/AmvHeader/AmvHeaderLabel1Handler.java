//AmvHeaderLabel1Handler Head @68-3A1B2DFA
package common.AmvHeader;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class AmvHeaderLabel1Handler implements ControlListener {
//End AmvHeaderLabel1Handler Head

//BeforeShow Head @68-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Custom Code @69-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
 String s;
 s = "MVVC=" + SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVVC") + "<br>";
 s = s.concat("MVPC=" + SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVPC") + "<br>");
 s = s.concat("MVPP=" + SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVPP") + "<br>");
 s = s.concat("ActionPageName=" + e.getPage().getActionPageName() + "<br>");
 s = s.concat("ServletPath=" + e.getPage().getRequest().getServletPath());
 e.getControl().setValue(s);
//End Event BeforeShow Action Custom Code

//BeforeShow Tail @68-FCB6E20C
    }
//End BeforeShow Tail

//AmvHeaderLabel1Handler Tail @68-FCB6E20C
}
//End AmvHeaderLabel1Handler Tail

