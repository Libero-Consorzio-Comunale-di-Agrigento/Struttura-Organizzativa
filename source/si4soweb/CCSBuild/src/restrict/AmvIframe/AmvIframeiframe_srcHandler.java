//AmvIframeiframe_srcHandler Head @6-071FB98A
package restrict.AmvIframe;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class AmvIframeiframe_srcHandler implements ControlListener {
//End AmvIframeiframe_srcHandler Head

//BeforeShow Head @6-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Custom Code @7-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
  	String iframe;
	String parametri;
	String src;

	src       = e.getPage().getHttpGetParameter("SRC");			
	parametri = e.getPage().getHttpGetParameter("PAR");			
	if (parametri == null) {
		parametri = "";
	} else {
		parametri = "?" + parametri.replaceAll("<and>","&");
	}
	iframe = "<iframe SRC=\"" + src + parametri +
		    "\" WIDTH=100% HEIGHT=100% FRAMEBORDER=0 id=\"AMVIFRAME\" name=\"AMVIFRAME\"></iframe>";

    ((Control) e.getSource()).setValue(iframe);

//End Event BeforeShow Action Custom Code

//BeforeShow Tail @6-FCB6E20C
    }
//End BeforeShow Tail

//AmvIframeiframe_srcHandler Tail @6-FCB6E20C
}
//End AmvIframeiframe_srcHandler Tail

