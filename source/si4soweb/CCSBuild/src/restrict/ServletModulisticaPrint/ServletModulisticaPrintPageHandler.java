//ServletModulisticaPrintHandler imports @1-DCB3EB2F
package restrict.ServletModulisticaPrint;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End ServletModulisticaPrintHandler imports

//ServletModulisticaPrintHandler Head @1-BD9745B1
public class ServletModulisticaPrintPageHandler implements PageListener {
//End ServletModulisticaPrintHandler Head

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

//Event BeforeShow Action Custom Code @7-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */

    String path = "/";
    String realPath = e.getPage().getRequest().getRealPath(path);
    it.finmatica.modulistica.Modulistica modello = new it.finmatica.modulistica.Modulistica(realPath);
    String ruolo = SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("Ruolo").toString();
	modello.genera(e.getPage().getRequest(),"CC");
	String corpo = modello.getValue();	
    ((com.codecharge.components.Label) (e.getPage().getChild( "corpoHtml" ))).setValue( corpo );

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

//ServletModulisticaPrintHandler Tail @1-FCB6E20C
}
//End ServletModulisticaPrintHandler Tail

