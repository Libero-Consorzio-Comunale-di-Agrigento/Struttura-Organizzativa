//si4soiframe_srcHandler Head @6-B21420E7
package restrict.si4so;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class si4soiframe_srcHandler implements ControlListener {
//End si4soiframe_srcHandler Head

//BeforeShow Head @6-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Custom Code @7-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
String iframe;
String parametri;
String si4soapp;

si4soapp  = e.getPage().getHttpGetParameter("SI4SOAPP");
if (si4soapp == null || si4soapp.equals("")) si4soapp = "Si4so";

parametri = "CMD=" + e.getPage().getHttpGetParameter("CMD")+ 
			"&PANEL=" + e.getPage().getHttpGetParameter("PANEL");

iframe = "<iframe SRC=\"../../" + si4soapp + "/Si4so.htm?" + parametri + 
		    "\" WIDTH=100% HEIGHT=100% FRAMEBORDER=0></iframe>";


((Control) e.getSource()).setValue(iframe);
//End Event BeforeShow Action Custom Code

//BeforeShow Tail @6-FCB6E20C
    }
//End BeforeShow Tail

//si4soiframe_srcHandler Tail @6-FCB6E20C
}
//End si4soiframe_srcHandler Tail

